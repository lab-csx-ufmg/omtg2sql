-- Create table bairro
CREATE TABLE bairro (
  idBairro NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_bairro PRIMARY KEY (idBairro)
);
/
-- Insert the geom column of bairro into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('bairro', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of bairro
CREATE INDEX SIDX_bairro ON bairro(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table cidade
CREATE TABLE cidade (
  idCidade NUMBER(5,0),
  nomeCidade VARCHAR2(100),
  codEstado VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT CHECK_codEstado CHECK (codEstado IN ('AL','MG','PB')),
  CONSTRAINT pk_cidade PRIMARY KEY (idCidade,nomeCidade)
);
/
-- Create multivalued table telefone_cidade
CREATE TABLE telefone_cidade (
  cidade_idCidade NUMBER(5,0),
  cidade_nomeCidade VARCHAR2(100),
  telefone VARCHAR2(10),
  CONSTRAINT pk_telefone_cidade PRIMARY KEY (cidade_idCidade,cidade_nomeCidade,telefone),
  CONSTRAINT fk_telefone_cidade_ref_cidade
    FOREIGN KEY (cidade_idCidade,cidade_nomeCidade)
    REFERENCES cidade(idCidade,nomeCidade)
);
/
-- Insert the geom column of cidade into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('cidade', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of cidade
CREATE INDEX SIDX_cidade ON cidade(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
-- Add new column (foreign key) on table bairro due conventional-relationship-cidade-contem-bairro
ALTER TABLE bairro ADD (
  cidade_idCidade NUMBER(5,0),
  cidade_nomeCidade VARCHAR2(100)
);
/
-- Add foreign key constraint on table bairro due conventional-relationship-cidade-contem-bairro
ALTER TABLE bairro ADD
  CONSTRAINT fk_bai_ref_cid
  FOREIGN KEY (cidade_idCidade,cidade_nomeCidade)
  REFERENCES cidade(idCidade,nomeCidade);
/
