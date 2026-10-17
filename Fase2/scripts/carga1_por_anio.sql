-- =====================================================================
-- Carga 1 (Por Año)
-- =====================================================================

-- ---------------------------------------------------------------------
-- PREPARACIÓN: Tablas temporales en memoria

-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_resultado;
DROP TABLE IF EXISTS tmp_resultado_atleta;

CREATE TEMP TABLE tmp_resultado (LIKE "RESULTADO");
CREATE TEMP TABLE tmp_resultado_atleta (LIKE "RESULTADO_ATLETA");

-- Carga masiva a las tablas temporales desde los CSV limpios
COPY tmp_resultado FROM '/csv-limpios/12_RESULTADO.csv' WITH (FORMAT csv, HEADER true);
COPY tmp_resultado_atleta FROM '/csv-limpios/13_RESULTADO_ATLETA.csv' WITH (FORMAT csv, HEADER true);


-- =====================================================================
-- 1. CARGA INICIAL ( hasta 2012)
--    Después de esta carga se ejecutó el FULL BACKUP.
-- =====================================================================

-- Insertar resultados históricos hasta 2012
INSERT INTO "RESULTADO"
SELECT r.* FROM tmp_resultado r
JOIN "OLIMPIADA" o ON r."ID_OLIMPIADA" = o."ID"
WHERE o."YEAR" <= 2012;

-- Insertar participaciones de atletas en los resultados hasta 2012
INSERT INTO "RESULTADO_ATLETA"
SELECT ra.* FROM tmp_resultado_atleta ra
JOIN "RESULTADO" r ON ra."ID_RESULTADO" = r."ID";



-- =====================================================================
-- 2. PRIMERA CARGA INCREMENTAL (hasta 2016)
--    Después de esta carga se ejecutó el PRIMER BACKUP INCREMENTAL.
-- =====================================================================

-- Insertar resultados específicos de 2016
INSERT INTO "RESULTADO"
SELECT r.* FROM tmp_resultado r
JOIN "OLIMPIADA" o ON r."ID_OLIMPIADA" = o."ID"
WHERE o."YEAR" = 2016;

-- Insertar participaciones de atletas en los resultados de 2016
INSERT INTO "RESULTADO_ATLETA"
SELECT ra.* FROM tmp_resultado_atleta ra
JOIN "RESULTADO" r ON ra."ID_RESULTADO" = r."ID"
JOIN "OLIMPIADA" o ON r."ID_OLIMPIADA" = o."ID"
WHERE o."YEAR" = 2016;



-- =====================================================================
-- 3. SEGUNDA CARGA INCREMENTAL (hasta 2020)
--    Después de esta carga se ejecutó el SEGUNDO BACKUP INCREMENTAL.
-- =====================================================================

-- Insertar resultados específicos de 2020
INSERT INTO "RESULTADO"
SELECT r.* FROM tmp_resultado r
JOIN "OLIMPIADA" o ON r."ID_OLIMPIADA" = o."ID"
WHERE o."YEAR" = 2020;

-- Insertar participaciones de atletas en los resultados de 2020
INSERT INTO "RESULTADO_ATLETA"
SELECT ra.* FROM tmp_resultado_atleta ra
JOIN "RESULTADO" r ON ra."ID_RESULTADO" = r."ID"
JOIN "OLIMPIADA" o ON r."ID_OLIMPIADA" = o."ID"
WHERE o."YEAR" = 2020;
