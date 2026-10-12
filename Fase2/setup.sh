#!/bin/bash
# setup.sh — Primer arranque del entorno (ejecutar una sola vez al clonar)
set -e

echo "=== Setup inicial Fase 2 ==="

# Crear carpeta pgdata si no existe (bind mount necesita que exista en el host)
if [ ! -d "./pgdata" ]; then
    echo "Creando directorio pgdata..."
    mkdir -p ./pgdata
fi

# Copiar .env si no existe
if [ ! -f ".env" ]; then
    echo "Creando .env desde .env.example..."
    cp .env.example .env
fi

echo "Levantando contenedor..."
docker compose up -d

echo "Esperando que PostgreSQL inicialice (15 segundos)..."
sleep 15

echo "Verificando base de datos..."
docker exec postgres_fase2 psql -U postgres -d olimpiadas_db -c "\dt" 2>/dev/null \
    && echo "=== Setup completado. Base de datos lista. ===" \
    || echo "ERROR: el contenedor no responde, revisa: docker logs postgres_fase2"
