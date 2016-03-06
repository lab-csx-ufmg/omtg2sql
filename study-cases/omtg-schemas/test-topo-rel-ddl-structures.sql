-- Create table bairro
CREATE TABLE bairro (
  idBairro NUMBER(5,0),
  codBairro NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_bairro PRIMARY KEY (idBairro,codBairro)
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
  nomeCidade VARCHAR2(50),
  codEstado VARCHAR2(50),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_cidade PRIMARY KEY (idCidade,nomeCidade)
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
