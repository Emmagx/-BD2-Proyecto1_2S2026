import pandas as pd

print("Procesando 10_ATLETA...")

df_bios = pd.read_csv('bios_locs.csv', low_memory=False)
df_ciudad = pd.read_csv('8_CIUDAD.csv').rename(columns={'ID': 'ID_CIUDAD'})
df_res = pd.read_csv('results(1).csv', low_memory=False)

# 1. Deducir el SEXO basandose en los eventos en los que participo el atleta
# Si el evento dice "Men", asumimos M. Si dice "Women", asumimos F.
def inferir_sexo(x):
    if pd.isna(x): return None
    s = str(x)
    if 'Women' in s: return 'F'
    if 'Men' in s: return 'M'
    return None

df_res['SEXO'] = df_res['Event'].apply(inferir_sexo)
df_sexo = df_res.dropna(subset=['SEXO']).groupby('athlete_id')['SEXO'].first().reset_index()

df_atleta = df_bios.merge(df_sexo, on='athlete_id', how='left')

# 2. Hacemos el cruce con CIUDAD (como ya estaba)
df_atleta = df_atleta.merge(df_ciudad[['ID_CIUDAD', 'NOMBRE']], left_on='born_city', right_on='NOMBRE', how='left')
df_atleta = df_atleta.drop(columns=['NOMBRE'])

# 3. Renombramos columnas a tu estandar 3NF
df_atleta = df_atleta.rename(columns={
    'athlete_id': 'ID', 
    'name': 'NOMBRE', 
    'born_date': 'BORN_DATE', 
    'died_date': 'DIED_DATE', 
    'height_cm': 'ALTURA', 
    'weight_kg': 'PESO', 
    'ID_CIUDAD': 'ID_CITY_NACIMIENTO'
})

df_atleta['ID_CITY_NACIMIENTO'] = df_atleta['ID_CITY_NACIMIENTO'].astype('Int64')

# Seleccionar solo las columnas finales
df_atleta = df_atleta[['ID', 'NOMBRE', 'BORN_DATE', 'DIED_DATE', 'ALTURA', 'PESO', 'SEXO', 'ID_CITY_NACIMIENTO']]

# Eliminar duplicados
df_atleta = df_atleta.drop_duplicates(subset=['ID']).reset_index(drop=True)

df_atleta.to_csv('10_ATLETA.csv', index=False)

print(f"10_ATLETA.csv generado con {len(df_atleta)} registros.")