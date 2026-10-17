#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

if [ -z "$1" ]; then
    echo "Uso: $0 {1|2|3}"
    exit 1
fi

start=$(date +%s.%N)

if [ "$1" = 1 ]; then
    docker exec postgres_fase2 pg_basebackup -U postgres -D /backups/00_completo -Fp -Xs -v -P
elif [ "$1" = 2 ]; then
    docker exec postgres_fase2 pg_basebackup -U postgres -D /backups/01_incremental --incremental=/backups/00_completo/backup_manifest -Fp -Xs -v -P
elif [ "$1" = 3 ]; then
    docker exec postgres_fase2 pg_basebackup -U postgres -D /backups/02_incremental --incremental=/backups/01_incremental/backup_manifest -Fp -Xs -v -P
else
    echo "Uso: $0 {1|2|3}"docker volume create carga3_simulacro_2012
    exit 1
fi

end=$(date +%s.%N)
echo "Duración: $(echo "$end - $start" | bc) segundos"