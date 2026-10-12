#!/bin/bash
set -e

start=$(date +%s.%N)
echo "=== RESTAURANDO: Full + Incrementales (00 + 01 + 02) ==="
echo

echo "1. Creando volumen pgdata vacío..."
docker volume create fase2_pgdata

echo "2. Combinando full + incrementales con pg_combinebackup..."
rm -rf ./restore_combined
docker run --rm \
  -v $(pwd)/backups:/backups \
  -v $(pwd)/restore_combined:/restore_combined \
  postgres:17-alpine \
  pg_combinebackup -o /restore_combined \
    /backups/00_completo \
    /backups/01_incremental \
    /backups/02_incremental

echo "3. Copiando los datos combinados al volumen..."
docker run --rm \
  -v fase2_pgdata:/var/lib/postgresql/data \
  -v $(pwd)/restore_combined:/source:ro \
  alpine sh -c "cp -a /source/. /var/lib/postgresql/data/ && chown -R 999:999 /var/lib/postgresql/data"

echo "4. Levantando el contenedor..."
docker compose up -d

echo "5. Esperando a que PostgreSQL acepte conexiones..."
until docker exec postgres_fase2 pg_isready -U postgres -q; do
    sleep 0.1
done

end=$(date +%s.%N)
echo
echo "===Restauración FULL + INCREMENTALES completada ==="
echo "Duración: $(echo "$end - $start" | bc) segundos"
