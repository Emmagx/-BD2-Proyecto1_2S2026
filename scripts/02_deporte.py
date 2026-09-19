import pandas as pd

print("Procesando 02_DEPORTE...")

df_res = pd.read_csv('results(1).csv', low_memory=False)

# En Olympedia, Discipline equivale al Deporte principal (ej. Athletics, Tennis)
deportes_unicos = df_res['Discipline'].dropna().unique()
df_deporte = pd.DataFrame({'NOMBRE': deportes_unicos})

df_deporte.insert(0, 'ID', range(1, len(df_deporte) + 1))
df_deporte.to_csv('2_DEPORTE.csv', index=False)

print(f"2_DEPORTE.csv generado con {len(df_deporte)} registros.")