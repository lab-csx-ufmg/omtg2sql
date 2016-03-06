-- Validate the topological relationship near between X and Y
CREATE OR REPLACE TRIGGER val_top_rel_X_Y
   BEFORE INSERT OR UPDATE ON Y
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM X w
      WHERE SDO_WITHIN_DISTANCE(w.geom, :NEW.geom, 'distance=50 unit=m') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between X and Y idBairro = '||:NEW.idBairro||' is not near with distance=50 and unit=m');
END;
/
