-- Create table X
CREATE TABLE X (
  idCidade NUMBER(5,0),
  nomeCidade VARCHAR2(100),
  codEstado VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_X PRIMARY KEY (idCidade,nomeCidade)
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
-- Create table A
CREATE TABLE A (
  codA VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY
);
/
-- Insert the geom column of A into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('A', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of A
CREATE INDEX SIDX_A ON A(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
-- Add new column (foreign key) on table A due generalization-X
ALTER TABLE A ADD (
  X_idCidade NUMBER(5,0),
  X_nomeCidade VARCHAR2(100)
);
/
-- Add foreign key constraint on table A due generalization-X
ALTER TABLE A ADD
  CONSTRAINT fk_A_ref_X
  FOREIGN KEY (X_idCidade,X_nomeCidade)
  REFERENCES X(idCidade,nomeCidade);
/
-- Create table B
CREATE TABLE B (
  codB VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY
);
/
-- Insert the geom column of B into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('B', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of B
CREATE INDEX SIDX_B ON B(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
-- Add new column (foreign key) on table B due generalization-X
ALTER TABLE B ADD (
  X_idCidade NUMBER(5,0),
  X_nomeCidade VARCHAR2(100)
);
/
-- Add foreign key constraint on table B due generalization-X
ALTER TABLE B ADD
  CONSTRAINT fk_B_ref_X
  FOREIGN KEY (X_idCidade,X_nomeCidade)
  REFERENCES X(idCidade,nomeCidade);
/
-- Create table C
CREATE TABLE C (
  codC VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY
);
/
-- Insert the geom column of C into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('C', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of C
CREATE INDEX SIDX_C ON C(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
-- Add new column (foreign key) on table C due generalization-X
ALTER TABLE C ADD (
  X_idCidade NUMBER(5,0),
  X_nomeCidade VARCHAR2(100)
);
/
-- Add foreign key constraint on table C due generalization-X
ALTER TABLE C ADD
  CONSTRAINT fk_C_ref_X
  FOREIGN KEY (X_idCidade,X_nomeCidade)
  REFERENCES X(idCidade,nomeCidade);
/
