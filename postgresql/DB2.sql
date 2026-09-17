CREATE TABLE "PAIS" (
  "ID" integer PRIMARY KEY,
  "NOMBRE" varchar(100),
  "NOC" varchar(5)
);

CREATE TABLE "REGION" (
  "ID" integer PRIMARY KEY,
  "NOMBRE" varchar(100),
  "ID_PAIS" integer -- Removido el NOT NULL (Regiones sin país exacto)
);

CREATE TABLE "CIUDAD" (
  "ID" integer PRIMARY KEY,
  "NOMBRE" varchar(100),
  "LAT" decimal(10,7), 
  "LONG" decimal(10,7), 
  "ID_REGION" integer -- Removido el NOT NULL (Ciudades anfitrionas sin región)
);

CREATE TABLE "POBLACION" (
  "ID" integer PRIMARY KEY, 
  "YEAR" integer,
  "CANTIDAD" bigint,
  "ID_PAIS" integer NOT NULL
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
  "ID" integer PRIMARY KEY,
  "NOMBRE" varchar(150),
  "ID_DISCIPLINA" int NOT NULL
);

CREATE TABLE "OLIMPIADA" (
  "ID" integer PRIMARY KEY,
  "SEASON" varchar(15),
  "YEAR" integer
);

CREATE TABLE "CIUDAD_OLIMPIADA" (
  "ID_OLIMPIADA" integer NOT NULL,
  "ID_CIUDAD" integer NOT NULL,
  PRIMARY KEY ("ID_OLIMPIADA", "ID_CIUDAD")
);

CREATE TABLE "MEDALLA" (
  "ID" integer PRIMARY KEY,
  "NOMBRE" varchar(15)
);

CREATE TABLE "ATLETA" (
  "ID" integer PRIMARY KEY,
  "NOMBRE" varchar(100),
  "BORN_DATE" date,
  "DIED_DATE" date,
  "ALTURA" decimal(5,2),
  "PESO" decimal(5,2), 
  "SEXO" varchar(1),
  "ID_CITY_NACIMIENTO" int -- Removido el NOT NULL (Atletas sin ciudad de nacimiento)
);

CREATE TABLE "RESULTADO" (
  "ID" int PRIMARY KEY,
  "TIED" bool,
  "PLACE" integer,
  "STATE" VARCHAR(10), 
  "ID_MEDALLA" integer,
  "ID_OLIMPIADA" integer NOT NULL,
  "ID_EVENTO" integer NOT NULL
);

CREATE TABLE "RESULTADO_ATLETA" (
  "ID" integer PRIMARY KEY,          
  "EDAD" integer,
  "ID_ATLETA" integer NOT NULL,
  "ID_RESULTADO" integer NOT NULL,
  "ID_PAIS_REPRESENTA" int, -- Removido el NOT NULL (Atletas independientes)
  UNIQUE ("ID_ATLETA", "ID_RESULTADO") 
);
