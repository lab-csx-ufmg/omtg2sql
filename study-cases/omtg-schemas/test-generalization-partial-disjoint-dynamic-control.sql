-- Validate the disjoint constraint on subclass A
CREATE OR REPLACE TRIGGER val_disjoint_gen_A
   BEFORE INSERT OR UPDATE ON A
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM B sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table A idCidade = '||:NEW.X_idCidade||' nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM C sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table A idCidade = '||:NEW.X_idCidade||' nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;


END;
/
-- Validate the disjoint constraint on subclass B
CREATE OR REPLACE TRIGGER val_disjoint_gen_B
   BEFORE INSERT OR UPDATE ON B
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM A sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table B idCidade = '||:NEW.X_idCidade||' nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM C sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table B idCidade = '||:NEW.X_idCidade||' nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;


END;
/
-- Validate the disjoint constraint on subclass C
CREATE OR REPLACE TRIGGER val_disjoint_gen_C
   BEFORE INSERT OR UPDATE ON C
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM A sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table C idCidade = '||:NEW.X_idCidade||' nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM B sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table C idCidade = '||:NEW.X_idCidade||' nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;


END;
/
