select * from "PAIS";
select * from "DEPORTE";
select * from "OLIMPIADA";
select * from "MEDALLA";
select * from "REGION";
alter table "DISCIPLINA" alter column "NOMBRE" type varchar(150);
select * from "DISCIPLINA";
select * from  "CIUDAD";
select * from "EVENTO";
select * frOM "RESULTADO_ATLETA";

SELECT A."NOMBRE" as ATLETA, C."NOMBRE" as CIUDAD , M."NOMBRE" as MEDAL, P."NOMBRE" as PAIS, O."YEAR" as OLYM
FROM "ATLETA" AS A
left JOIN "CIUDAD" AS C ON A."ID_CITY_NACIMIENTO" = C."ID"
join "RESULTADO_ATLETA" as RA ON RA."ID_ATLETA" = A."ID"
join "RESULTADO" as R on R."ID" = RA."ID_RESULTADO"
join "MEDALLA" as M on M."ID" = R."ID_MEDALLA"
join "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA" 
join "OLIMPIADA" as O on O."ID"  = R."ID_OLIMPIADA" 
where A."NOMBRE" like 'Michael Jordan';



truncate table "ATLETA";


SELECT 
    a."NOMBRE" AS "Atleta", 
    ra."EDAD" AS "Edad_Competicion",
    c."NOMBRE" AS "Ciudad_Nacimiento", 
    pr."NOMBRE" AS "Pais_Represento",
    o."YEAR" AS "Anio_Olimpiada",
    e."NOMBRE" AS "Evento"
FROM "RESULTADO_ATLETA" ra
JOIN "ATLETA" a ON ra."ID_ATLETA" = a."ID"
LEFT JOIN "CIUDAD" c ON a."ID_CITY_NACIMIENTO" = c."ID"
JOIN "PAIS" pr ON ra."ID_PAIS_REPRESENTA" = pr."ID"
JOIN "RESULTADO" r ON ra."ID_RESULTADO" = r."ID"
JOIN "EVENTO" e ON r."ID_EVENTO" = e."ID"
JOIN "MEDALLA" m ON r."ID_MEDALLA" = m."ID"
JOIN "OLIMPIADA" o ON r."ID_OLIMPIADA" = o."ID" -- ¡Esta era la línea que faltaba!
WHERE m."NOMBRE" = 'Gold' 
  AND e."NOMBRE" LIKE '%Basketball%' and a."SEXO" = 'M' and O."YEAR" = 1992
ORDER BY o."YEAR" asc ;


SELECT 
    o."YEAR" AS "Anio", 
    o."SEASON" AS "Temporada", 
    c."NOMBRE" AS "Sede_Oficial", 
    c."LAT" AS "Latitud",
    c."LONG" AS "Longitud"
FROM "OLIMPIADA" o
JOIN "CIUDAD_OLIMPIADA" co ON o."ID" = co."ID_OLIMPIADA"
JOIN "CIUDAD" c ON co."ID_CIUDAD" = c."ID"
WHERE o."YEAR" IN (1968, 1972, 1976, 2012)
ORDER BY o."YEAR";

SELECT 
    a."NOMBRE" AS "Atleta",
    r."STATE" AS "Estado_Final",
    r."PLACE" AS "Posicion",
    m."NOMBRE" AS "Medalla",
    o."YEAR" AS "Anio",
    e."NOMBRE" AS "Evento"
FROM "RESULTADO_ATLETA" ra
JOIN "ATLETA" a ON ra."ID_ATLETA" = a."ID"
JOIN "RESULTADO" r ON ra."ID_RESULTADO" = r."ID"
JOIN "EVENTO" e ON r."ID_EVENTO" = e."ID"
JOIN "OLIMPIADA" o ON r."ID_OLIMPIADA" = o."ID"
JOIN "MEDALLA" m ON r."ID_MEDALLA" = m."ID"
WHERE r."STATE" IN ('DQ', 'DNS', 'DNF')
LIMIT 15;


SELECT 
    pr."NOMBRE" AS "Pais",
    COUNT(r."ID") AS "Total_Medallas_Oro"
FROM "RESULTADO_ATLETA" ra
JOIN "RESULTADO" r ON ra."ID_RESULTADO" = r."ID"
JOIN "PAIS" pr ON ra."ID_PAIS_REPRESENTA" = pr."ID"
JOIN "MEDALLA" m ON r."ID_MEDALLA" = m."ID"
WHERE m."NOMBRE" = 'Gold'
GROUP BY pr."NOMBRE"
ORDER BY "Total_Medallas_Oro" DESC
LIMIT 10;


SELECT A."NOMBRE" AS ATLETA_NOMBRE,
       M."NOMBRE" as MEDALLA,
       E."NOMBRE" as EVENTO,
       O."YEAR" as ANIOO
from "ATLETA" A
LEFT join "RESULTADO_ATLETA" RA on RA."ID_ATLETA" = A."ID"
LEFT join "RESULTADO" R on R."ID" = RA."ID_RESULTADO"
LEFT join "MEDALLA" M on M."ID" = R."ID_MEDALLA"
LEFT join "EVENTO" E on E."ID" = R."ID_EVENTO"
left join "OLIMPIADA" O on O."ID" = R."ID_OLIMPIADA"
where M."NOMBRE" = 'Gold';

select * from "EVENTO";

select * from "EVENTO";
select E."NOMBRE" as EVENTO, D."NOMBRE" as DISCIPLINA 
from "EVENTO" as E
join "DISCIPLINA" D on D."ID" = E."ID_DISCIPLINA";

select * from "RESULTADO" 
order by "ID_EVENTO" asc;

select * from "EVENTO"
order by "ID" ASC;

select R."ID", R."TIED",R."PLACE", M."NOMBRE" as MEDAL, O."YEAR" as ANIO, O."SEASON" as SEASON, E."NOMBRE" as EVENT
from "RESULTADO" R
left  join "MEDALLA" M on M."ID" = R."ID_MEDALLA" 
left  join "OLIMPIADA" O on O."ID" = R."ID_OLIMPIADA"
left JOIN "EVENTO" E on E."ID" = R."ID_EVENTO";

truncate table "PAIS", "RESULTADO_ATLETA", "ATLETA", "EVENTO", "RESULTADO", "MEDALLA", "OLIMPIADA", "CIUDAD_OLIMPIADA", "REGION", "POBLACION",
"DEPORTE", "DISCIPLINA", "CIUDAD", "REGION" cascade;


truncate table "PAIS" CASCADE;
alter Table "ATLETA" drop column "nombre_1";
truncate table "RESULTADO" CASCADE;
commit;

select * from "ATLETA";


select * from "OLIMPIADA"
order by "YEAR" asc;

select * from "RESULTADO";

select * from "EVENTO";
alter table "EVENTO" alter column "NOMBRE" type varchar(250);
alter table "EVENTO" alter column "ID" type int8;


select "NOMBRE" from "ATLETA" 
where "NOMBRE" like '%Phelps';

-- ATLETAS CON MEDALLA Y EN QUE ANIO LO GANARON
SELECT A."NOMBRE" as ATLETA, C."NOMBRE" as CIUDAD , M."NOMBRE" as MEDAL, P."NOMBRE" as PAIS, O."YEAR" as OLYM
FROM "ATLETA" AS A
left JOIN "CIUDAD" AS C ON A."ID_CITY_NACIMIENTO" = C."ID"
join "RESULTADO_ATLETA" as RA ON RA."ID_ATLETA" = A."ID"
join "RESULTADO" as R on R."ID" = RA."ID_RESULTADO"
join "MEDALLA" as M on M."ID" = R."ID_MEDALLA"
join "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA" 
join "OLIMPIADA" as O on O."ID"  = R."ID_OLIMPIADA" 
where A."NOMBRE" = 'Michael Phelps' and M."NOMBRE" !='No medal';


--numero de medallas de un atleta
select count(*) as contador 
from "ATLETA" as A
join "RESULTADO_ATLETA" AS RA on RA."ID_ATLETA" = A."ID"
join "RESULTADO" as R on R."ID" = RA."ID_RESULTADO"
join "MEDALLA" as M on M."ID" = R."ID_MEDALLA"
where A."NOMBRE" like 'Michael Phelps' and M."NOMBRE"!='No medal';


--ATLETAS CON MEDALLAS POR ANIO
select A."NOMBRE", M."NOMBRE" from "ATLETA" as A
join "RESULTADO_ATLETA" as RA on RA."ID_ATLETA" = A."ID"
JOIN "RESULTADO" AS R ON R."ID" = RA."ID_RESULTADO"
JOIN "MEDALLA" AS M on M."ID" = R."ID_MEDALLA"
JOIN "OLIMPIADA" AS O ON O."ID" = R."ID_OLIMPIADA"
WHERE O."YEAR" = 2012 AND M."NOMBRE" != 'No medal'
order by A."ID" desc
limit 100;

-- Participantes por pais
select distinct A."NOMBRE" from "ATLETA" as A
join "RESULTADO_ATLETA" as RA on RA."ID_ATLETA" = A."ID"
JOIN "RESULTADO" AS R ON R."ID" = RA."ID_RESULTADO"
JOIN "MEDALLA" AS M on M."ID" = R."ID_MEDALLA"
JOIN "OLIMPIADA" AS O ON O."ID" = R."ID_OLIMPIADA"
join "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA"
WHERE O."YEAR" = 2012 AND P."NOMBRE" = 'Guatemala'
order by A."NOMBRE" desc;

-- Participantes por pais, medalla, anio y Evento en el que participaron
select A."NOMBRE" as atleta, M."NOMBRE" as medal, E."NOMBRE" as event from "ATLETA" as A
join "RESULTADO_ATLETA" as RA on RA."ID_ATLETA" = A."ID"
JOIN "RESULTADO" AS R ON R."ID" = RA."ID_RESULTADO"
JOIN "MEDALLA" AS M on M."ID" = R."ID_MEDALLA"
JOIN "OLIMPIADA" AS O ON O."ID" = R."ID_OLIMPIADA"
join "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA"
join "EVENTO" as E on E."ID" = R."ID_EVENTO"
WHERE O."YEAR" = 2012 AND P."NOMBRE" = 'Guatemala'
order by A."NOMBRE" asc;

SELECT P."NOMBRE" as PAIS, COUNT( distinct A."ID") as TOTAL_ATLETAS
FROM "ATLETA" as A
JOIN "RESULTADO_ATLETA" as RA on RA."ID_ATLETA" = A."ID"
JOIN "RESULTADO" AS R ON R."ID" = RA."ID_RESULTADO"
JOIN "OLIMPIADA" AS O ON O."ID" = R."ID_OLIMPIADA"
JOIN "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA"
WHERE O."YEAR" = 2012
GROUP BY P."NOMBRE"  -- << Aquí le decimosa: "Haz un montoncito por cada País"
ORDER BY TOTAL_ATLETAS DESC;

truncate table "PAIS", "REGION", "POBLACION", "RESULTADO_ATLETA" cascade;

SELECT 
    pr."NOMBRE" AS "Pais",
    COUNT(distinct r."ID") AS "Total_Medallas_Oro"
FROM "RESULTADO_ATLETA" ra
JOIN "RESULTADO" r ON ra."ID_RESULTADO" = r."ID"
JOIN "PAIS" pr ON ra."ID_PAIS_REPRESENTA" = pr."ID"
JOIN "MEDALLA" m ON r."ID_MEDALLA" = m."ID"
WHERE m."NOMBRE" = 'Gold'
GROUP BY pr."NOMBRE"
ORDER BY "Total_Medallas_Oro" DESC
LIMIT 10;

SELECT M."NOMBRE" as MEDALLA, COUNT(*) as TOTAL
FROM "ATLETA" A
JOIN "RESULTADO_ATLETA" RA ON RA."ID_ATLETA" = A."ID"
JOIN "RESULTADO" R ON R."ID" = RA."ID_RESULTADO"
JOIN "MEDALLA" M ON M."ID" = R."ID_MEDALLA"
WHERE A."NOMBRE" = 'Usain Bolt' AND M."NOMBRE" != 'No medal'
GROUP BY M."NOMBRE"
ORDER BY TOTAL DESC;

SELECT P."NOMBRE" AS PAIS, COUNT(DISTINCT A."ID") AS TOTAL_ATLETAS
FROM "ATLETA" as A
JOIN "RESULTADO_ATLETA" as RA on RA."ID_ATLETA" = A."ID"
JOIN "RESULTADO" AS R ON R."ID" = RA."ID_RESULTADO"
JOIN "OLIMPIADA" AS O ON O."ID" = R."ID_OLIMPIADA"
JOIN "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA"
WHERE O."YEAR" = 2020 AND O."SEASON" = 'Summer'
GROUP BY P."NOMBRE"
ORDER BY TOTAL_ATLETAS DESC
LIMIT 5;

SELECT C."NOMBRE" AS CIUDAD, COUNT(CO."ID_OLIMPIADA") AS VECES_SEDE
FROM "CIUDAD" C
JOIN "CIUDAD_OLIMPIADA" CO ON CO."ID_CIUDAD" = C."ID"
GROUP BY C."NOMBRE" and O."YEAR"
HAVING COUNT(CO."ID_OLIMPIADA") > 0
ORDER BY VECES_SEDE DESC, C."NOMBRE" ASC;

select * from "CIUDAD_OLIMPIADA";

SELECT 
    C."NOMBRE" AS CIUDAD, 
    COUNT(CO."ID_OLIMPIADA") AS VECES_SEDE, 
    STRING_AGG(O."YEAR"::text, ', ' ORDER BY O."YEAR") AS ANIOS_SEDE
FROM "CIUDAD" C
JOIN "CIUDAD_OLIMPIADA" CO ON CO."ID_CIUDAD" = C."ID"
JOIN "OLIMPIADA" as O on O."ID" = CO."ID_OLIMPIADA"
GROUP BY C."NOMBRE"
HAVING COUNT(CO."ID_OLIMPIADA") > 0
ORDER BY VECES_SEDE DESC, C."NOMBRE" ASC;

SELECT A."NOMBRE" AS ATLETA, COUNT(*) AS TOTAL_MEDALLAS
FROM "ATLETA" A
JOIN "RESULTADO_ATLETA" RA ON RA."ID_ATLETA" = A."ID"
JOIN "RESULTADO" R ON R."ID" = RA."ID_RESULTADO"
JOIN "MEDALLA" M ON M."ID" = R."ID_MEDALLA"
JOIN "EVENTO" E ON E."ID" = R."ID_EVENTO"
JOIN "DISCIPLINA" D ON D."ID" = E."ID_DISCIPLINA"
JOIN "DEPORTE" DEP ON DEP."ID" = D."ID_DEPORTE"
--WHERE DEP."NOMBRE" like '%Gym%' AND M."NOMBRE" != 'No medal'
WHERE DEP."NOMBRE" = 'Artistic Gymnastics (Gymnastics)' AND M."NOMBRE" != 'No medal'
GROUP BY A."NOMBRE"
ORDER BY TOTAL_MEDALLAS DESC
LIMIT 5;

select * from "DEPORTE"
where "NOMBRE" like '%Gym%';
