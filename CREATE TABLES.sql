--PostgreSQL
--drop schema public cascade;
--create schema public;

CREATE TABLE "objetos" (
  "id_objeto" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "tipo" varchar NOT NULL,
  "origem" varchar NOT NULL,
  "data" timestamp NOT NULL
);

CREATE TABLE "exposicoes" (
  "id_exposicao" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "descricao" varchar,
  "data_inicio" timestamp NOT NULL,
  "data_fim" timestamp NOT NULL
);

CREATE TABLE "visitantes" (
  "id_visitante" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "email" varchar NOT NULL,
  "data_nascimento" timestamp
);

CREATE TABLE "pesquisadores" (
  "id_pesquisador" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "especialidade" varchar NOT NULL,
  "id_objeto" integer
);

CREATE TABLE "colecoes" (
  "id_colecao" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "descricao" varchar,
  "id_objeto" integer NOT NULL
);

CREATE TABLE "funcionarios" (
  "id_funcionario" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "cargo" varchar NOT NULL,
  "setor" varchar NOT NULL
);

CREATE TABLE "eventos" (
  "id_evento" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "descricao" varchar,
  "data" timestamp NOT NULL
);

CREATE TABLE "patrocinadores" (
  "id_patrocinador" integer PRIMARY KEY,
  "nome" varchar NOT NULL,
  "tipo" varchar NOT NULL
);

CREATE TABLE "ingressos" (
  "id_ingresso" integer PRIMARY KEY,
  "id_visitante" integer NOT NULL,
  "id_evento" integer NOT NULL,
  "data_compra" timestamp NOT NULL,
  "valor" numeric NOT NULL
);

CREATE TABLE "doacoes" (
  "id_doacao" integer PRIMARY KEY,
  "id_visitante" integer NOT NULL,
  "id_objeto" integer NOT NULL,
  "valor_doacao" numeric(6,2) NOT NULL
);

CREATE TABLE "comentarios" (
  "id_comentario" integer PRIMARY KEY,
  "id_visitante" integer NOT NULL,
  "id_exposicao" integer NOT NULL,
  "texto_comentario" varchar NOT NULL
);

CREATE TABLE "transferencias" (
  "id_transferencia" integer PRIMARY KEY,
  "id_objeto" integer NOT NULL,
  "destino" varchar NOT NULL,
  "data_transferencia" timestamp NOT NULL
);

CREATE TABLE "curadores" (
  "id_curador" integer PRIMARY KEY,
  "nome" varchar NOT NULL
);

CREATE TABLE "exposicoes_objetos" (
  "id_exposicao" integer NOT NULL,
  "id_objeto" integer NOT NULL,
  PRIMARY KEY ("id_exposicao", "id_objeto")
);

CREATE TABLE "patrocinadores_exposicoes" (
  "id_patrocinador" integer NOT NULL,
  "id_exposicao" integer NOT NULL,
  "valor_doado" numeric NOT NULL,
  PRIMARY KEY ("id_patrocinador", "id_exposicao")
);

CREATE TABLE "curadores_exposicoes" (
  "id_curador" integer NOT NULL,
  "id_exposicao" integer NOT NULL,
  PRIMARY KEY ("id_curador", "id_exposicao")
);

CREATE TABLE "funcionarios_exposicoes" (
  "id_funcionario" integer NOT NULL,
  "id_exposicao" integer NOT NULL,
  "papel" varchar NOT NULL,
  PRIMARY KEY ("id_funcionario", "id_exposicao")
);

CREATE TABLE "funcionarios_eventos" (
  "id_funcionario" integer NOT NULL,
  "id_evento" integer NOT NULL,
  "papel" varchar NOT NULL,
  PRIMARY KEY ("id_funcionario", "id_evento")
);

CREATE TABLE "eventos_visitantes" (
  "id_evento" integer NOT NULL,
  "id_visitante" integer NOT NULL,
  "tipo_participacao" varchar,
  PRIMARY KEY ("id_evento", "id_visitante")
);

CREATE TABLE "eventos_exposicoes" (
  "id_evento" integer NOT NULL,
  "id_exposicao" integer NOT NULL,
  PRIMARY KEY ("id_evento", "id_exposicao")
);


ALTER TABLE "pesquisadores" 
ADD FOREIGN KEY ("id_objeto") REFERENCES "objetos" ("id_objeto");

ALTER TABLE "colecoes" 
ADD FOREIGN KEY ("id_objeto") REFERENCES "objetos" ("id_objeto");

ALTER TABLE "ingressos" 
ADD FOREIGN KEY ("id_visitante") REFERENCES "visitantes" ("id_visitante");

ALTER TABLE "ingressos" 
ADD FOREIGN KEY ("id_evento") REFERENCES "eventos" ("id_evento");

ALTER TABLE "doacoes" 
ADD FOREIGN KEY ("id_visitante") REFERENCES "visitantes" ("id_visitante");

ALTER TABLE "doacoes" 
ADD FOREIGN KEY ("id_objeto") REFERENCES "objetos" ("id_objeto");

ALTER TABLE "comentarios" 
ADD FOREIGN KEY ("id_visitante") REFERENCES "visitantes" ("id_visitante");

ALTER TABLE "comentarios" 
ADD FOREIGN KEY ("id_exposicao") REFERENCES "exposicoes" ("id_exposicao");

ALTER TABLE "transferencias" 
ADD FOREIGN KEY ("id_objeto") REFERENCES "objetos" ("id_objeto");

ALTER TABLE "exposicoes_objetos" 
ADD FOREIGN KEY ("id_exposicao") REFERENCES "exposicoes" ("id_exposicao");

ALTER TABLE "exposicoes_objetos" 
ADD FOREIGN KEY ("id_objeto") REFERENCES "objetos" ("id_objeto");

ALTER TABLE "patrocinadores_exposicoes" 
ADD FOREIGN KEY ("id_patrocinador") REFERENCES "patrocinadores" ("id_patrocinador");

ALTER TABLE "patrocinadores_exposicoes" 
ADD FOREIGN KEY ("id_exposicao") REFERENCES "exposicoes" ("id_exposicao");

ALTER TABLE "curadores_exposicoes" 
ADD FOREIGN KEY ("id_curador") REFERENCES "curadores" ("id_curador");

ALTER TABLE "curadores_exposicoes" 
ADD FOREIGN KEY ("id_exposicao") REFERENCES "exposicoes" ("id_exposicao");

ALTER TABLE "funcionarios_exposicoes" 
ADD FOREIGN KEY ("id_funcionario") REFERENCES "funcionarios" ("id_funcionario");

ALTER TABLE "funcionarios_exposicoes" 
ADD FOREIGN KEY ("id_exposicao") REFERENCES "exposicoes" ("id_exposicao");

ALTER TABLE "funcionarios_eventos" 
ADD FOREIGN KEY ("id_funcionario") REFERENCES "funcionarios" ("id_funcionario");

ALTER TABLE "funcionarios_eventos" 
ADD FOREIGN KEY ("id_evento") REFERENCES "eventos" ("id_evento");

ALTER TABLE "eventos_visitantes" 
ADD FOREIGN KEY ("id_evento") REFERENCES "eventos" ("id_evento");

ALTER TABLE "eventos_visitantes" 
ADD FOREIGN KEY ("id_visitante") REFERENCES "visitantes" ("id_visitante");

ALTER TABLE "eventos_exposicoes" 
ADD FOREIGN KEY ("id_exposicao") REFERENCES "exposicoes" ("id_exposicao");

ALTER TABLE "eventos_exposicoes" 
ADD FOREIGN KEY ("id_evento") REFERENCES "eventos" ("id_evento");

