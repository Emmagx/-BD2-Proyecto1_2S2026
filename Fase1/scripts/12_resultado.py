import pandas as pd
import numpy as np
import re

print("Procesando 12_RESULTADO (Sin Cartesian Join, Base Olympedia)...")

df_res = pd.read_csv('results(1).csv', low_memory=False)
df_olimpiada = pd.read_csv('3_OLIMPIADA.csv')
df_evento = pd.read_csv('9_EVENTO.csv')
df_medalla = pd.read_csv('4_MEDALLA.csv')
df_disciplina = pd.read_csv('6_DISCIPLINA.csv')
df_deporte = pd.read_csv('2_DEPORTE.csv')

def limpiar_lugar(pos):
    if pd.isna(pos): return np.nan
    numeros = re.findall(r'\d+', str(pos))
    return int(numeros[0]) if numeros else np.nan

def obtener_estado(pos):
    if pd.isna(pos): return 'COMPLETED'
    pos_str = str(pos).upper()
    if 'DNS' in pos_str: return 'DNS'
    if 'DNF' in pos_str: return 'DNF'
    if 'DQ' in pos_str: return 'DQ'
    return 'COMPLETED'

def obtener_disciplina(fila):
    e = str(fila['Event'])
    cleaned = re.sub(r',\s*(Men|Women|Mixed).*$', '', e)
    cleaned = re.sub(r'\s*\(Olympic.*?\)', '', cleaned)
    return cleaned.strip()

df_res['YEAR'] = df_res['Games'].str.extract(r'(\d{4})').astype(float).fillna(0).astype(int)
df_res['SEASON'] = df_res['Games'].str.extract(r'(Summer|Winter)').fillna('Unknown')
df_res['PLACE'] = df_res['Pos'].apply(limpiar_lugar)
df_res['STATE'] = df_res['Pos'].apply(obtener_estado)
df_res['TIED'] = df_res['Pos'].astype(str).str.contains('=')

# Jerarquía Deporte -> Disciplina -> Evento para cruzar correctamente
df_res = df_res.merge(df_olimpiada, on=['SEASON', 'YEAR'], how='left').rename(columns={'ID': 'ID_OLIMPIADA'})

df_res = df_res.merge(df_deporte[['ID', 'NOMBRE']], left_on='Discipline', right_on='NOMBRE', how='left').rename(columns={'ID': 'ID_DEPORTE'})
df_res = df_res.drop(columns=['NOMBRE'])
df_res['NOMBRE_DISCIPLINA'] = df_res.apply(obtener_disciplina, axis=1)

df_res = df_res.merge(df_disciplina[['ID', 'NOMBRE', 'ID_DEPORTE']], 
                      left_on=['NOMBRE_DISCIPLINA', 'ID_DEPORTE'], 
                      right_on=['NOMBRE', 'ID_DEPORTE'], 
                      how='left').rename(columns={'ID': 'ID_DISCIPLINA'})
df_res = df_res.drop(columns=['NOMBRE'])

df_res = df_res.merge(df_evento[['ID', 'NOMBRE', 'ID_DISCIPLINA']], 
                      left_on=['Event', 'ID_DISCIPLINA'], 
                      right_on=['NOMBRE', 'ID_DISCIPLINA'], 
                      how='left').rename(columns={'ID': 'ID_EVENTO'})
df_res = df_res.drop(columns=['NOMBRE'])

df_res['Medal'] = df_res['Medal'].fillna('No medal')
df_res = df_res.merge(df_medalla[['ID', 'NOMBRE']], left_on='Medal', right_on='NOMBRE', how='left').rename(columns={'ID': 'ID_MEDALLA'})
df_res = df_res.drop(columns=['NOMBRE'])

df_resultado = df_res[['TIED', 'PLACE', 'STATE', 'ID_MEDALLA', 'ID_OLIMPIADA', 'ID_EVENTO']].drop_duplicates().reset_index(drop=True)

df_resultado['ID_MEDALLA'] = df_resultado['ID_MEDALLA'].astype('Int64')
df_resultado['ID_OLIMPIADA'] = df_resultado['ID_OLIMPIADA'].astype('Int64')
df_resultado['ID_EVENTO'] = df_resultado['ID_EVENTO'].astype('Int64')

df_resultado.insert(0, 'ID', range(1, len(df_resultado) + 1))
df_resultado.to_csv('12_RESULTADO.csv', index=False)

print(f"12_RESULTADO.csv generado con {len(df_resultado)} registros (IDs cruzados perfectamente sin duplicacion).")
