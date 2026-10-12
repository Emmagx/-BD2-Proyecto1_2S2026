#!/bin/bash
set -e

echo "=== Destruyendo entorno completo ==="

echo "Deteniendo contenedor..."
docker compose down

echo "Eliminando datos de PostgreSQL (pgdata) via Docker..."
# Los archivos dentro de pgdata pertenecen al usuario 'postgres' del contenedor (uid 999).
# Usamos un contenedor efimero con privilegios para borrarlos sin necesitar sudo en el host.
docker run --rm -v "$(pwd)/pgdata:/target" alpine sh -c "rm -rf /target/* /target/.[!.]* 2>/dev/null || true"

echo "Eliminando backups del host..."
rm -rf ./backups/00_completo ./backups/01_incremental ./backups/02_incremental

echo "Verificando limpieza..."

if docker ps -a --format '{{.Names}}' | grep -q "^postgres_fase2$"; then
    echo "ERROR: el contenedor postgres_fase2 aun existe"
    exit 1
fi

if [ -n "$(ls -A ./pgdata 2>/dev/null)" ]; then
    echo "ERROR: el directorio pgdata no esta vacio"
    exit 1
fi

echo "=== Entorno limpio. Listo para nueva prueba. ==="