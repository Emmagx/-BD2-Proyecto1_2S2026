import pandas as pd

print("Procesando 05_REGION...")

df_bios = pd.read_csv('bios_locs.csv', low_memory=False)
df_pais = pd.read_csv('1_PAIS.csv')

# Usar born_region de bios_locs.csv
df_region = df_bios[['born_region', 'born_country']].dropna().drop_duplicates()
df_region = df_region.rename(columns={'born_region': 'NOMBRE'})

# Cruce con PAIS usando tecnica de 'melt' para buscar tanto en NOMBRE como en NOC
df_pais_melt = pd.melt(df_pais, id_vars=['ID'], value_vars=['NOC', 'NOMBRE'], value_name='country_key').dropna().drop_duplicates()

df_region = df_region.merge(df_pais_melt[['ID', 'country_key']], left_on='born_country', right_on='country_key', how='left')
df_region = df_region.rename(columns={'ID': 'ID_PAIS'})

df_region['ID_PAIS'] = df_region['ID_PAIS'].astype('Int64')
df_region = df_region[['NOMBRE', 'ID_PAIS']]
# Puede haber regiones duplicadas si estaban en paises distintos (o el cruce generó nulos por errores del dataset)
df_region = df_region.drop_duplicates(subset=['NOMBRE']).reset_index(drop=True)

df_region.insert(0, 'ID', range(1, len(df_region) + 1))
df_region.to_csv('5_REGION.csv', index=False)

print("5_REGION.csv generado con exito (cruce optimizado con pais.csv).")