-- Validate the planar subdivision on X
CREATE OR REPLACE FUNCTION val_pla_sub_X
RETURN VARCHAR IS

	 p1_columns 	  VARCHAR(500);
	 p2_columns 	  VARCHAR(500);
	 p_contains_error BOOLEAN;
	 
BEGIN
	 
	 -- 1. ((Pi touch Pj) or (Pi disjoint Pj)) = T for all i, j such as i != j	 
	 FOR p IN (SELECT ps1.rowid as rowid1, ps2.rowid as rowid2
  	 	   	      FROM X ps1, X ps2
                  WHERE ps1.rowid != ps2.rowid AND
                        SDO_RELATE(ps1.geom, ps2.geom, 'MASK=TOUCH') != 'TRUE' AND -- not touch and not disjoint
						SDO_RELATE(ps1.geom, ps2.geom, 'MASK=ANYINTERACT') = 'TRUE') LOOP

 	 	SELECT ' idBairro = '||idBairro INTO p1_columns
 	 	   FROM X
 	 	   WHERE rowid = p.rowid1;
 	 	
 	 	SELECT ' idBairro = '||idBairro INTO p2_columns
 	 	   FROM X
 	 	   WHERE rowid = p.rowid2;

	    INSERT INTO spatial_error (type, error) 
           VALUES ('Planar Subdivision Error', 'Spatial relation between X'||p1_columns||' and'||p2_columns||' is not touch or disjoint');
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
-- Validate the isoline on ContourLines
CREATE OR REPLACE FUNCTION val_isoline_Con
RETURN VARCHAR IS

	p1_columns 		 VARCHAR(500);
	p2_columns 		 VARCHAR(500);
	p_contains_error BOOLEAN;
 
BEGIN

	-- 1. ((Pi touch Pj) or (Pi disjoint Pj)) = T for all i, j such as i != j	 
	FOR p IN (SELECT iso1.rowid as rowid1, iso2.rowid as rowid2
				FROM ContourLines iso1, ContourLines iso2
				WHERE iso1.rowid != iso2.rowid AND
						SDO_RELATE(iso1.geom, iso2.geom, 'MASK=TOUCH') != 'TRUE' AND -- not touch and not disjoint
						SDO_RELATE(iso1.geom, iso2.geom, 'MASK=ANYINTERACT') = 'TRUE') LOOP
	 	
		SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO p1_columns
		FROM ContourLines
		WHERE rowid = p.rowid1;

		SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO p2_columns
		FROM ContourLines
		WHERE rowid = p.rowid2;

		INSERT INTO spatial_error (type, error)
			VALUES ('Isoline Error', 'Spatial relation between ContourLines '||p1_columns||' and '||p2_columns||' is not touch or disjoint');
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
			VALUES ('Isoline Error', 'No data found');
	COMMIT;
	RETURN 'Not valid! See table Spatial_Error for more details.';
END;
/
CREATE OR REPLACE FUNCTION join_geometry(part_geometry MDSYS.SDO_GEOMETRY, old_geometry MDSYS.SDO_GEOMETRY)
RETURN MDSYS.SDO_GEOMETRY IS
	 
	 new_geometry MDSYS.SDO_GEOMETRY;  

BEGIN
	 
	 SELECT SDO_GEOM.sdo_union(old_geometry, 
	 	MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', -180, 180, 0.5),MDSYS.SDO_DIM_ELEMENT('Y', -90, 90, 0.5)),
		part_geometry, 
		MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', -180, 180, 0.5),MDSYS.SDO_DIM_ELEMENT('Y', -90, 90, 0.5))) 
	 INTO new_geometry
	 FROM dual;
	 
	 RETURN new_geometry;

END;
/
-- Validate the spatial aggregation between the whole ContourLines and the part X
CREATE OR REPLACE FUNCTION val_spa_agr_Con_X
RETURN VARCHAR IS

	 geom_w      			MDSYS.SDO_GEOMETRY;
	 geom_join      		MDSYS.SDO_GEOMETRY;
	 count_parts            NUMBER;
	 count_parts_validation NUMBER;
	 p_columns				VARCHAR(500);
	 w_columns				VARCHAR(500);
	 p_contains_error	   	BOOLEAN;
	 
BEGIN
	 
	 FOR r IN (SELECT w.rowid as w_rowid, p.rowid as p_rowid, p.geom as p_geom
	 	   	      FROM ContourLines w, X p
			      WHERE SDO_RELATE(w.geom, p.geom, 'MASK=CONTAINS+COVERS+OVERLAPBDYINTERSECT') = 'TRUE') LOOP
	 	 
	 	 INSERT INTO sa_aux (w_rowid, p_rowid, p_geom) 
		    VALUES (r.w_rowid, r.p_rowid, r.p_geom);
		  
	 END LOOP;
	 COMMIT;
	 
	 SELECT count(*) 
	    INTO count_parts 
		FROM X;
	 SELECT count(*) 
	 	INTO count_parts_validation 
		FROM sa_aux;
		
	 IF (count_parts != count_parts_validation) THEN
	 	
	 	INSERT INTO spatial_error (type, error)
		   VALUES ('Spatial Aggregation Error', 'Some parts are not related to any whole');
	    p_contains_error := TRUE;
	    COMMIT;
	 END IF;
	 
	 -- 1. Pi intersection W = Pi, for all i such as 0 <= i <= n
	 FOR w IN (SELECT distinct w_rowid FROM sa_aux) LOOP
	 
	 	 SELECT geom INTO geom_w 
		 	FROM ContourLines 
			WHERE rowid = w.w_rowid;
	 	 
	 	 FOR p IN (SELECT sa.p_rowid
		  	 	       FROM sa_aux sa
					   WHERE sa.w_rowid = w.w_rowid AND
					         SDO_RELATE(sa.p_geom, SDO_GEOM.SDO_INTERSECTION(geom_w, sa.p_geom, 0.5), 'MASK=EQUAL') != 'TRUE') LOOP
	 	 	
	 	 	SELECT ' idBairro = '||idBairro INTO p_columns
	 	 	FROM X
	 	 	WHERE rowid = p.p_rowid;
	 	 	
	 	 	SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO w_columns
	 	 	FROM ContourLines
	 	 	WHERE rowid = w.w_rowid;
	 	 	 
	 	 	INSERT INTO spatial_error (type, error)
		       VALUES ('Spatial Aggregation Error', 'X'||p_columns||' intersection ContourLines'||w_columns|| ' is not equal to part');
			p_contains_error := TRUE;
			COMMIT;
			 
		 END LOOP;
	 END LOOP;
	 
	 -- 3. ((Pi touch Pj) or (Pi disjoint Pj)) = T for all i, j such as i != j
	 FOR w IN (SELECT distinct w_rowid FROM sa_aux) LOOP
	 
	 	 SELECT geom INTO geom_w 
		 	FROM ContourLines 
			WHERE rowid = w.w_rowid;
	 	 
	 	 FOR p IN (SELECT sa1.p_rowid as p_rowid1, sa2.p_rowid as p_rowid2
		  	 	       FROM sa_aux sa1, sa_aux sa2
					   WHERE sa1.w_rowid = w.w_rowid AND sa2.w_rowid = w.w_rowid AND sa1.p_rowid != sa2.p_rowid AND
					         SDO_RELATE(sa1.p_geom, sa2.p_geom, 'MASK=TOUCH') != 'TRUE' AND -- not touch and not disjoint
							 SDO_RELATE(sa1.p_geom, sa2.p_geom, 'MASK=ANYINTERACT') = 'TRUE') LOOP
	 	 	
	 	 	SELECT ' idBairro = '||idBairro INTO p_columns
	 	 	FROM X
	 	 	WHERE rowid = p.p_rowid1;
	 	 	
	 	 	SELECT ' idBairro = '||idBairro INTO w_columns
	 	 	FROM X
	 	 	WHERE rowid = p.p_rowid2;
	 	 	
	 	 	INSERT INTO spatial_error (type, error)
		       VALUES ('Spatial Aggregation Error', 'Spatial relation between parts X'||p_columns||' and'||w_columns||' is not touch or disjoint');
			p_contains_error := TRUE;
			COMMIT;
			 
		 END LOOP;
	 END LOOP;
	 
	 -- 2. (W intersection all P) = W
	 FOR w IN (SELECT distinct w_rowid FROM sa_aux) LOOP
	 	 
	 	 geom_join := NULL;
	 	 
	 	 FOR p IN (SELECT sa.p_rowid, sa.p_geom
		  	 	      FROM sa_aux sa
					  WHERE sa.w_rowid = w.w_rowid) LOOP
					   
	 	 	 geom_join := join_geometry(p.p_geom, geom_join);
			 
		 END LOOP;

	 	 FOR ww IN (SELECT * 
		 	   	       FROM ContourLines 
					   WHERE rowid = w.w_rowid AND
					  		 SDO_RELATE(geom, SDO_GEOM.SDO_INTERSECTION(geom, geom_join, 0.5), 'MASK=EQUAL') != 'TRUE') LOOP
	 	 	
			SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO w_columns
	 	 	FROM ContourLines
	 	 	WHERE rowid = w.w_rowid;
		    
	 	 	INSERT INTO spatial_error (type, error)
		       VALUES ('Spatial Aggregation Error', 'ContourLines'||w_columns||' intersection all its parts is not equal to whole');
			p_contains_error := TRUE;
			COMMIT;
		 
		 END LOOP;
	 END LOOP;
	 
	 DELETE FROM sa_aux;
	 COMMIT;
	 
	 IF (p_contains_error = TRUE) THEN
	    RETURN 'Not valid! See table Spatial_Error for more details.';
     ELSE
 	    RETURN 'Valid! No errors were found.';
     END IF;
	 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
	 	INSERT INTO spatial_error (type, error)
		   VALUES ('Spatial Aggregation Error', 'No data found');
		COMMIT;
		RETURN 'Not valid! See table Spatial_Error for more details.';
END;
/
