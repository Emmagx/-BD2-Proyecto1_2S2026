#!/bin/bash
set -e

DB="olimpiadas_db"
USER="postgres"
CONTENEDOR="postgres_fase2"
TABLA="atletas"
COLUMNA_DEPORTE="deporte"
ESPERADO_FULL=100
ESPERADO_TOTAL=300

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTENEDOR}$"; then
    echo "ERROR: contenedor ${CONTENEDOR} no esta corriendo"
    exit 1
fi

if ! docker exec "$CONTENEDOR" psql -U "$USER" -lqt | cut -d '|' -f1 | grep -qw "$DB"; then
    echo "ERROR: base de datos '$DB' no existe"
    exit 1
fi

TOTAL=$(docker exec "$CONTENEDOR" psql -U "$USER" -d "$DB" -tAc "SELECT COUNT(*) FROM ${TABLA};")
echo "Total de filas en ${TABLA}: ${TOTAL}"

docker exec "$CONTENEDOR" psql -U "$USER" -d "$DB" -c \
  "SELECT ${COLUMNA_DEPORTE}, COUNT(*) AS total FROM ${TABLA} GROUP BY ${COLUMNA_DEPORTE} ORDER BY ${COLUMNA_DEPORTE};"

if [ "$TOTAL" -eq "$ESPERADO_FULL" ]; then
    echo "Resultado: EXPERIMENTO A (solo Full)"
elif [ "$TOTAL" -eq "$ESPERADO_TOTAL" ]; then
    echo "Resultado: EXPERIMENTO B (Full + Incrementales)"
else
    echo "ERROR: total ${TOTAL} no coincide con ningun escenario"
    echo "  Experimento A esperado: ${ESPERADO_FULL}"
    echo "  Experimento B esperado: ${ESPERADO_TOTAL}"
    exit 2
fi
