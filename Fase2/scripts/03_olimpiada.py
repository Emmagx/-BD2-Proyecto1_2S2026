import pandas as pd
import re

print("Procesando 03_OLIMPIADA...")

df_res = pd.read_csv('results(1).csv', low_memory=False)

df_olimpiada = df_res[['Games']].dropna().drop_duplicates().reset_index(drop=True)

df_olimpiada['YEAR'] = df_olimpiada['Games'].str.extract(r'(\d{4})').astype(float).fillna(0).astype(int)
df_olimpiada['SEASON'] = df_olimpiada['Games'].str.extract(r'(Summer|Winter)').fillna('Unknown')

df_olimpiada = df_olimpiada[['SEASON', 'YEAR']].drop_duplicates().reset_index(drop=True)

df_olimpiada.insert(0, 'ID', range(1, len(df_olimpiada) + 1))
df_olimpiada.to_csv('3_OLIMPIADA.csv', index=False)

print(f"3_OLIMPIADA.csv generado con {len(df_olimpiada)} registros.")