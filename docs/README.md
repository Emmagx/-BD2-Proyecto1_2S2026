# DOCUMENTACION PROYECTO 1

## Participantes 

| NOMBRE | CARNET |
| ------------- |:-------------:|
| BRAYAN EMANUEL GARCIA | 202300848 |
| NORMA ELIZABETH CANU | 202300768  |
| VALERY NICOLLE GALVEZ GARCIA      | 202200141     |

## 1. DECISIONES SOBRE DATASETS Y ANOTACIONES
1. COLUMNA NONAME=7 DEL RESULTS.CSV (RAW FILE) IGNORADA PORQUE NO CONTIENE DATOS.

2. Que pasa con los atletas que no representan un pais en concreto? 
SE COLOCAN COMO INDEPENDIENTES.

3. NOC SE REFIERE A LAS NATIONAL ORGANIZACION COUNTRY, ESTO YA ENGLOBARIA PAISES MUY POBRES QUE LLEVAN A SUS ATLETAS COMBINADOS. YA QUE EN ESTE CASO: PAIS = FEDERACION. 

4. SEASON Y TYPE HACIAN REFERENCIA A LO MISMO Y SE UNIFICARON.

5. EN RESULTS(1).CSV SE ENCONTRO QUE AL FINAL HABIA UNA ATLETA CON INFORMACION INCOMPLETA, PARA NO PERDER ESA DATA SE OPTO POR LLENARLA MANUALMENTE.

## 2. DISENO Y VERSIONES DEL DIAGRAMA DE BASE DE DATOS
1. Empezamos con una normalizacion de Datos a partir de los encabezados de los csv y unas lecturas rapidas de los archivos.
![Encabezados](images/img1.png)

2. Poco a poco fuimos descartando todos los campos que tenian la misma informacion. 
![Encabezados](images/img2.png)

3. Se sacaron tablas iniciales para seguir analizando, se usaron 12 tablas, una con teammate por eventos donde haya mas de una persona, pero no es una solucion bien definida.
![Tablas](images/img3.png)

4. Para quitar teammate se uso una tabla intermedia entre ATLETA Y RESULTADO, asi logramos dos cosas: solucionar una relacion M:M y Solucionar el problema de teammate ahora, varios atletas pueden apuntar al mismo resultado, dando como resultado un equipo. Tambien se elimino la tabla place porque no era necesaria y solo consumiria espacio.
![Tablas](images/img4.png)

5. Se intento colocar en un atleta la informacion de su ciudad natal, y tambien del pais que representa. Pero eso genera problemas ya que no los atletas a veces representan a varios paises en su carrera (esto lo cambiamos hasta mas adelante).
![Tablas](images/img6.png)

6. Se empezaron a buscar los tipos de datos acordes a las columnas de cada tabla, definiendo tamanos que creiamos convenientes(en el futuro cambiaron)
![Tablas](images/img10.png)

7. Se agrego el atributo edad a la tabla ATLETA_EVENTO(ver seccion 3.2)
![Tablas](images/img12.png)

8. Usando la herramienta dbdiagrams.io se empezo a hacer un diagrama visual sobre el diagrama inicial que teniamos, el lenguaje es pseudo sql en el cual es mas facil definir relaciones, verlo visualmente y analizar mejor la base de datos.
![diagrama1](images/img13.png)
![diagrama2](images/img14.png)

9. Se renombro la tabla de EVENTO_ATLETA A RESULTADO_ATLETA, porque es mas acorde a la relacion.
 ![diagrama2](images/img16.png)

10. Exportamos los dataset a Hojas de Calculo de google para poder visualizar mejor los datos y hacer inspecciones mas fondo.
 ![diagrama2](images/img18.png)

11. Se agregaron las tablas DEPORTE y CIUDAD_OLIMPIADA. DEPORTE se agrego para respetar la jerarquia: Evento->Disciplina->Deporte, donde un evento es 100 m planos masculinos, una disciplina es 100 metros planos y Deporte Atletismo. Luego para soportar Olimpiadas con varias ciudades se agrego la tabla intermedia CIUDAD_OLIMPIADA, para poder tener olimpiadas en varias ciudades.
![tablas](images/img19.png)
![diagrama2](images/img20.png)

12. SE AGREGO ATRIBUTO ESTADO A RESULTADO: 
RAZON: COLOCAR ESTADO TERMINADO(SUCCESS) DESCALIFICACION (DSQ) Y ESO.
ATRIBUTOS LAT Y LONG AGREGADOS A CIUDAD, YA QUE REVISANDO LAS LAT Y LONG DEL ARCHIVO BIOS_LOCS.CSV TIENE LAS LAT Y LONG DE LA CIUDAD DE NACIEMIENTO.
Se agrego tabla Poblacion para almacenar la poblacion por anio en cada pais. 

### VERSION FINAL DE LA BASE DE DATOS (DIAGRAMA)

![diagrama2](ModeloFinal.png)

## 3. CHARLAS CON IA (GEMINI)
1. Se hizo una consulta sobre la normalizacion y los datos que se estaban sacando pidiendo feedback y analizando, sin que de la respuesta sino como un guia/mentor.
![ia1](images/img8.png)

2. Segun indicaciones del ingeniero en clase, teniamos que tomar decisiones sobre algunos tipos de datos, para saber mas consultamos con la IA sobre estos datos, nos brindo informacion importante como que la edad que solia venir en los datasets pertenecen a la edad en la que los atletas compitieron. 
![ia2](images/img11.png)

3. Consulta sobre los servicios que podiamos utilizar para manejar la base de datos.
![ia3](images/img25.png)

4. Review sobre el script brindado por dbdiagrams.io para evitar redunciancia o problemas en las tablas.
![ia4](images/img26.png)

5. Consultas sobre como limpiar los datos:
![ia5](images/img40.png)

6. Co5nsulta sobre el optimizacion del script 13, ya que su analisis hacia que la computadora sufriera mucho estres.
![ia6](images/img46.png)

7. Se consulto como manejar errores sobre la extraccion de datos de regiones.
![ia7](images/img59.png)

8. Consultas sobre la consistencia de datos en los csv "limpios"
![ia7](images/img60.png)
![ia7](images/img66.png)
## DECISIONES SOBRE BASE DE DATOS
### MOTOR

Se selecciono postgresql por su versatilidad para futuras fases, tambien actualmente cuanta con soporte constante, documentacion completa y versatilidad.

### PLATAFORMA

Usaremos neon.tech para alojar la base de datos, porque ademas de ser una plataforma en la nube, ofrece una capa gratuita muy buena y cuenta con herramientas utiles, entre esas:
- Poder dar ramas a companeros y asi trabajar ambos sobre el mismo modelo sin interrumpirnos
- Tener un respaldo por si alguna computadora llega a fallar
- Conexion rapida con Plataformas de Gestion de Bases de Datos.

No se opto por un contenedor local o un contenedor en la nube para almacenar mejor la informacion, no depender de un integrante del grupo y su equipo, sino tener un respaldo en la nube, y no se uso un contenedor en una vm por costos operativos.


### VISUALIZADOR DE BASE DE DATOS

DBEAVER porque integra muy facilmente las bases de datos remotas, tambien cuenta con herramientas para subir csv de manera mas sencilla, rapida y consistente.

1. Primero abrir DBAaever y seleccionar nueva base de datos:
![dba](images/img36.png)

2. Llenar campos con el link dado por neon.tech
![dba](images/img37.png)
![dba](images/img39.png)

### ANOTACIONES:
COMO SE DIFERENCIA EL ORIGEN DEL ATLETA VS EL PAIS POR EL QUE JUEGA?
RAZON: SE DEBE A LA 3NF. EL PAIS DE NACIMIENTO SE CONSULTA UNIENDO ATLETA -> CIUDAD -> REGION -> PAIS. EL PAIS POR EL QUE COMPITIO SE CONSULTA MEDIANTE LA LLAVE FORANEA ID_PAIS_REPRESENTA EN LA TABLA RESULTADO_ATLETA (EJEMPLO: ATLETAS NACIDOS EN USA QUE REPRESENTAN A SUECIA)

```SQL
-- 1. Un atleta puede no tener registrada su ciudad de nacimiento (Ej: Michael Jordan)
ALTER TABLE "ATLETA" ALTER COLUMN "ID_CITY_NACIMIENTO" DROP NOT NULL;

-- 2. Una ciudad anfitriona (ej. St. Moritz) no tiene región en nuestro dataset de origen
ALTER TABLE "CIUDAD" ALTER COLUMN "ID_REGION" DROP NOT NULL;

-- 3. Algunas regiones históricas no tienen un cruce exacto con un País (NOC) actual
ALTER TABLE "REGION" ALTER COLUMN "ID_PAIS" DROP NOT NULL;

-- 4. Un atleta puede no tener su edad registrada en un evento específico
ALTER TABLE "RESULTADO_ATLETA" ALTER COLUMN "EDAD" DROP NOT NULL;

-- 5. Atletas independientes o de países disueltos pueden no tener un país representativo claro
ALTER TABLE "RESULTADO_ATLETA" ALTER COLUMN "ID_PAIS_REPRESENTA" DROP NOT NULL;
```

**PARA OPTIMIZAR LAS BUSQUEDAS INDEXE LAS SIGUEINTES LLAVES FORANEAS** 

EN LA TABLA RESULTADO_ATLETA:`ID_ATLETA, ID_RESULTADO, ID_PAIS_REPRESENTA`

EN LA TABLA RESULTADO:`ID_EVENTO, ID_MEDALLA, ID_OLIMPIADA`

EN LA TABLA ATLETA: `NOMBRE`

EN LA TABLA PAIS: `NOC`


CON: 
```sql
-- Índices para la tabla más gigante (RESULTADO_ATLETA - 308k filas)
CREATE INDEX idx_res_atl_atleta ON "RESULTADO_ATLETA"("ID_ATLETA");
CREATE INDEX idx_res_atl_resultado ON "RESULTADO_ATLETA"("ID_RESULTADO");
CREATE INDEX idx_res_atl_pais ON "RESULTADO_ATLETA"("ID_PAIS_REPRESENTA");

-- Índices para la segunda tabla más grande (RESULTADO - 156k filas)
CREATE INDEX idx_res_evento ON "RESULTADO"("ID_EVENTO");
CREATE INDEX idx_res_medalla ON "RESULTADO"("ID_MEDALLA");
CREATE INDEX idx_res_olimpiada ON "RESULTADO"("ID_OLIMPIADA");

-- Índices para acelerar búsquedas de texto comunes (como WHERE A."NOMBRE" = 'Usain Bolt')
CREATE INDEX idx_atleta_nombre ON "ATLETA"("NOMBRE");
CREATE INDEX idx_pais_noc ON "PAIS"("NOC");
```
#### COMPARACION DE VELOCIDAD CON INDEX Y SIN INDEX:
Mediciones hechas en la consola de neontech para ver la diferencia mas cercana a la real.

**SIN INDEX** 
![alt text](image.png)
**CON INDEX**
![alt text](image-1.png)
## SCRIPTS ETL CON PYTHON Y SUBIDA DE DATOS:
1. sacar el pais o los datos primarios de los csv(medalla, pais, deporte, olimpiada).
![sc1](images/img41.png)

2. Scripts secundarios o segundo nivel:
![sc2](images/img42.png)

3. fallo en script en nivel 3, se para, como en el apartado 3.6 generamos un nuevo script con python:
![sc2](images/img44.png)

**Todas las versiones funcionales y actuales de los scripts se encuentran en /scripts/**


### DATA UPLOAD:
1. Seleccionar la tabla en el modelo
![up1](images/img48.png)
2. Dar click en la opcion de `import data`

3. Seleccionar archivo con la informacion, luego next. 
![up2](images/img49.png)
4. Cambiar opciones de subida: cuantos simultaneos, a los cuantos hacer commit.
5. Presionar Proceed y empezara la subida de datos. Al estar subiendo los datos dbaever mostrara errores si lo hay (por tipo de datos, tipos erroneos, nulos no soportados...)
![up3](images/img52.png)
![up4](images/img53.png)


