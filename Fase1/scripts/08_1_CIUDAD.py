import pandas as pd

print("Procesando 08_CIUDAD (Con unificacion de sedes)...")

df_bios = pd.read_csv('bios_locs.csv', low_memory=False)
df_events = pd.read_csv('athlete_events.csv', low_memory=False)
df_region = pd.read_csv('5_REGION.csv')

# 1. Extraer ciudades de nacimiento
df_ciudades_nac = df_bios[['born_city', 'born_region', 'lat', 'long']].dropna(subset=['born_city']).copy()
df_ciudades_nac = df_ciudades_nac.rename(columns={'born_city': 'NOMBRE'})

# 2. Extraer ciudades anfitrionas y UNIFICAR NOMBRES
df_ciudades_anf = df_events[['City']].dropna().drop_duplicates().copy()
df_ciudades_anf = df_ciudades_anf.rename(columns={'City': 'NOMBRE'})

# DICCIONARIO DE CORRECCIÓN: Arreglamos las diferencias de idioma y escritura
diccionario_sedes = {
    'Mexico City': 'Ciudad de México (Mexico City)',
    'Athina': 'Athens',
    'Moskva': 'Moscow',
    'Munich': 'München',
    'Montreal': 'Montréal',
    'Antwerpen': 'Antwerp',
    'St. Louis': 'Saint Louis'
    # Squaw Valley, Chamonix y Cortina d'Ampezzo se quedan tal cual (son sedes genuinas sin nacimientos)
}
df_ciudades_anf['NOMBRE'] = df_ciudades_anf['NOMBRE'].replace(diccionario_sedes)

# 3. Concatenar ambas listas de ciudades
df_ciudad = pd.concat([df_ciudades_nac, df_ciudades_anf], ignore_index=True)

# Quitar duplicados priorizando las filas que si tienen info de region/lat/long
df_ciudad = df_ciudad.sort_values(by=['born_region']).drop_duplicates(subset=['NOMBRE'], keep='first').reset_index(drop=True)

# 4. Cruzar con Region (Aplicando la técnica limpia con drop)
df_ciudad = df_ciudad.merge(df_region[['ID', 'NOMBRE']], left_on='born_region', right_on='NOMBRE', how='left')

# Eliminamos las columnas sobrantes del cruce para evitar nombres duplicados
df_ciudad = df_ciudad.drop(columns=['NOMBRE_y', 'born_region'])

df_ciudad = df_ciudad.rename(columns={
    'NOMBRE_x': 'NOMBRE', 
    'ID': 'ID_REGION', 
    'lat': 'LAT', 
    'long': 'LONG'
})

# Limpiar para base de datos (permitiendo Nulos reales con Int64)
df_ciudad['ID_REGION'] = df_ciudad['ID_REGION'].astype('Int64')
df_ciudad = df_ciudad[['NOMBRE', 'LAT', 'LONG', 'ID_REGION']]

df_ciudad.insert(0, 'ID', range(1, len(df_ciudad) + 1))
df_ciudad.to_csv('8_CIUDAD.csv', index=False)

print("8_CIUDAD.csv generado con exito (incluye anfitrionas unificadas).")