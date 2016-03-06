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
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table A X_idCidade = '||:NEW.X_idCidade||' X_nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM C sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table A X_idCidade = '||:NEW.X_idCidade||' X_nomeCidade = '||:NEW.X_nomeCidade||' is violated');
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
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table B X_idCidade = '||:NEW.X_idCidade||' X_nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM C sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table B X_idCidade = '||:NEW.X_idCidade||' X_nomeCidade = '||:NEW.X_nomeCidade||' is violated');
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
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table C X_idCidade = '||:NEW.X_idCidade||' X_nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM B sub
      WHERE :NEW.X_idCidade = sub.X_idCidade AND :NEW.X_nomeCidade = sub.X_nomeCidade;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table C X_idCidade = '||:NEW.X_idCidade||' X_nomeCidade = '||:NEW.X_nomeCidade||' is violated');
   END IF;


END;
/
-- Validate the disjoint constraint on subclass D
CREATE OR REPLACE TRIGGER val_disjoint_gen_D
   BEFORE INSERT OR UPDATE ON D
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM E sub
      WHERE :NEW.Y_idPais = sub.Y_idPais;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table D Y_idPais = '||:NEW.Y_idPais||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM F sub
      WHERE :NEW.Y_idPais = sub.Y_idPais;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table D Y_idPais = '||:NEW.Y_idPais||' is violated');
   END IF;


END;
/
-- Validate the disjoint constraint on subclass E
CREATE OR REPLACE TRIGGER val_disjoint_gen_E
   BEFORE INSERT OR UPDATE ON E
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM D sub
      WHERE :NEW.Y_idPais = sub.Y_idPais;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table E Y_idPais = '||:NEW.Y_idPais||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM F sub
      WHERE :NEW.Y_idPais = sub.Y_idPais;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table E Y_idPais = '||:NEW.Y_idPais||' is violated');
   END IF;


END;
/
-- Validate the disjoint constraint on subclass F
CREATE OR REPLACE TRIGGER val_disjoint_gen_F
   BEFORE INSERT OR UPDATE ON F
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   n NUMBER;
BEGIN

   SELECT count(*) INTO n
      FROM D sub
      WHERE :NEW.Y_idPais = sub.Y_idPais;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table F Y_idPais = '||:NEW.Y_idPais||' is violated');
   END IF;

   SELECT count(*) INTO n
      FROM E sub
      WHERE :NEW.Y_idPais = sub.Y_idPais;

   IF (n >= 1) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Disjoint constraint of generalization on table F Y_idPais = '||:NEW.Y_idPais||' is violated');
   END IF;


END;
/
