-- Validate the disjoint constraint on subclass Residence
CREATE OR REPLACE TRIGGER val_disjoint_gen_Res
   BEFORE INSERT OR UPDATE ON Residence
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM Commerce sub
      WHERE :NEW.Building_id = sub.Building_id;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table Residence Building_id = '||:NEW.Building_id||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM Industry sub
      WHERE :NEW.Building_id = sub.Building_id;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table Residence Building_id = '||:NEW.Building_id||' is violated');
   END IF;


END;
/
-- Validate the disjoint constraint on subclass Commerce
CREATE OR REPLACE TRIGGER val_disjoint_gen_Com
   BEFORE INSERT OR UPDATE ON Commerce
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM Residence sub
      WHERE :NEW.Building_id = sub.Building_id;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table Commerce Building_id = '||:NEW.Building_id||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM Industry sub
      WHERE :NEW.Building_id = sub.Building_id;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table Commerce Building_id = '||:NEW.Building_id||' is violated');
   END IF;


END;
/
-- Validate the disjoint constraint on subclass Industry
CREATE OR REPLACE TRIGGER val_disjoint_gen_Ind
   BEFORE INSERT OR UPDATE ON Industry
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM Residence sub
      WHERE :NEW.Building_id = sub.Building_id;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table Industry Building_id = '||:NEW.Building_id||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM Commerce sub
      WHERE :NEW.Building_id = sub.Building_id;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table Industry Building_id = '||:NEW.Building_id||' is violated');
   END IF;


END;
/
-- Validate the topological relationship near between Residence and StreetSegment
CREATE OR REPLACE TRIGGER val_top_rel_Res_Str
   BEFORE INSERT OR UPDATE ON StreetSegment
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM Residence w
      WHERE SDO_WITHIN_DISTANCE(w.geom, :NEW.geom, 'distance=50 unit=m') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between Residence and StreetSegment id = '||:NEW.id||' is not near with distance=50 and unit=m');
END;
/
-- Validate the topological relationship near between Commerce and StreetSegment
CREATE OR REPLACE TRIGGER val_top_rel_Com_Str
   BEFORE INSERT OR UPDATE ON StreetSegment
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM Commerce w
      WHERE SDO_WITHIN_DISTANCE(w.geom, :NEW.geom, 'distance=50 unit=m') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between Commerce and StreetSegment id = '||:NEW.id||' is not near with distance=50 and unit=m');
END;
/
-- Validate the topological relationship near between Industry and StreetSegment
CREATE OR REPLACE TRIGGER val_top_rel_Ind_Str
   BEFORE INSERT OR UPDATE ON StreetSegment
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM Industry w
      WHERE SDO_WITHIN_DISTANCE(w.geom, :NEW.geom, 'distance=50 unit=m') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between Industry and StreetSegment id = '||:NEW.id||' is not near with distance=50 and unit=m');
END;
/
-- Validate the user-defined restriction between StreetSegment and Block
CREATE OR REPLACE TRIGGER val_user_res_Str_Blo
   BEFORE INSERT OR UPDATE ON Block
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM StreetSegment w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=overlapbdyintersect+overlapbdydisjoint+inside+coveredby') != 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'User-defined restriction between StreetSegment and Block code = '||:NEW.code||' is overlapbdyintersect,overlapbdydisjoint,inside,coveredby');
END;
/
-- Validate the topological relationship between RegionBoundary and StreetCrossing
CREATE OR REPLACE TRIGGER val_top_rel_Reg_Str
   BEFORE INSERT OR UPDATE ON StreetCrossing
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM RegionBoundary w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=contains+touch') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between RegionBoundary and StreetCrossing id = '||:NEW.id||' is not contains,touch');
END;
/
-- Validate the topological relationship between Block and Residence
CREATE OR REPLACE TRIGGER val_top_rel_Blo_Res
   BEFORE INSERT OR UPDATE ON Residence
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM Block w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=contains') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between Block and Residence Building_id = '||:NEW.Building_id||' is not contains');
END;
/
-- Validate the topological relationship between Block and Commerce
CREATE OR REPLACE TRIGGER val_top_rel_Blo_Com
   BEFORE INSERT OR UPDATE ON Commerce
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM Block w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=contains') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between Block and Commerce Building_id = '||:NEW.Building_id||' is not contains');
END;
/
-- Validate the topological relationship between Block and Industry
CREATE OR REPLACE TRIGGER val_top_rel_Blo_Ind
   BEFORE INSERT OR UPDATE ON Industry
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM Block w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=contains') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between Block and Industry Building_id = '||:NEW.Building_id||' is not contains');
END;
/
-- Validate the topological relationship between StreetSegment and Neighborhood
CREATE OR REPLACE TRIGGER val_top_rel_Str_Nei
   BEFORE INSERT OR UPDATE ON Neighborhood
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM StreetSegment w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=overlapbdyintersect+overlapbdydisjoint+inside+coveredby') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between StreetSegment and Neighborhood code = '||:NEW.code||' is not overlapbdyintersect,overlapbdydisjoint,inside,coveredby');
END;
/
-- Validate the topological relationship between Neighborhood and Block
CREATE OR REPLACE TRIGGER val_top_rel_Nei_Blo
   BEFORE INSERT OR UPDATE ON Block
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM Neighborhood w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=contains+covers') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between Neighborhood and Block code = '||:NEW.code||' is not contains,covers');
END;
/
