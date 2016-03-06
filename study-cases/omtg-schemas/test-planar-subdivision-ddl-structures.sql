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
  nomeCidade VARCHAR2(50) NOT NULL,
  codEstado VARCHAR2(50) DEFAULT 'AL',
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT CHECK_codEstado CHECK (codEstado IN ('AL','MG','PB')),
  CONSTRAINT pk_cidade PRIMARY KEY (idCidade,nomeCidade)
);
/
-- Create multivalued table telefone_cidade
CREATE TABLE telefone_cidade (
  cidade_idCidade NUMBER(5,0),
  cidade_nomeCidade VARCHAR2(50),
  telefone VARCHAR2(10),
  CONSTRAINT pk_telefone_cidade PRIMARY KEY (cidade_idCidade,cidade_nomeCidade,telefone),
  CONSTRAINT fk_telefone_cidade_ref_cidade
    FOREIGN KEY (cidade_idCidade,cidade_nomeCidade)
    REFERENCES cidade(idCidade,nomeCidade)
);
/
-- Create the Spatial_error table to contains spatial integrity constraint error messages
CREATE TABLE Spatial_error (
  type VARCHAR2(100),
  error VARCHAR2(500)
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
-- Create the Sa_aux table to support spatial aggregation constraint
CREATE TABLE Sa_aux (
  w_rowid ROWID,
  p_rowid ROWID,
  p_geom MDSYS.SDO_GEOMETRY
);
/
-- Insert the geom column of Sa_aux into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('Sa_aux', 'p_geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of Sa_aux
CREATE INDEX SIDX_Sa_aux ON Sa_aux(p_geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
