-- Create table Y
CREATE TABLE Y (
  idBairro NUMBER(5,0),
  geom MDSYS.SDO_GEORASTER,
  CONSTRAINT pk_Y PRIMARY KEY (idBairro)
);
/
-- Create table X
CREATE TABLE X (
  idCidade NUMBER(5,0) NOT NULL,
  nomeCidade VARCHAR2(50) NOT NULL,
  codEstado VARCHAR2(50),
  geom MDSYS.SDO_GEORASTER,
  CONSTRAINT CHECK_codEstado CHECK (codEstado IN ('AL','MG','PB')),
  CONSTRAINT pk_X PRIMARY KEY (idCidade,nomeCidade)
);
/
