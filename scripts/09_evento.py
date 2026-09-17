import pandas as pd
import re

print("Procesando 09_EVENTO (Con corrección de Cartesian Join)...")

df_res = pd.read_csv('results(1).csv', low_memory=False)
df_disciplina = pd.read_csv('6_DISCIPLINA.csv')
df_deporte = pd.read_csv('2_DEPORTE.csv')

def obtener_disciplina(fila):
    e = str(fila['Event'])
    cleaned = re.sub(r',\s*(Men|Women|Mixed).*$', '', e)
    cleaned = re.sub(r'\s*\(Olympic.*?\)', '', cleaned)
    return cleaned.strip()

# Obtener Event y Discipline (que es el Deporte en Olympedia)
df_base = df_res[['Event', 'Discipline']].dropna().drop_duplicates()
df_base['NOMBRE'] = df_base['Event']
df_base['NOMBRE_DISCIPLINA'] = df_base.apply(obtener_disciplina, axis=1)

# Primero encontramos el ID_DEPORTE
df_base = df_base.merge(df_deporte[['ID', 'NOMBRE']], left_on='Discipline', right_on='NOMBRE', how='left', suffixes=('', '_dep'))
df_base = df_base.rename(columns={'ID': 'ID_DEPORTE'})

# Ahora cruzamos con Disciplina usando NOMBRE y ID_DEPORTE para no duplicar eventos que se llaman igual (ej. "Singles")
df_evento = df_base.merge(df_disciplina[['ID', 'NOMBRE', 'ID_DEPORTE']], 
                          left_on=['NOMBRE_DISCIPLINA', 'ID_DEPORTE'], 
                          right_on=['NOMBRE', 'ID_DEPORTE'], 
                          how='inner', 
                          suffixes=('', '_disc'))

df_evento = df_evento.rename(columns={'ID': 'ID_DISCIPLINA'})
# Limpiar el DataFrame final
df_evento = df_evento[['NOMBRE', 'ID_DISCIPLINA']].drop_duplicates().reset_index(drop=True)

df_evento.insert(0, 'ID', range(1, len(df_evento) + 1))
df_evento.to_csv('9_EVENTO.csv', index=False)

print(f"9_EVENTO.csv generado con {len(df_evento)} registros sin duplicar nombres base.")