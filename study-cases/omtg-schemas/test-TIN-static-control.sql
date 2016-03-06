-- Validate the planar subdivision on Y
CREATE OR REPLACE FUNCTION val_pla_sub_Y
RETURN VARCHAR IS

	 p1_columns 	  VARCHAR(500);
	 p2_columns 	  VARCHAR(500);
	 p_contains_error BOOLEAN;
	 
BEGIN
	 
	 -- 1. ((Pi touch Pj) or (Pi disjoint Pj)) = T for all i, j such as i != j	 
	 FOR p IN (SELECT ps1.rowid as rowid1, ps2.rowid as rowid2
  	 	   	      FROM Y ps1, Y ps2
                  WHERE ps1.rowid != ps2.rowid AND
                        SDO_RELATE(ps1.geom, ps2.geom, 'MASK=TOUCH') != 'TRUE' AND -- not touch and not disjoint
						SDO_RELATE(ps1.geom, ps2.geom, 'MASK=ANYINTERACT') = 'TRUE') LOOP

 	 	SELECT ' idBairro = '||idBairro INTO p1_columns
 	 	   FROM Y
 	 	   WHERE rowid = p.rowid1;
 	 	
 	 	SELECT ' idBairro = '||idBairro INTO p2_columns
 	 	   FROM Y
 	 	   WHERE rowid = p.rowid2;

	    INSERT INTO spatial_error (type, error) 
           VALUES ('Planar Subdivision Error', 'Spatial relation between Y'||p1_columns||' and'||p2_columns||' is not touch or disjoint');
	    p_contains_error := TRUE;
	    COMMIT;
			 
	 END LOOP;
	 
	IF (p_contains_error = TRUE) THEN
	   RETURN 'Not valid! See table Spatial_Error for more details.';
    ELSE
 	   RETURN 'Valid! No errors were found.';
    END IF;
	 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
	 	INSERT INTO spatial_error (type, error) 
		   VALUES ('Planar Subdivision Error', 'No data found');
		COMMIT;
		RETURN 'Not valid! See table Spatial_Error for more details.';
END;
/
-- Validate the TIN on X
CREATE OR REPLACE FUNCTION val_tin_X
RETURN VARCHAR IS

	 p1_columns 	  VARCHAR(500);
	 p2_columns 	  VARCHAR(500);
	 p_contains_error BOOLEAN;
	 
BEGIN
	 
	 -- 1. ((Pi touch Pj) or (Pi disjoint Pj)) = T for all i, j such as i != j	 
	 FOR p IN (SELECT tin1.rowid as rowid1, tin2.rowid as rowid2
  	 	   	      FROM X tin1, X tin2
                  WHERE tin1.rowid != tin2.rowid AND
                        SDO_RELATE(tin1.geom, tin2.geom, 'MASK=TOUCH') != 'TRUE' AND -- not touch and not disjoint
						SDO_RELATE(tin1.geom, tin2.geom, 'MASK=ANYINTERACT') = 'TRUE') LOOP

 	 	SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO p1_columns
 	 	   FROM X
 	 	   WHERE rowid = p.rowid1;
 	 	
 	 	SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO p2_columns
 	 	   FROM X
 	 	   WHERE rowid = p.rowid2;

	    INSERT INTO spatial_error (type, error) 
           VALUES ('TIN Error', 'Spatial relation between TIN X'||p1_columns||' and'||p2_columns||' is not touch or disjoint');
	    p_contains_error := TRUE;
	    COMMIT;
			 
	 END LOOP;
	 
	 -- 2.
	 FOR p IN (SELECT tin.rowid as rowid1
  	 	   	      FROM X tin
                  WHERE SDO_UTIL.GETNUMVERTICES(geom) != 3) LOOP

 	 	SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO p1_columns
 	 	   FROM X
 	 	   WHERE rowid = p.rowid1;

	    INSERT INTO spatial_error (type, error) 
           VALUES ('TIN Error', 'Polygon TIN X'||p1_columns||' does not contain 3 vertex');
	    p_contains_error := TRUE;
	    COMMIT;
			 
	 END LOOP;
	 
	 IF (p_contains_error = TRUE) THEN
	    RETURN 'Not valid! See table Spatial_Error for more details.';
     ELSE
 	    RETURN 'Valid! No errors were found.';
     END IF;
	 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
	 	INSERT INTO spatial_error (type, error) 
		   VALUES ('TIN Error', 'No data found');
		COMMIT;
		RETURN 'Not valid! See table Spatial_Error for more details.';
END;
/
