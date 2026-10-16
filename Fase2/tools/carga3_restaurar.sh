
#!/usr/bin/env bash
set -euo pipefail

# CARGA 3 - Restauracion de Michael Phelps
# Uso: bash tools/carga3_restaurar.sh full|2008|2012|2016

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

ETAPA="${1:-}"

case "$ETAPA" in
    full)
        CARPETA="00_completo"
        ESPERADOS=9
        ;;
    2008)
        CARPETA="06_reconstruido_2008"
        ESPERADOS=17
        ;;
    2012)
        CARPETA="07_reconstruido_2012"
        ESPERADOS=24
        ;;
    2016)
        CARPETA="04_reconstruido"
        ESPERADOS=30
        ;;
    *)
        echo "Uso: bash tools/carga3_restaurar.sh full|2008|2012|2016"
        exit 1
        ;;
esac

BACKUP="$PROJECT_ROOT/backups/carga3_phelps/$CARPETA"
DESTINO="$PROJECT_ROOT/pgdata_demo_carga3_$ETAPA"
CONTENEDOR="postgres_demo_carga3_$ETAPA"
VOLUMEN="carga3_demo_$ETAPA"

echo "=== CARGA 3: Restauracion $ETAPA ==="

# Verificaciones de seguridad
# Verificar archivos del respaldo desde Docker
echo "Verificando archivos del respaldo..."

if ! docker run --rm \
    -v "$BACKUP:/backup_source:ro" \
    alpine sh -c \
    'test -f /backup_source/PG_VERSION && test -f /backup_source/backup_manifest'; then
    echo "ERROR: El respaldo no existe o esta incompleto."
    exit 1
fi

echo "Respaldo encontrado correctamente."

if docker volume inspect "$VOLUMEN" >/dev/null 2>&1; then
    echo "El volumen $VOLUMEN ya existe."
else
    echo "Creando volumen $VOLUMEN..."
    docker volume create "$VOLUMEN" >/dev/null
fi

echo "Verificando que el volumen este vacio..."

if ! docker run --rm \
    -v "$VOLUMEN:/datos" \
    alpine sh -c 'test -z "$(ls -A /datos)"'; then
    echo "ERROR: El volumen contiene archivos."
    echo "No se sobrescribiran datos existentes."
    exit 1
fi

echo "Volumen vacio. Podemos continuar."

if docker container inspect "$CONTENEDOR" >/dev/null 2>&1; then
    echo "ERROR: Ya existe el contenedor $CONTENEDOR"
    exit 1
fi

# Crear directorio exclusivo para la demostracion

echo "1. Copiando archivos fisicos al volumen Docker..."

docker run --rm \
    -v "$VOLUMEN:/var/lib/postgresql/data" \
    -v "$BACKUP:/backup_source:ro" \
    alpine sh -c \
    'cp -a /backup_source/. /var/lib/postgresql/data/ && chown -R 70:70 /var/lib/postgresql/data && chmod 700 /var/lib/postgresql/data'

echo "2. Iniciando PostgreSQL..."

docker run -d \
    --name "$CONTENEDOR" \
    --restart no \
    -v "$VOLUMEN:/var/lib/postgresql/data" \
    fase2-db:latest

echo "3. Esperando conexiones..."

LISTO=0

for ((i=0; i<120; i++)); do
    if docker exec "$CONTENEDOR" \
        pg_isready -U postgres -d olimpiadas_db -q \
        >/dev/null 2>&1; then
        LISTO=1
        break
    fi
    sleep 1
done

if [[ "$LISTO" -ne 1 ]]; then
    echo "ERROR: PostgreSQL no estuvo listo."
    docker logs --tail 30 "$CONTENEDOR"
    exit 1
fi

echo "4. Validando registros..."

RESULTADOS=$(docker exec "$CONTENEDOR" \
    psql -U postgres -d olimpiadas_db -t -A \
    -c 'SELECT COUNT(*) FROM "RESULTADO";')

PARTICIPACIONES=$(docker exec "$CONTENEDOR" \
    psql -U postgres -d olimpiadas_db -t -A \
    -c 'SELECT COUNT(*) FROM "RESULTADO_ATLETA";')

echo "Resultados: $RESULTADOS"
echo "Participaciones: $PARTICIPACIONES"
echo "Esperados: $ESPERADOS"

if [[ "$RESULTADOS" != "$ESPERADOS" ||
      "$PARTICIPACIONES" != "$ESPERADOS" ]]; then
    echo "ERROR: Los conteos no coinciden."
    exit 1
fi

echo "=== RESTAURACION Y VALIDACION EXITOSAS ==="
echo "Contenedor: $CONTENEDOR"
echo "Volumen Docker: $VOLUMEN"
echo "Para detenerlo:"
echo "docker stop $CONTENEDOR"
