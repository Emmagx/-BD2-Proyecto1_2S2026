import pandas as pd
import numpy as np
import re

print("Procesando 13_RESULTADO_ATLETA (Version Optimizada con base Olympedia)...")

df_res_crudo = pd.read_csv('results(1).csv', low_memory=False)
df_bios = pd.read_csv('bios_locs.csv', low_memory=False)

df_resultado = pd.read_csv('12_RESULTADO.csv')
df_pais = pd.read_csv('1_PAIS.csv')
df_olimpiada = pd.read_csv('3_OLIMPIADA.csv')
df_evento = pd.read_csv('9_EVENTO.csv')
df_disciplina = pd.read_csv('6_DISCIPLINA.csv')
df_deporte = pd.read_csv('2_DEPORTE.csv')
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

def obtener_disciplina(fila):
    e = str(fila['Event'])
    cleaned = re.sub(r',\s*(Men|Women|Mixed).*$', '', e)
    cleaned = re.sub(r'\s*\(Olympic.*?\)', '', cleaned)
    return cleaned.strip()

# Calculamos atributos
df_res_crudo['PLACE'] = df_res_crudo['Pos'].apply(limpiar_lugar)
df_res_crudo['STATE'] = df_res_crudo['Pos'].apply(obtener_estado)
df_res_crudo['TIED'] = df_res_crudo['Pos'].astype(str).str.contains('=')
df_res_crudo['YEAR'] = df_res_crudo['Games'].str.extract(r'(\d{4})').astype(float).fillna(0).astype(int)
df_res_crudo['SEASON'] = df_res_crudo['Games'].str.extract(r'(Summer|Winter)').fillna('Unknown')

df_res_crudo = df_res_crudo.merge(df_olimpiada, on=['SEASON', 'YEAR'], how='left').rename(columns={'ID': 'ID_OLIMPIADA'})

# Para encontrar el ID_EVENTO sin producto cartesiano, seguimos la jerarquia: Deporte -> Disciplina -> Evento
df_res_crudo = df_res_crudo.merge(df_deporte[['ID', 'NOMBRE']], left_on='Discipline', right_on='NOMBRE', how='left').rename(columns={'ID': 'ID_DEPORTE'})
df_res_crudo = df_res_crudo.drop(columns=['NOMBRE'])
df_res_crudo['NOMBRE_DISCIPLINA'] = df_res_crudo.apply(obtener_disciplina, axis=1)

df_res_crudo = df_res_crudo.merge(df_disciplina[['ID', 'NOMBRE', 'ID_DEPORTE']], 
                                  left_on=['NOMBRE_DISCIPLINA', 'ID_DEPORTE'], 
                                  right_on=['NOMBRE', 'ID_DEPORTE'], 
                                  how='left').rename(columns={'ID': 'ID_DISCIPLINA'})
df_res_crudo = df_res_crudo.drop(columns=['NOMBRE'])

df_res_crudo = df_res_crudo.merge(df_evento[['ID', 'NOMBRE', 'ID_DISCIPLINA']], 
                                  left_on=['Event', 'ID_DISCIPLINA'], 
                                  right_on=['NOMBRE', 'ID_DISCIPLINA'], 
                                  how='left').rename(columns={'ID': 'ID_EVENTO'})
df_res_crudo = df_res_crudo.drop(columns=['NOMBRE'])

df_res_crudo['Medal'] = df_res_crudo['Medal'].fillna('No medal')
df_res_crudo = df_res_crudo.merge(df_medalla[['ID', 'NOMBRE']], left_on='Medal', right_on='NOMBRE', how='left').rename(columns={'ID': 'ID_MEDALLA'})
df_res_crudo = df_res_crudo.drop(columns=['NOMBRE'])
df_res_crudo = df_res_crudo.merge(df_pais[['ID', 'NOC']], on='NOC', how='left').rename(columns={'ID': 'ID_PAIS_REPRESENTA'})

df_res_crudo['ID_MEDALLA'] = df_res_crudo['ID_MEDALLA'].astype('Int64')
df_res_crudo['ID_OLIMPIADA'] = df_res_crudo['ID_OLIMPIADA'].astype('Int64')
df_res_crudo['ID_EVENTO'] = df_res_crudo['ID_EVENTO'].astype('Int64')

# Cruce con RESULTADO
df_final = df_res_crudo.merge(
    df_resultado.rename(columns={'ID': 'ID_RESULTADO'}),
    on=['TIED', 'PLACE', 'STATE', 'ID_MEDALLA', 'ID_OLIMPIADA', 'ID_EVENTO'],
    how='inner'
)

# Calcular Edad
df_final = df_final.merge(df_bios[['athlete_id', 'born_date']], on='athlete_id', how='left')
df_final['born_year'] = df_final['born_date'].str.extract(r'(\d{4})').astype(float)
df_final['EDAD'] = df_final['YEAR'] - df_final['born_year']
df_final.loc[(df_final['EDAD'] < 10) | (df_final['EDAD'] > 100), 'EDAD'] = np.nan

df_final['EDAD'] = df_final['EDAD'].astype('Int64')
df_final['ID_PAIS_REPRESENTA'] = df_final['ID_PAIS_REPRESENTA'].astype('Int64')
df_final = df_final.rename(columns={'athlete_id': 'ID_ATLETA'})

df_res_atl = df_final[['EDAD', 'ID_ATLETA', 'ID_RESULTADO', 'ID_PAIS_REPRESENTA']]

# Eliminar duplicados
df_res_atl = df_res_atl.drop_duplicates(subset=['ID_ATLETA', 'ID_RESULTADO']).reset_index(drop=True)
df_res_atl.insert(0, 'ID', range(1, len(df_res_atl) + 1))

df_res_atl.to_csv('13_RESULTADO_ATLETA.csv', index=False)
print(f"13_RESULTADO_ATLETA.csv generado con {len(df_res_atl)} registros (Sin multiplicacion cartesiana).")