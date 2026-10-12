import pandas as pd

print("Buscando discrepancias en los nombres de ciudades...\n")

# 1. Leer los archivos crudos
df_events = pd.read_csv('athlete_events.csv', low_memory=False)
df_bios = pd.read_csv('bios_locs.csv', low_memory=False)

# 2. Extraer listas de valores únicos (usando Sets para mayor velocidad)
sedes_olimpicas = set(df_events['City'].dropna().unique())
ciudades_nacimiento = set(df_bios['born_city'].dropna().unique())

# 3. Encontrar la diferencia: Sedes que NO están en las ciudades de nacimiento
sedes_huerfanas = sedes_olimpicas - ciudades_nacimiento

print(f"Se encontraron {len(sedes_huerfanas)} sedes olímpicas que no cruzan con el catálogo principal:")
for sede in sorted(sedes_huerfanas):
    print(f"- {sede}")