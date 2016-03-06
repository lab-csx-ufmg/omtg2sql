-- Create table no2
CREATE TABLE no2 (
  idCidade NUMBER(5,0),
  nomeCidade VARCHAR2(50),
  codEstado VARCHAR2(50),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_no2 PRIMARY KEY (idCidade,nomeCidade)
);
/
-- Insert the geom column of no2 into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('no2', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of no2
CREATE INDEX SIDX_no2 ON no2(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table no
CREATE TABLE no (
  idCidade NUMBER(5,0),
  nomeCidade VARCHAR2(50),
  codEstado VARCHAR2(50),
  data DATE,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_no PRIMARY KEY (idCidade,nomeCidade)
);
/
-- Insert the geom column of no into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('no', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of no
CREATE INDEX SIDX_no ON no(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table trecho
CREATE TABLE trecho (
  idBairro NUMBER(5,0),
  codBairro NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_trecho PRIMARY KEY (idBairro,codBairro)
);
/
-- Insert the geom column of trecho into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('trecho', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of trecho
CREATE INDEX SIDX_trecho ON trecho(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=LINESTRING');
/
-- Create table trecho2
CREATE TABLE trecho2 (
  idBairro NUMBER(5,0),
  codBairro NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_trecho2 PRIMARY KEY (idBairro,codBairro)
);
/
-- Insert the geom column of trecho2 into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('trecho2', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of trecho2
CREATE INDEX SIDX_trecho2 ON trecho2(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=LINESTRING');
/
-- Create the Spatial_error table to contains spatial integrity constraint error messages
CREATE TABLE Spatial_error (
  type VARCHAR2(100),
  error VARCHAR2(500)
);
/
