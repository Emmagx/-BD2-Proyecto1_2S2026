import pandas as pd
import numpy as np

print("Procesando 01_PAIS (Version con Mapeo Puro de Olympedia y Filtro de Anomalías)...")

df_bios = pd.read_csv('bios_locs.csv', low_memory=False)
df_res = pd.read_csv('results(1).csv', low_memory=False)

# 1. Obtener mapeo NOC a NOMBRE usando el athlete_id
df_bios_nom = df_bios[['athlete_id', 'NOC']].dropna().rename(columns={'NOC': 'NOMBRE'})
df_res_noc = df_res[['athlete_id', 'NOC']].dropna()

df_mapeo = df_res_noc.merge(df_bios_nom, on='athlete_id')
df_mapeo = df_mapeo[['NOC', 'NOMBRE']].drop_duplicates().reset_index(drop=True)

# 2. Agregar territorios de nacimiento que no compitieron (solo códigos válidos de 3 letras mayúsculas)
df_born = df_bios[['born_country']].dropna().rename(columns={'born_country': 'NOMBRE'}).drop_duplicates()
df_born_missing = df_born[~df_born['NOMBRE'].isin(df_mapeo['NOMBRE']) & ~df_born['NOMBRE'].isin(df_mapeo['NOC'])].copy()

# AQUI QUITAMOS LAS ANOMALIAS (Cologne, Spreewald, Aarhus, etc.)
# Solo conservamos aquellos que sean codigos de territorio de 3 letras (ej. CUR, FPN, GRL)
df_born_missing = df_born_missing[df_born_missing['NOMBRE'].str.match(r'^[A-Z]{3}$')]
# Como son puros codigos territoriales, los colocamos en NOC, y dejamos el NOMBRE igual al NOC (ya que no tenemos el nombre completo en la base de datos)
df_born_missing['NOC'] = df_born_missing['NOMBRE']

# 3. Concatenar todo para tener el catálogo final
df_pais_final = pd.concat([df_mapeo, df_born_missing], ignore_index=True)

df_con_noc = df_pais_final.dropna(subset=['NOC']).drop_duplicates(subset=['NOC'], keep='first')
df_sin_noc = df_pais_final[df_pais_final['NOC'].isna()].drop_duplicates(subset=['NOMBRE'])

df_pais_final = pd.concat([df_con_noc, df_sin_noc]).reset_index(drop=True)

# Generar ID
df_pais_final.insert(0, 'ID', range(1, len(df_pais_final) + 1))
df_pais_final.to_csv('1_PAIS.csv', index=False)

print(f"1_PAIS.csv generado con {len(df_pais_final)} registros. ¡Anomalías geográficas eliminadas con éxito!")