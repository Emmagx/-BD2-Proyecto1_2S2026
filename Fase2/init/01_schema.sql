-- Esquema DDL Consolidado - Fase 2
CREATE SCHEMA IF NOT EXISTS "public";

CREATE TABLE "ATLETA" (
	"ID" integer PRIMARY KEY,
	"NOMBRE" varchar(100),
	"BORN_DATE" date,
	"DIED_DATE" date,
	"ALTURA" numeric(5, 2),
	"PESO" numeric(5, 2),
	"SEXO" varchar(1),
	"ID_CITY_NACIMIENTO" integer
);

CREATE TABLE "CIUDAD" (
	"ID" integer PRIMARY KEY,
	"NOMBRE" varchar(100),
	"LAT" numeric(10, 7),
	"LONG" numeric(10, 7),
	"ID_REGION" integer
);

CREATE TABLE "CIUDAD_OLIMPIADA" (
	"ID_OLIMPIADA" integer,
	"ID_CIUDAD" integer,
	CONSTRAINT "CIUDAD_OLIMPIADA_pkey" PRIMARY KEY("ID_OLIMPIADA","ID_CIUDAD")
);

CREATE TABLE "DEPORTE" (
	"ID" integer PRIMARY KEY,
	"NOMBRE" varchar(50)
);

CREATE TABLE "DISCIPLINA" (
	"ID" integer PRIMARY KEY,
	"NOMBRE" varchar(150),
	"ID_DEPORTE" integer NOT NULL
);

CREATE TABLE "EVENTO" (
	"ID" bigint PRIMARY KEY,
	"NOMBRE" varchar(250),
	"ID_DISCIPLINA" integer NOT NULL
);

CREATE TABLE "MEDALLA" (
	"ID" integer PRIMARY KEY,
	"NOMBRE" varchar(15)
);

CREATE TABLE "OLIMPIADA" (
	"ID" integer PRIMARY KEY,
	"SEASON" varchar(15),
	"YEAR" integer
);

CREATE TABLE "PAIS" (
	"ID" integer PRIMARY KEY,
	"NOMBRE" varchar(100),
	"NOC" varchar(5)
);

CREATE TABLE "POBLACION" (
	"ID" integer PRIMARY KEY,
	"YEAR" integer,
	"CANTIDAD" bigint,
	"ID_PAIS" integer NOT NULL
);

CREATE TABLE "REGION" (
	"ID" integer PRIMARY KEY,
	"NOMBRE" varchar(100),
	"ID_PAIS" integer
);

CREATE TABLE "RESULTADO" (
	"ID" integer PRIMARY KEY,
	"TIED" boolean,
	"PLACE" integer,
	"STATE" varchar(10),
	"ID_MEDALLA" integer,
	"ID_OLIMPIADA" integer NOT NULL,
	"ID_EVENTO" integer NOT NULL
);

CREATE TABLE "RESULTADO_ATLETA" (
	"ID" integer PRIMARY KEY,
	"EDAD" integer,
	"ID_ATLETA" integer NOT NULL,
	"ID_RESULTADO" integer NOT NULL,
	"ID_PAIS_REPRESENTA" integer,
	CONSTRAINT "RESULTADO_ATLETA_ID_ATLETA_ID_RESULTADO_key" UNIQUE("ID_ATLETA","ID_RESULTADO")
);


--Agregar el wal Summarize para postgres 17
ALTER SYSTEM SET summarize_wal = 'on';
SELECT pg_reload_conf();
