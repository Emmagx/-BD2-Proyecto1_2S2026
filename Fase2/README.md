# Fase 2 - Respaldos y Restauracion de Bases de Datos

Buenas, aqui les dejo la guia y el resumen de que onda con esta fase 2 del proyecto para que todos estemos en la misma sintonia y sepamos que hay que hacer.

En esta fase ya no vamos a usar neon.tech porque el enunciado pide backups fisicos directos por consola y en neon no tenemos acceso al servidor ni a los archivos del motor. Por eso montamos postgres en docker para trabajarlo localmente.

---

## De que se trata la fase

El objetivo es probar, comparar y medir tiempos de respaldos fisicos (Full e Incrementales) haciendo 3 rondas de cargas de datos. 
La idea es meter un bloque de datos, sacar backup, meter mas datos, sacar backup incremental, y luego simular que se cayo el sistema borrando la base de datos completa para restaurarla y medir con reloj en mano cuanto tiempo tarda en recuperar todo.

OJO con esto que es super importante:
El enunciado prohibe totalmente usar dumps (`pg_dump` o exportar sql desde dbeaver). Los respaldos tienen que ser fisicos desde la terminal.

---

## Como nos vamos a dividir el trabajo

El enunciado pide 3 tipos de cargas de datos diferentes, asi que nos queda perfecto para hacer uno cada uno:

- Carga 1 (por Anio):
  La idea es hacer una carga inicial (por ejemplo juegos olimpicos hasta 2012), sacar el full backup, luego meter los siguientes anios (ejemplo 2016 y 2020) sacando backups incrementales en cada carga.
- Carga 2 (por Deporte / Evento):
  Carga inicial, full backup, y luego ir agregando deportes o eventos especificos con sus respectivos incrementales.
- Carga 3 (por Deportista):
  Carga inicial, full backup, y luego ir agregando bloques de atletas destacados con sus incrementales.

Cada uno de nosotros tiene que investigar por su cuenta como se sacan los backups fisicos (full e incrementales) y como restaurarlos por consola, ya que parte de la calificacion es saber como ejecutar los comandos de DBA.

---

## Donde se guardan los backups?

Se guardan en nuestra maquina fisica, en la carpeta `Fase2/backups`.

Aunque los comandos se corran dentro del contenedor, configure el docker-compose para que la carpeta `/backups` del contenedor este mapeada directamente a nuestra carpeta local `backups`.
Esto es clave porque en las pruebas nos toca eliminar la base de datos completa. Si los respaldos estuvieran guardados adentro del contenedor y se borra o se cae, perderiamos los archivos. Al guardarse en nuestra propia computadora, los backups sobreviven y podemos usarlos para restaurar.

---

## Como levantar la base de datos en su compu

Para que cada quien trabaje en su maquina sin complicarse:

1. Levantar el contenedor:
   ```bash
   docker compose up -d
   ```
2. Datos para conectarse (pueden usar DBeaver si quieren ver las tablas):
   - Host: localhost
   - Puerto: 5432
   - Base de datos: olimpiadas_db
   - Usuario: postgres
   - Password: password123

3. Cargar los datos completos limpios (por si necesitan verlos de referencia):
   ```bash
   ./load_all_data.sh
   ```

4. Apagar el contenedor cuando terminen:
   ```bash
   docker compose stop
   ```

---

## Cosas importantes a tomar en cuenta para las capturas (Rubrica)

- Fecha y hora obligatoria: El enunciado pide que TODAS las capturas de pantalla muestren la fecha y hora del sistema operativo visible. No recorten solo la terminal o la ventana de sql, dejen que se vea la barra de tareas con el reloj.
- Validaciones con SELECT: Despues de cada carga y despues de cada restauracion hay que tomar capturas haciendo `SELECT *` y `SELECT COUNT(*)` de las tablas para evidenciar que los datos si estan ahi y no se perdio nada.
- Cronometrar tiempos: Hay que anotar exactamente cuantos segundos o minutos tarda en restaurar con el Full vs el Full + Incrementales. Esos tiempos los vamos a meter en las tablas comparativas y graficas del reporte final.
- Fragmentacion: Hay que investigar la consulta para revisar el nivel de fragmentacion de las tablas antes y despues.

---

## Que tenemos que entregar al final

Cuando terminemos las 3 pruebas juntamos todo para armar:
1. Documento tecnico (PDF): Explicacion del plan de respaldos, datos de la maquina, tablas de tiempos, graficas comparativas y conclusiones.
2. Manual de usuario (PDF): El paso a paso de los comandos para que cualquiera pueda replicar los backups y restauraciones.
3. Scripts: Los scripts sql de carga y los `.sh` de backup y restore comentados.
