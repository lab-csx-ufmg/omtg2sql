-- Create table X
CREATE TABLE X (
  idBairro NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_X PRIMARY KEY (idBairro)
);
/
-- Create the Spatial_error table to contains spatial integrity constraint error messages
CREATE TABLE Spatial_error (
  type VARCHAR2(100),
  error VARCHAR2(500)
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
-- Create table ContourLines
CREATE TABLE ContourLines (
  idCidade NUMBER(5,0),
  nomeCidade VARCHAR2(100) DEFAULT 'nome da cidade' NOT NULL,
  codEstado VARCHAR2(100),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT CHECK_codEstado CHECK (codEstado IN ('AL','MG','PB')),
  CONSTRAINT pk_ContourLines PRIMARY KEY (idCidade,nomeCidade)
);
/
-- Create multivalued table telefone_ContourLines
CREATE TABLE telefone_ContourLines (
  ContourLines_idCidade NUMBER(5,0),
  ContourLines_nomeCidade VARCHAR2(100),
  telefone NUMBER(null,1),
  CONSTRAINT pk_telefone_ContourLines PRIMARY KEY (ContourLines_idCidade,ContourLines_nomeCidade,telefone),
  CONSTRAINT fk_telefone_ContourLines_ref_ContourLines
    FOREIGN KEY (ContourLines_idCidade,ContourLines_nomeCidade)
    REFERENCES ContourLines(idCidade,nomeCidade)
);
/
-- Insert the geom column of ContourLines into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('ContourLines', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of ContourLines
CREATE INDEX SIDX_ContourLines ON ContourLines(geom)
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
