import pandas as pd

print("Procesando 07_POBLACION...")

df_pop = pd.read_csv('populations.csv')
df_pais = pd.read_csv('1_PAIS.csv')

# Filtrar las columnas necesarias (Años de 1960 en adelante)
columnas_anios = [col for col in df_pop.columns if col.isnumeric()]
df_pop = df_pop.melt(id_vars=['Country Name'], value_vars=columnas_anios, var_name='YEAR', value_name='CANTIDAD')
df_pop = df_pop.rename(columns={'Country Name': 'Country'})

# Eliminar nulos en poblacion
df_pop = df_pop.dropna(subset=['CANTIDAD']).reset_index(drop=True)

# Cruce con PAIS usando tecnica de 'melt' para buscar en NOC y NOMBRE
df_pais_melt = pd.melt(df_pais, id_vars=['ID'], value_vars=['NOC', 'NOMBRE'], value_name='country_key').dropna().drop_duplicates()

df_pop = df_pop.merge(df_pais_melt[['ID', 'country_key']], left_on='Country', right_on='country_key', how='inner')
df_pop = df_pop.rename(columns={'ID': 'ID_PAIS'})

df_pop['YEAR'] = df_pop['YEAR'].astype(int)
df_pop['CANTIDAD'] = df_pop['CANTIDAD'].astype(float)
df_pop['ID_PAIS'] = df_pop['ID_PAIS'].astype('Int64')

df_poblacion = df_pop[['YEAR', 'CANTIDAD', 'ID_PAIS']].drop_duplicates().reset_index(drop=True)

df_poblacion.insert(0, 'ID', range(1, len(df_poblacion) + 1))
df_poblacion.to_csv('7_POBLACION.csv', index=False)

print(f"7_POBLACION.csv generado con {len(df_poblacion)} registros.")