-- Create table StreetSegment
CREATE TABLE StreetSegment (
  id NUMBER(5,0),
  type VARCHAR2(100),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_StreetSegment PRIMARY KEY (id)
);
/
-- Insert the geom column of StreetSegment into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('StreetSegment', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of StreetSegment
CREATE INDEX SIDX_StreetSegment ON StreetSegment(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=LINESTRING');
/
-- Create table StreetCrossing
CREATE TABLE StreetCrossing (
  id NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_StreetCrossing PRIMARY KEY (id)
);
/
-- Insert the geom column of StreetCrossing into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('StreetCrossing', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of StreetCrossing
CREATE INDEX SIDX_StreetCrossing ON StreetCrossing(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table Neighborhood
CREATE TABLE Neighborhood (
  code NUMBER(5,0),
  name VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_Neighborhood PRIMARY KEY (code)
);
/
-- Insert the geom column of Neighborhood into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('Neighborhood', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of Neighborhood
CREATE INDEX SIDX_Neighborhood ON Neighborhood(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
-- Create table Thoroughfare
CREATE TABLE Thoroughfare (
  id NUMBER(5,0),
  name VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_Thoroughfare PRIMARY KEY (id)
);
/
-- Create table Block
CREATE TABLE Block (
  code NUMBER(5,0),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_Block PRIMARY KEY (code)
);
/
-- Insert the geom column of Block into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('Block', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of Block
CREATE INDEX SIDX_Block ON Block(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POLYGON');
/
-- Create table Residence
CREATE TABLE Residence (
  Building_id NUMBER(5,0),
  Building_number NUMBER(5,0) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_Residence PRIMARY KEY (Building_id)
);
/
-- Insert the geom column of Residence into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('Residence', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of Residence
CREATE INDEX SIDX_Residence ON Residence(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table Commerce
CREATE TABLE Commerce (
  Building_id NUMBER(5,0),
  Building_number NUMBER(5,0) NOT NULL,
  commerceType VARCHAR2(100),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_Commerce PRIMARY KEY (Building_id)
);
/
-- Insert the geom column of Commerce into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('Commerce', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of Commerce
CREATE INDEX SIDX_Commerce ON Commerce(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table Industry
CREATE TABLE Industry (
  Building_id NUMBER(5,0),
  Building_number NUMBER(5,0) NOT NULL,
  industryType VARCHAR2(100),
  industrySize VARCHAR2(100),
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT CHECK_industrySize CHECK (industrySize IN ('small','medium','large')),
  CONSTRAINT pk_Industry PRIMARY KEY (Building_id)
);
/
-- Insert the geom column of Industry into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('Industry', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of Industry
CREATE INDEX SIDX_Industry ON Industry(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table RegionPoint
CREATE TABLE RegionPoint (
  Region_code NUMBER(5,0),
  Region_name VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_RegionPoint PRIMARY KEY (Region_code)
);
/
-- Insert the geom column of RegionPoint into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('RegionPoint', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of RegionPoint
CREATE INDEX SIDX_RegionPoint ON RegionPoint(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=2, LAYER_GTYPE=POINT');
/
-- Create table RegionBoundary
CREATE TABLE RegionBoundary (
  Region_code NUMBER(5,0),
  Region_name VARCHAR2(100) NOT NULL,
  geom MDSYS.SDO_GEOMETRY,
  CONSTRAINT pk_RegionBoundary PRIMARY KEY (Region_code)
);
/
-- Create the Spatial_error table to contains spatial integrity constraint error messages
CREATE TABLE Spatial_error (
  type VARCHAR2(100),
  error VARCHAR2(500)
);
/
-- Insert the geom column of RegionBoundary into metadata table USER_SDO_GEOM_METADATA
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('RegionBoundary', 'geom',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', -180.000000000, 180.000000000, 0.005),
      MDSYS.SDO_DIM_ELEMENT('Y', -90.000000000, 90.000000000, 0.005)),
    '29100');
/
-- Create the spatial index on geom column of RegionBoundary
CREATE INDEX SIDX_RegionBoundary ON RegionBoundary(geom)
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
-- Add new column (foreign key) on table StreetSegment due conventional-relationship-StreetSegment-belongs-Thoroughfare
ALTER TABLE StreetSegment ADD (
  Thoroughfare_id NUMBER(5,0)
);
/
-- Add foreign key constraint on table StreetSegment due conventional-relationship-StreetSegment-belongs-Thoroughfare
ALTER TABLE StreetSegment ADD
  CONSTRAINT fk_Str_ref_Tho
  FOREIGN KEY (Thoroughfare_id)
  REFERENCES Thoroughfare(id);
/
