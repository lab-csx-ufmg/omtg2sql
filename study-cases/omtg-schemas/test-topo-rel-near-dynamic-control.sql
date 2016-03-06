-- Validate the topological relationship near between cidade and bairro
CREATE OR REPLACE TRIGGER val_top_rel_cid_bai
   BEFORE INSERT OR UPDATE ON bairro
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM cidade w
      WHERE SDO_WITHIN_DISTANCE(w.geom, :NEW.geom, 'distance=75 unit=m') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between cidade and bairro idBairro = '||:NEW.idBairro||' codBairro = '||:NEW.codBairro||' is not near with distance=75 and unit=m');
END;
/
