#!/bin/bash
set -e

start=$(date +%s.%N)
echo "=== RESTAURANDO: Backup Completo (00_completo) ==="
echo

echo "1. Preparando directorio ./pgdata..."
mkdir -p ./pgdata

echo "2. Copiando el backup a ./pgdata..."
docker run --rm \
  -v "$(pwd)/pgdata:/var/lib/postgresql/data" \
  -v "$(pwd)/backups/00_completo:/backup_source:ro" \
  alpine sh -c "cp -a /backup_source/. /var/lib/postgresql/data/ && chown -R 70:70 /var/lib/postgresql/data && chmod 700 /var/lib/postgresql/data"

echo "3. Levantando el contenedor..."
docker compose up -d

echo "4. Esperando a que PostgreSQL acepte conexiones..."
until docker exec postgres_fase2 pg_isready -U postgres -q; do
    sleep 0.1
done

end=$(date +%s.%N)
echo
echo "Restauración FULL completada"
echo "Duración: $(echo "$end - $start" | bc) segundos"