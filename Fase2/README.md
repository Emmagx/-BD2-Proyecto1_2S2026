## Como levantar la base de datos en su compu

Para que cada quien trabaje en su maquina sin complicarse:
1. en linux ejecutar setup.sh (./setup.sh)

2. Levantar el contenedor:
   ```bash
   docker compose up -d
   ```
3. Datos para conectarse (pueden usar DBeaver si quieren ver las tablas):
   - Host: localhost
   - Puerto: 5432
   - Base de datos: olimpiadas_db
   - Usuario: postgres
   - Password: password123

4. Cargar los datos completos limpios (por si necesitan verlos de referencia):
   ```bash
   ./load_all_data.sh
   ```

5. Apagar el contenedor cuando terminen:
   ```bash
   docker compose stop
   ```