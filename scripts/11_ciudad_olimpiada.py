import pandas as pd

print("Procesando 11_CIUDAD_OLIMPIADA...")

df_events = pd.read_csv('athlete_events.csv', low_memory=False)
df_olimpiada = pd.read_csv('3_OLIMPIADA.csv').rename(columns={'ID': 'ID_OLIMPIADA'})
df_ciudad = pd.read_csv('8_CIUDAD.csv').rename(columns={'ID': 'ID_CIUDAD'})

df_host = df_events[['City', 'Season', 'Year']].drop_duplicates()

# --- EL CAMBIO CLAVE AQUI ---
# Aplicamos el mismo diccionario de traducción del script 8
diccionario_sedes = {
    'Mexico City': 'Ciudad de México (Mexico City)',
    'Athina': 'Athens',
    'Moskva': 'Moscow',
    'Munich': 'München',
    'Montreal': 'Montréal',
    'Antwerpen': 'Antwerp',
    'St. Louis': 'Saint Louis'
}
df_host['City'] = df_host['City'].replace(diccionario_sedes)
# -----------------------------

# Ahora los cruces serán perfectos
df_host = df_host.merge(df_olimpiada, left_on=['Season', 'Year'], right_on=['SEASON', 'YEAR'], how='inner')
df_host = df_host.merge(df_ciudad[['ID_CIUDAD', 'NOMBRE']], left_on='City', right_on='NOMBRE', how='left')

df_host['ID_CIUDAD'] = df_host['ID_CIUDAD'].astype('Int64')

df_ciudad_olim = df_host[['ID_OLIMPIADA', 'ID_CIUDAD']].drop_duplicates().reset_index(drop=True)

df_ciudad_olim.to_csv('11_CIUDAD_OLIMPIADA.csv', index=False)

print("11_CIUDAD_OLIMPIADA.csv generado con exito.")
