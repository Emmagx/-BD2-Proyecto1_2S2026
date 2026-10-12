-- Procedimientos Almacenados - Fase 2

-- 1. Información del Atleta
CREATE OR REPLACE FUNCTION sp_info_atleta(
    p_nombre_atleta varchar,
    p_deporte varchar DEFAULT NULL,
    p_pais varchar DEFAULT NULL,
    p_year int DEFAULT NULL
)
RETURNS TABLE (
    Atleta varchar,
    anio int,
    pais_representado varchar,
    deporte varchar,
    disciplina varchar,
    evento varchar,
    Medalla varchar,
    posicion numeric
) AS $$ 
BEGIN 
    RETURN QUERY
    SELECT A."NOMBRE", O."YEAR", P."NOMBRE", D."NOMBRE", DIS."NOMBRE", E."NOMBRE", M."NOMBRE", R."PLACE"::numeric
    FROM "ATLETA" AS A 
    JOIN "RESULTADO_ATLETA" AS RA ON RA."ID_ATLETA" = A."ID"
    JOIN "PAIS" AS P ON P."ID" = RA."ID_PAIS_REPRESENTA"
    JOIN "RESULTADO" AS R ON R."ID" = RA."ID_RESULTADO"
    JOIN "OLIMPIADA" AS O ON O."ID" = R."ID_OLIMPIADA"	
    JOIN "EVENTO" AS E ON E."ID" = R."ID_EVENTO"
    JOIN "DISCIPLINA" AS DIS ON DIS."ID" = E."ID_DISCIPLINA"
    JOIN "DEPORTE" AS D ON D."ID" = DIS."ID_DEPORTE"
    JOIN "MEDALLA" AS M ON M."ID" = R."ID_MEDALLA"
    WHERE A."NOMBRE" ILIKE '%' || p_nombre_atleta || '%'
      AND (p_deporte IS NULL OR D."NOMBRE" ILIKE '%' || p_deporte || '%')
      AND (p_pais IS NULL OR P."NOMBRE" ILIKE '%' || p_pais || '%')
      AND (p_year IS NULL OR O."YEAR" = p_year)
    ORDER BY O."YEAR" DESC, D."NOMBRE", E."NOMBRE";
END;
$$ LANGUAGE plpgsql;

-- 2. Información del país y sus sedes
CREATE OR REPLACE FUNCTION sp_info_pais(
    p_nombre_pais VARCHAR,
    p_deporte VARCHAR DEFAULT NULL,
    p_medalla VARCHAR DEFAULT NULL,
    p_anio INT DEFAULT NULL
)
RETURNS TABLE (
    Pais VARCHAR,
    Atleta VARCHAR,
    Anio_Participacion INT,
    Deporte VARCHAR,
    Evento VARCHAR,
    Medalla VARCHAR,
    Fue_Sede VARCHAR,
    Anios_Anfitrion VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    WITH Sedes AS (
        SELECT P."ID", STRING_AGG(DISTINCT O."YEAR"::TEXT, ', ' ORDER BY O."YEAR"::TEXT) AS Anios_Sede
        FROM "PAIS" P
        JOIN "REGION" REG ON REG."ID_PAIS" = P."ID"
        JOIN "CIUDAD" C ON C."ID_REGION" = REG."ID"
        JOIN "CIUDAD_OLIMPIADA" CO ON CO."ID_CIUDAD" = C."ID"
        JOIN "OLIMPIADA" O ON O."ID" = CO."ID_OLIMPIADA"
        WHERE P."NOMBRE" ILIKE '%' || p_nombre_pais || '%'
        GROUP BY P."ID"
    )
    SELECT 
        P."NOMBRE", 
        A."NOMBRE", 
        O."YEAR", 
        DEP."NOMBRE", 
        E."NOMBRE", 
        M."NOMBRE",
        (CASE WHEN S.Anios_Sede IS NOT NULL THEN 'Sí' ELSE 'No' END)::VARCHAR,
        COALESCE(S.Anios_Sede, 'Ninguno')::VARCHAR
    FROM "PAIS" P
    JOIN "RESULTADO_ATLETA" RA ON RA."ID_PAIS_REPRESENTA" = P."ID"
    JOIN "ATLETA" A ON A."ID" = RA."ID_ATLETA"
    JOIN "RESULTADO" R ON R."ID" = RA."ID_RESULTADO"
    JOIN "OLIMPIADA" O ON O."ID" = R."ID_OLIMPIADA"
    JOIN "MEDALLA" M ON M."ID" = R."ID_MEDALLA"
    JOIN "EVENTO" E ON E."ID" = R."ID_EVENTO"
    JOIN "DISCIPLINA" D ON D."ID" = E."ID_DISCIPLINA"
    JOIN "DEPORTE" DEP ON DEP."ID" = D."ID_DEPORTE"
    LEFT JOIN Sedes S ON S."ID" = P."ID"
    WHERE P."NOMBRE" ILIKE '%' || p_nombre_pais || '%'
      AND (p_deporte IS NULL OR DEP."NOMBRE" ILIKE '%' || p_deporte || '%')
      AND (p_medalla IS NULL OR M."NOMBRE" ILIKE '%' || p_medalla || '%')
      AND (p_anio IS NULL OR O."YEAR" = p_anio)
    ORDER BY O."YEAR" DESC, A."NOMBRE";
END;
$$ LANGUAGE plpgsql;
