import os
import pandas as pd

DEPORTE = "Archery"  # Ejemplos: Golf, Archery, Handball

print(f"=== Filtrando 13_RESULTADO_ATLETA para el deporte: '{DEPORTE}' ===")

# 1. Cargar catalogos y tablas necesarias
df_deporte = pd.read_csv("csv-limpios/2_DEPORTE.csv")
df_disciplina = pd.read_csv("csv-limpios/6_DISCIPLINA.csv")
df_evento = pd.read_csv("csv-limpios/9_EVENTO.csv")
df_resultado = pd.read_csv("csv-limpios/12_RESULTADO.csv")
df_res_atleta = pd.read_csv("csv-limpios/13_RESULTADO_ATLETA.csv")

# 2. Buscar el deporte
match_deporte = df_deporte[df_deporte["NOMBRE"].str.contains(DEPORTE, case=False, na=False)]

if match_deporte.empty:
    print(f"Error: No se encontro ningun deporte que coincida con '{DEPORTE}'.")
    exit(1)

deporte_ids = match_deporte["ID"].tolist()
nombres_encontrados = match_deporte["NOMBRE"].tolist()
print(f"Deporte(s) encontrado(s): {nombres_encontrados} (IDs: {deporte_ids})")

# 3. Encontrar disciplinas y eventos
disciplina_ids = df_disciplina[df_disciplina["ID_DEPORTE"].isin(deporte_ids)]["ID"].unique()
evento_ids = df_evento[df_evento["ID_DISCIPLINA"].isin(disciplina_ids)]["ID"].unique()

# 4. Encontrar IDs de resultado asociados
resultado_ids = df_resultado[df_resultado["ID_EVENTO"].isin(evento_ids)]["ID"].unique()
print(f"Total de resultados asociados al deporte: {len(resultado_ids)}")

# 5. Filtrar la tabla RESULTADO_ATLETA
df_res_atleta_filtrado = df_res_atleta[df_res_atleta["ID_RESULTADO"].isin(resultado_ids)].copy()

# 6. Guardar archivo resultante
os.makedirs("cargas", exist_ok=True)
nombre_archivo_limpio = DEPORTE.lower().replace(" ", "_").replace("(", "").replace(")", "")
output_path = f"cargas/13_RESULTADO_ATLETA_{nombre_archivo_limpio}.csv"

df_res_atleta_filtrado.to_csv(output_path, index=False)
print(f"Total de participaciones de atletas filtradas: {len(df_res_atleta_filtrado)}")
print(f"Archivo generado exitosamente en: {output_path}")
