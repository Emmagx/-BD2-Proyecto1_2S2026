import pandas as pd

print("Procesando 04_MEDALLA...")

df_res = pd.read_csv('results(1).csv', low_memory=False)

df_res['Medal'] = df_res['Medal'].fillna('No medal')
medallas_unicas = df_res['Medal'].dropna().unique()

df_medalla = pd.DataFrame({'NOMBRE': medallas_unicas})

df_medalla.insert(0, 'ID', range(1, len(df_medalla) + 1))
df_medalla.to_csv('4_MEDALLA.csv', index=False)

print(f"4_MEDALLA.csv generado con {len(df_medalla)} registros.")