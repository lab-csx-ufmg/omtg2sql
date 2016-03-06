-- Create table A
CREATE TABLE A (
  X_idCidade NUMBER(5,0),
  X_nomeCidade VARCHAR2(100) NOT NULL,
  X_codEstado VARCHAR2(100) NOT NULL,
  codA VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_A PRIMARY KEY (X_idCidade,X_nomeCidade)
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
-- Create table B
CREATE TABLE B (
  X_idCidade NUMBER(5,0),
  X_nomeCidade VARCHAR2(100) NOT NULL,
  X_codEstado VARCHAR2(100) NOT NULL,
  codB VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_B PRIMARY KEY (X_idCidade,X_nomeCidade)
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
-- Create table C
CREATE TABLE C (
  X_idCidade NUMBER(5,0),
  X_nomeCidade VARCHAR2(100) NOT NULL,
  X_codEstado VARCHAR2(100) NOT NULL,
  codC VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_C PRIMARY KEY (X_idCidade,X_nomeCidade)
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
-- Create table D
CREATE TABLE D (
  Y_idPais NUMBER(5,0),
  Y_codPais VARCHAR2(100) NOT NULL,
  codD VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_D PRIMARY KEY (Y_idPais)
);
/
-- Insert the geom column of D into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('D', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of D
CREATE INDEX SIDX_D ON D(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table E
CREATE TABLE E (
  Y_idPais NUMBER(5,0),
  Y_codPais VARCHAR2(100) NOT NULL,
  codE VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_E PRIMARY KEY (Y_idPais)
);
/
-- Insert the geom column of E into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('E', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of E
CREATE INDEX SIDX_E ON E(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table F
CREATE TABLE F (
  Y_idPais NUMBER(5,0),
  Y_codPais VARCHAR2(100) NOT NULL,
  codF VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_F PRIMARY KEY (Y_idPais)
);
/
-- Insert the geom column of F into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('F', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of F
CREATE INDEX SIDX_F ON F(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table D_A
CREATE TABLE D_A (
  D_Y_idPais NUMBER(5,0),
  A_X_idCidade NUMBER(5,0),
  A_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_D_A PRIMARY KEY (D_Y_idPais,A_X_idCidade,A_X_nomeCidade)
);
/
-- Add foreign key constraint on table D_A due conventional-relationship-Y-contem-X
ALTER TABLE D_A ADD
  CONSTRAINT fk_D_A_ref_D
  FOREIGN KEY (D_Y_idPais)
  REFERENCES D(Y_idPais);
/
-- Add foreign key constraint on table D_A due conventional-relationship-Y-contem-X
ALTER TABLE D_A ADD
  CONSTRAINT fk_D_A_ref_A
  FOREIGN KEY (A_X_idCidade,A_X_nomeCidade)
  REFERENCES A(X_idCidade,X_nomeCidade);
/
-- Create table D_B
CREATE TABLE D_B (
  D_Y_idPais NUMBER(5,0),
  B_X_idCidade NUMBER(5,0),
  B_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_D_B PRIMARY KEY (D_Y_idPais,B_X_idCidade,B_X_nomeCidade)
);
/
-- Add foreign key constraint on table D_B due conventional-relationship-Y-contem-X
ALTER TABLE D_B ADD
  CONSTRAINT fk_D_B_ref_D
  FOREIGN KEY (D_Y_idPais)
  REFERENCES D(Y_idPais);
/
-- Add foreign key constraint on table D_B due conventional-relationship-Y-contem-X
ALTER TABLE D_B ADD
  CONSTRAINT fk_D_B_ref_B
  FOREIGN KEY (B_X_idCidade,B_X_nomeCidade)
  REFERENCES B(X_idCidade,X_nomeCidade);
/
-- Create table D_C
CREATE TABLE D_C (
  D_Y_idPais NUMBER(5,0),
  C_X_idCidade NUMBER(5,0),
  C_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_D_C PRIMARY KEY (D_Y_idPais,C_X_idCidade,C_X_nomeCidade)
);
/
-- Add foreign key constraint on table D_C due conventional-relationship-Y-contem-X
ALTER TABLE D_C ADD
  CONSTRAINT fk_D_C_ref_D
  FOREIGN KEY (D_Y_idPais)
  REFERENCES D(Y_idPais);
/
-- Add foreign key constraint on table D_C due conventional-relationship-Y-contem-X
ALTER TABLE D_C ADD
  CONSTRAINT fk_D_C_ref_C
  FOREIGN KEY (C_X_idCidade,C_X_nomeCidade)
  REFERENCES C(X_idCidade,X_nomeCidade);
/
-- Create table E_A
CREATE TABLE E_A (
  E_Y_idPais NUMBER(5,0),
  A_X_idCidade NUMBER(5,0),
  A_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_E_A PRIMARY KEY (E_Y_idPais,A_X_idCidade,A_X_nomeCidade)
);
/
-- Add foreign key constraint on table E_A due conventional-relationship-Y-contem-X
ALTER TABLE E_A ADD
  CONSTRAINT fk_E_A_ref_E
  FOREIGN KEY (E_Y_idPais)
  REFERENCES E(Y_idPais);
/
-- Add foreign key constraint on table E_A due conventional-relationship-Y-contem-X
ALTER TABLE E_A ADD
  CONSTRAINT fk_E_A_ref_A
  FOREIGN KEY (A_X_idCidade,A_X_nomeCidade)
  REFERENCES A(X_idCidade,X_nomeCidade);
/
-- Create table E_B
CREATE TABLE E_B (
  E_Y_idPais NUMBER(5,0),
  B_X_idCidade NUMBER(5,0),
  B_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_E_B PRIMARY KEY (E_Y_idPais,B_X_idCidade,B_X_nomeCidade)
);
/
-- Add foreign key constraint on table E_B due conventional-relationship-Y-contem-X
ALTER TABLE E_B ADD
  CONSTRAINT fk_E_B_ref_E
  FOREIGN KEY (E_Y_idPais)
  REFERENCES E(Y_idPais);
/
-- Add foreign key constraint on table E_B due conventional-relationship-Y-contem-X
ALTER TABLE E_B ADD
  CONSTRAINT fk_E_B_ref_B
  FOREIGN KEY (B_X_idCidade,B_X_nomeCidade)
  REFERENCES B(X_idCidade,X_nomeCidade);
/
-- Create table E_C
CREATE TABLE E_C (
  E_Y_idPais NUMBER(5,0),
  C_X_idCidade NUMBER(5,0),
  C_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_E_C PRIMARY KEY (E_Y_idPais,C_X_idCidade,C_X_nomeCidade)
);
/
-- Add foreign key constraint on table E_C due conventional-relationship-Y-contem-X
ALTER TABLE E_C ADD
  CONSTRAINT fk_E_C_ref_E
  FOREIGN KEY (E_Y_idPais)
  REFERENCES E(Y_idPais);
/
-- Add foreign key constraint on table E_C due conventional-relationship-Y-contem-X
ALTER TABLE E_C ADD
  CONSTRAINT fk_E_C_ref_C
  FOREIGN KEY (C_X_idCidade,C_X_nomeCidade)
  REFERENCES C(X_idCidade,X_nomeCidade);
/
-- Create table F_A
CREATE TABLE F_A (
  F_Y_idPais NUMBER(5,0),
  A_X_idCidade NUMBER(5,0),
  A_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_F_A PRIMARY KEY (F_Y_idPais,A_X_idCidade,A_X_nomeCidade)
);
/
-- Add foreign key constraint on table F_A due conventional-relationship-Y-contem-X
ALTER TABLE F_A ADD
  CONSTRAINT fk_F_A_ref_F
  FOREIGN KEY (F_Y_idPais)
  REFERENCES F(Y_idPais);
/
-- Add foreign key constraint on table F_A due conventional-relationship-Y-contem-X
ALTER TABLE F_A ADD
  CONSTRAINT fk_F_A_ref_A
  FOREIGN KEY (A_X_idCidade,A_X_nomeCidade)
  REFERENCES A(X_idCidade,X_nomeCidade);
/
-- Create table F_B
CREATE TABLE F_B (
  F_Y_idPais NUMBER(5,0),
  B_X_idCidade NUMBER(5,0),
  B_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_F_B PRIMARY KEY (F_Y_idPais,B_X_idCidade,B_X_nomeCidade)
);
/
-- Add foreign key constraint on table F_B due conventional-relationship-Y-contem-X
ALTER TABLE F_B ADD
  CONSTRAINT fk_F_B_ref_F
  FOREIGN KEY (F_Y_idPais)
  REFERENCES F(Y_idPais);
/
-- Add foreign key constraint on table F_B due conventional-relationship-Y-contem-X
ALTER TABLE F_B ADD
  CONSTRAINT fk_F_B_ref_B
  FOREIGN KEY (B_X_idCidade,B_X_nomeCidade)
  REFERENCES B(X_idCidade,X_nomeCidade);
/
-- Create table F_C
CREATE TABLE F_C (
  F_Y_idPais NUMBER(5,0),
  C_X_idCidade NUMBER(5,0),
  C_X_nomeCidade VARCHAR2(100),
  CONSTRAINT pk_F_C PRIMARY KEY (F_Y_idPais,C_X_idCidade,C_X_nomeCidade)
);
/
-- Add foreign key constraint on table F_C due conventional-relationship-Y-contem-X
ALTER TABLE F_C ADD
  CONSTRAINT fk_F_C_ref_F
  FOREIGN KEY (F_Y_idPais)
  REFERENCES F(Y_idPais);
/
-- Add foreign key constraint on table F_C due conventional-relationship-Y-contem-X
ALTER TABLE F_C ADD
  CONSTRAINT fk_F_C_ref_C
  FOREIGN KEY (C_X_idCidade,C_X_nomeCidade)
  REFERENCES C(X_idCidade,X_nomeCidade);
/
