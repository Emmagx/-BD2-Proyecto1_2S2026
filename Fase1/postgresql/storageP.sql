-- sql con los store procedure

-- 1 Información del Atleta
create or replace function sp_info_atleta(
p_nombre_atleta varchar,
p_deporte varchar default null,
p_pais varchar default null,
p_year int default null
)

returns table (
Atleta varchar,
anio int,
pais_representado varchar,
deporte varchar,
disciplina varchar,
evento varchar,
Medalla varchar,
posicion numeric
) as $$ 
begin 
	return QUERY
	select A."NOMBRE", O."YEAR", P."NOMBRE", D."NOMBRE", DIS."NOMBRE", E."NOMBRE", M."NOMBRE", R."PLACE"::numeric
	from "ATLETA" as A 
	join "RESULTADO_ATLETA" as RA on RA."ID_ATLETA" = A."ID"
	join "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA"
	join "RESULTADO" as R on R."ID" = RA."ID_RESULTADO"
	join "OLIMPIADA" as O on O."ID" = R."ID_OLIMPIADA"	
	join "EVENTO" as E on E."ID" = R."ID_EVENTO"
	join "DISCIPLINA" as DIS on DIS."ID" = E."ID_DISCIPLINA"
	join "DEPORTE" as D on D."ID" = DIS."ID_DEPORTE"
	join "MEDALLA" as M on M."ID" = R."ID_MEDALLA"
	where A."NOMBRE" ilike '%' || p_nombre_atleta || '%'
		and (p_deporte is null or D."NOMBRE" ilike '%' || p_deporte || '%')
		and (p_pais is null or P."NOMBRE" ilike '%' || p_pais || '%')
		and (p_year is null or O."YEAR" = p_year)
	order by O."YEAR" desc, D."NOMBRE", E."NOMBRE";
end;
$$ language plpgsql;

-- solo la consulta para probar
select A."NOMBRE", O."YEAR", P."NOMBRE", D."NOMBRE", DIS."NOMBRE", E."NOMBRE", M."NOMBRE", R."PLACE"::numeric
	from "ATLETA" as A 
	join "RESULTADO_ATLETA" as RA on RA."ID_ATLETA" = A."ID"
	join "PAIS" as P on P."ID" = RA."ID_PAIS_REPRESENTA"
	join "RESULTADO" as R on R."ID" = RA."ID_RESULTADO"
	join "OLIMPIADA" as O on O."ID" = R."ID_OLIMPIADA"	
	join "EVENTO" as E on E."ID" = R."ID_EVENTO"
	join "DISCIPLINA" as DIS on DIS."ID" = E."ID_DISCIPLINA"
	join "DEPORTE" as D on D."ID" = DIS."ID_DEPORTE"
	join "MEDALLA" as M on M."ID" = R."ID_MEDALLA";

-- Pruebas
select * from sp_info_atleta('Michael Phelps');
select * from sp_info_atleta('Michael Phelps', p_year:=2012, p_pais:='United States', p_deporte:='Swimming');

-- 2 Información del pais y sus sedes
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
        -- Subconsulta para encontrar qué años fue sede este país
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
    LEFT JOIN Sedes S ON S."ID" = P."ID" -- Se usa LEFT JOIN por si el país nunca fue sede
    WHERE P."NOMBRE" ILIKE '%' || p_nombre_pais || '%'
      AND (p_deporte IS NULL OR DEP."NOMBRE" ILIKE '%' || p_deporte || '%')
      AND (p_medalla IS NULL OR M."NOMBRE" ILIKE '%' || p_medalla || '%')
      AND (p_anio IS NULL OR O."YEAR" = p_anio)
    ORDER BY O."YEAR" DESC, A."NOMBRE";
END;
$$ LANGUAGE plpgsql;


SELECT * FROM sp_info_pais('Great Britain', p_medalla := 'Gold');

select c."NOMBRE" as CITY, p."NOMBRE" as PAIS
from "CIUDAD" as C
join "REGION" as R on R."ID" = C."ID_REGION"
join "PAIS" as P on P."ID" = R."ID_PAIS"
where C."NOMBRE" ilike '%London%';
