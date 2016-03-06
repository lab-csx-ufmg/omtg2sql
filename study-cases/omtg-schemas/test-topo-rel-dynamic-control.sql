-- Validate the topological relationship between cidade and bairro
CREATE OR REPLACE TRIGGER val_top_rel_cid_bai
   BEFORE INSERT OR UPDATE ON bairro
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   w_rowid rowid;
BEGIN
   SELECT rowid INTO w_rowid
      FROM cidade w
      WHERE SDO_RELATE(w.geom, :NEW.geom, 'MASK=contains+covers+overlap') = 'TRUE' AND rownum <= 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Topological relationship between cidade and bairro idBairro = '||:NEW.idBairro||' codBairro = '||:NEW.codBairro||' is not contains,covers,overlap');
END;
/
