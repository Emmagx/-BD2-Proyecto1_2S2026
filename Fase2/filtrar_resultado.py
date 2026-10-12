import os
import pandas as pd

DEPORTE = "Athletics"  # Ejemplos: "Athletics", "Basketball", "Archery"

print(f"=== Filtrando 12_RESULTADO para el deporte: '{DEPORTE}' ===")

# 1. Cargar catalogos necesarios
df_deporte = pd.read_csv("csv-limpios/2_DEPORTE.csv")
df_disciplina = pd.read_csv("csv-limpios/6_DISCIPLINA.csv")
df_evento = pd.read_csv("csv-limpios/9_EVENTO.csv")
df_resultado = pd.read_csv("csv-limpios/12_RESULTADO.csv")

# 2. Buscar el deporte (coincidencia flexible insensible a mayusculas/minusculas)
match_deporte = df_deporte[df_deporte["NOMBRE"].str.contains(DEPORTE, case=False, na=False)]

if match_deporte.empty:
    print(f"Error: No se encontro ningun deporte que coincida con '{DEPORTE}'.")
    print("Deportes disponibles en 2_DEPORTE.csv:")
    print(df_deporte["NOMBRE"].tolist())
    exit(1)

deporte_ids = match_deporte["ID"].tolist()
nombres_encontrados = match_deporte["NOMBRE"].tolist()
print(f"Deporte(s) encontrado(s): {nombres_encontrados} (IDs: {deporte_ids})")

# 3. Encontrar disciplinas asociadas
disciplina_ids = df_disciplina[df_disciplina["ID_DEPORTE"].isin(deporte_ids)]["ID"].unique()

# 4. Encontrar eventos asociados
evento_ids = df_evento[df_evento["ID_DISCIPLINA"].isin(disciplina_ids)]["ID"].unique()
print(f"Total de eventos encontrados: {len(evento_ids)}")

# 5. Filtrar la tabla RESULTADO
df_resultado_filtrado = df_resultado[df_resultado["ID_EVENTO"].isin(evento_ids)].copy()

# 6. Guardar archivo resultante
os.makedirs("cargas", exist_ok=True)
nombre_archivo_limpio = DEPORTE.lower().replace(" ", "_").replace("(", "").replace(")", "")
output_path = f"cargas/12_RESULTADO_{nombre_archivo_limpio}.csv"

df_resultado_filtrado.to_csv(output_path, index=False)
print(f"Total de filas filtradas: {len(df_resultado_filtrado)}")
print(f"Archivo generado exitosamente en: {output_path}")
