import pandas as pd
import re

print("Procesando 06_DISCIPLINA...")

df_res = pd.read_csv('results(1).csv', low_memory=False)
df_deporte = pd.read_csv('2_DEPORTE.csv')

def obtener_disciplina(fila):
    e = str(fila['Event'])
    # Remover tags de genero como ", Men", ", Women", ", Mixed" o sufijos similares
    cleaned = re.sub(r',\s*(Men|Women|Mixed).*$', '', e)
    # Si no habia tag de genero pero hay un tag de (Olympic), removerlo tambien
    cleaned = re.sub(r'\s*\(Olympic.*?\)', '', cleaned)
    # Limpiar espacios
    return cleaned.strip()

df_base = df_res[['Discipline', 'Event']].dropna().drop_duplicates()
df_base['NOMBRE'] = df_base.apply(obtener_disciplina, axis=1)

# Extraer disciplinas únicas asociadas a su deporte (Discipline -> Deporte)
df_disciplina = df_base[['NOMBRE', 'Discipline']].drop_duplicates().reset_index(drop=True)

df_disciplina = df_disciplina.merge(df_deporte, left_on='Discipline', right_on='NOMBRE', how='left', suffixes=('', '_dep'))
df_disciplina = df_disciplina.rename(columns={'ID': 'ID_DEPORTE'})
df_disciplina = df_disciplina[['NOMBRE', 'ID_DEPORTE']]

df_disciplina.insert(0, 'ID', range(1, len(df_disciplina) + 1))
df_disciplina.to_csv('6_DISCIPLINA.csv', index=False)

print(f"6_DISCIPLINA.csv generado con {len(df_disciplina)} registros.")