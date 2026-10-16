
from pathlib import Path
import pandas as pd

# Atleta seleccionado: Michael Phelps (ID 93860)

BASE = Path(__file__).resolve().parent.parent
ORIGEN = BASE / "csv-limpios"
DESTINO = BASE / "cargas"

DESTINO.mkdir(exist_ok=True)

ID_ATLETA = 93860

OLIMPIADAS = {
    2000: 6,
    2004: 7,
    2008: 8,
    2012: 16,
    2016: 17
}

print("=== PREPARANDO CARGA 3: MICHAEL PHELPS ===")

# Leer las relaciones entre atletas y resultados
df_relaciones = pd.read_csv(
    ORIGEN / "13_RESULTADO_ATLETA.csv"
)

# Conservar únicamente las participaciones de phelps
df_phelps = df_relaciones[
    df_relaciones["ID_ATLETA"] == ID_ATLETA
].copy()

# Leer resultados olímpicos
df_resultados = pd.read_csv(
    ORIGEN / "12_RESULTADO.csv"
)

# Conservar resultados correspondientes a Phelps
df_resultados_phelps = df_resultados[
    df_resultados["ID"].isin(df_phelps["ID_RESULTADO"])
].copy()

# Separar los resultados por edición olímpica
for anio, id_olimpiada in OLIMPIADAS.items():

    resultados = df_resultados_phelps[
        df_resultados_phelps["ID_OLIMPIADA"] == id_olimpiada
    ].copy()

    relaciones = df_phelps[
        df_phelps["ID_RESULTADO"].isin(resultados["ID"])
    ].copy()

    # Validar cantidad de registros
    if resultados.empty or relaciones.empty:
        raise ValueError(
            f"No se encontraron participaciones para {anio}"
        )

    # Normalizar posiciones para la columna integer
    resultados["PLACE"] = pd.to_numeric(
        resultados["PLACE"], errors="coerce"
    )

    posiciones = resultados["PLACE"].dropna()
    if not (posiciones % 1 == 0).all():
        raise ValueError(
            f"Hay posiciones decimales no enteras en {anio}"
        )

    resultados["PLACE"] = resultados["PLACE"].astype("Int64")

    # Normalizar EDAD para PostgreSQL (integer)
    relaciones["EDAD"] = pd.to_numeric(
        relaciones["EDAD"], errors="coerce"
    )

    edades = relaciones["EDAD"].dropna()

    if not (edades % 1 == 0).all():
        raise ValueError(
            f"Hay edades decimales no enteras en {anio}"
        )

    relaciones["EDAD"] = relaciones["EDAD"].astype("Int64")

    # Generar archivos CSV
    archivo_resultados = (
        DESTINO / f"12_RESULTADO_phelps_{anio}.csv"
    )

    archivo_relaciones = (
        DESTINO / f"13_RESULTADO_ATLETA_phelps_{anio}.csv"
    )

    resultados.to_csv(archivo_resultados, index=False)
    relaciones.to_csv(archivo_relaciones, index=False)

    print(f"\nOlimpiada: {anio}")
    print(f"Resultados: {len(resultados)}")
    print(f"Participaciones: {len(relaciones)}")
    print(f"Archivos generados correctamente.")

print("\n=== CARGA 3 PREPARADA ===")
