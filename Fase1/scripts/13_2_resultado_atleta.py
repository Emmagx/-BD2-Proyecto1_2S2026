import pandas as pd
import numpy as np
import re

print("Procesando 13_RESULTADO_ATLETA (Version Preservacion Total)...")

df_res_crudo = pd.read_csv('results(1).csv', low_memory=False)
df_events = pd.read_csv('athlete_events.csv', low_memory=False)

df_resultado = pd.read_csv('12_RESULTADO.csv')
df_pais = pd.read_csv('1_PAIS.csv')
df_olimpiada = pd.read_csv('3_OLIMPIADA.csv') # Carga el nuevo catálogo expandido
df_evento = pd.read_csv('9_EVENTO.csv')       # Carga el nuevo catálogo expandido
df_medalla = pd.read_csv('4_MEDALLA.csv')

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

df_res_crudo['PLACE'] = df_res_crudo['Pos'].apply(limpiar_lugar)
df_res_crudo['STATE'] = df_res_crudo['Pos'].apply(obtener_estado)
df_res_crudo['TIED'] = df_res_crudo['Pos'].astype(str).str.contains('=')

# APLICAMOS LA MISMA LÓGICA DE EXTRACCIÓN QUE EN EL SCRIPT 12
df_res_crudo['YEAR'] = df_res_crudo['Games'].str.extract(r'(\d{4})').astype(float).fillna(0)
df_res_crudo['SEASON'] = df_res_crudo['Games'].str.extract(r'(Summer|Winter)').fillna('Unknown')

df_res_crudo = df_res_crudo.merge(df_olimpiada, on=['SEASON', 'YEAR'], how='left').rename(columns={'ID': 'ID_OLIMPIADA'})
df_res_crudo = df_res_crudo.merge(df_evento[['ID', 'NOMBRE']], left_on='Event', right_on='NOMBRE', how='left').rename(columns={'ID': 'ID_EVENTO'})

df_res_crudo['Medal'] = df_res_crudo['Medal'].fillna('No medal')
df_res_crudo = df_res_crudo.merge(df_medalla[['ID', 'NOMBRE']], left_on='Medal', right_on='NOMBRE', how='left').rename(columns={'ID': 'ID_MEDALLA'})
df_res_crudo = df_res_crudo.merge(df_pais[['ID', 'NOC']], on='NOC', how='left').rename(columns={'ID': 'ID_PAIS_REPRESENTA'})

df_res_crudo['ID_MEDALLA'] = df_res_crudo['ID_MEDALLA'].astype('Int64')
df_res_crudo['ID_OLIMPIADA'] = df_res_crudo['ID_OLIMPIADA'].astype('Int64')
df_res_crudo['ID_EVENTO'] = df_res_crudo['ID_EVENTO'].astype('Int64')

df_final = df_res_crudo.merge(
    df_resultado.rename(columns={'ID': 'ID_RESULTADO'}),
    on=['TIED', 'PLACE', 'STATE', 'ID_MEDALLA', 'ID_OLIMPIADA', 'ID_EVENTO'],
    how='inner'
)

df_edades = df_events[['ID', 'Age']].rename(columns={'ID': 'athlete_id'})
df_edades = df_edades.dropna(subset=['Age']).drop_duplicates(subset=['athlete_id'])

df_final = df_final.merge(df_edades, on='athlete_id', how='left')
df_final['EDAD'] = df_final['Age'].astype('Int64')
df_final['ID_PAIS_REPRESENTA'] = df_final['ID_PAIS_REPRESENTA'].astype('Int64')
df_final = df_final.rename(columns={'athlete_id': 'ID_ATLETA'})

df_res_atl = df_final[['EDAD', 'ID_ATLETA', 'ID_RESULTADO', 'ID_PAIS_REPRESENTA']]

df_res_atl = df_res_atl.drop_duplicates(subset=['ID_ATLETA', 'ID_RESULTADO']).reset_index(drop=True)
df_res_atl.insert(0, 'ID', range(1, len(df_res_atl) + 1))

df_res_atl.to_csv('13_RESULTADO_ATLETA.csv', index=False)
print("13_RESULTADO_ATLETA.csv generado con exito.")
