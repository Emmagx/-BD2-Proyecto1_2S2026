FROM postgres:16-alpine

# Crear directorio de respaldos con permisos para el usuario postgres
RUN mkdir -p /backups && chown -R postgres:postgres /backups

# Exponer el puerto estándar
EXPOSE 5432
