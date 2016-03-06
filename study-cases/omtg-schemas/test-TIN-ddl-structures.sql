-- Create table Y
CREATE TABLE Y (
  idBairro NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_Y PRIMARY KEY (idBairro)
);
/
-- Create multivalued table telefone_Y
CREATE TABLE telefone_Y (
  Y_idBairro NUMBER(5,0),
  telefone VARCHAR2(50),
  CONSTRAINT pk_telefone_Y PRIMARY KEY (Y_idBairro,telefone),
  CONSTRAINT fk_telefone_Y_ref_Y
    FOREIGN KEY (Y_idBairro)
    REFERENCES Y(idBairro)
);
/
-- Create the Spatial_error table to contains spatial integrity constraint error messages
CREATE TABLE Spatial_error (
  type VARCHAR2(100),
  error VARCHAR2(500)
);
/
-- Insert the geom column of Y into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('Y', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of Y
CREATE INDEX SIDX_Y ON Y(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
-- Create table X
CREATE TABLE X (
  idCidade NUMBER(5,0),
  nomeCidade VARCHAR2(50) NOT NULL,
  codEstado VARCHAR2(50),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT CHECK_codEstado CHECK (codEstado IN ('AL','MG','PB')),
  CONSTRAINT pk_X PRIMARY KEY (idCidade,nomeCidade)
);
/
-- Create multivalued table telefone_X
CREATE TABLE telefone_X (
  X_idCidade NUMBER(5,0),
  X_nomeCidade VARCHAR2(50),
  telefone VARCHAR2(50),
  CONSTRAINT pk_telefone_X PRIMARY KEY (X_idCidade,X_nomeCidade,telefone),
  CONSTRAINT fk_telefone_X_ref_X
    FOREIGN KEY (X_idCidade,X_nomeCidade)
    REFERENCES X(idCidade,nomeCidade)
);
/
-- Insert the geom column of X into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('X', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of X
CREATE INDEX SIDX_X ON X(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
