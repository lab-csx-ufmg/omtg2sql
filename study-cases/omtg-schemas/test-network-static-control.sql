CREATE OR REPLACE FUNCTION get_point(geom SDO_GEOMETRY, point_number NUMBER DEFAULT 1) 
RETURN SDO_GEOMETRY IS

	g  MDSYS.SDO_GEOMETRY;
	d  NUMBER;
	p  NUMBER;
	px NUMBER;
	py NUMBER;

BEGIN
	-- Get the number of dimensions from the gtype
	d := SUBSTR (geom.SDO_GTYPE, 1, 1);
	-- Verify that the point exists
	IF point_number < 1 OR point_number > geom.SDO_ORDINATES.COUNT()/d THEN
		RETURN NULL;
	END IF;
	-- Get index in ordinates array
	p := (point_number-1) * d + 1;
	-- Extract the X and Y coordinates of the desired point
	px := geom.SDO_ORDINATES(p);
	py := geom.SDO_ORDINATES(p+1);
	-- Construct and return the point
	RETURN MDSYS.SDO_GEOMETRY (2001,geom.SDO_SRID,SDO_POINT_TYPE (px,py,NULL),NULL,NULL);
END;
/
-- Validate the network between the trecho2 and no2
CREATE OR REPLACE FUNCTION val_network_tre_no2
RETURN VARCHAR IS

	p_geom_initial_vertex  MDSYS.SDO_GEOMETRY;
	p_geom_final_vertex    MDSYS.SDO_GEOMETRY;
	p_geom_vertex    	   MDSYS.SDO_GEOMETRY;
	p_rowid_initial_vertex rowid;
	p_rowid_final_vertex   rowid;
	p_rowid_point		   rowid;
	p_keys			   	   VARCHAR(500);
	p_contains_error	   BOOLEAN;

BEGIN
	 
	-- 1.
	FOR reg IN (SELECT rowid, geom FROM trecho2) LOOP
	 
	 	p_geom_initial_vertex := get_point(reg.geom);
	 	p_geom_final_vertex := get_point(reg.geom, SDO_UTIL.GETNUMVERTICES(reg.geom));
	 	
	 	BEGIN

	 		SELECT rowid INTO p_rowid_initial_vertex
			   FROM no2
	 		   WHERE MDSYS.SDO_EQUAL(geom, p_geom_initial_vertex) = 'TRUE';

	 	EXCEPTION 
		    
			WHEN NO_DATA_FOUND THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho2
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Initial vertex of arc trecho2'||p_keys||' is not related to any node');
				 p_contains_error := TRUE;
				 COMMIT;
		    
			WHEN TOO_MANY_ROWS THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho2
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Initial vertex of arc trecho2'||p_keys||' is related to many nodes');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	 	
	 	BEGIN

	 		SELECT rowid INTO p_rowid_final_vertex
			   FROM no2
	 		   WHERE MDSYS.SDO_EQUAL(geom, p_geom_final_vertex) = 'TRUE';

	 	EXCEPTION 
		    
			WHEN NO_DATA_FOUND THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho2
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Final vertex of arc trecho2'||p_keys||' is not related to any node');
				 p_contains_error := TRUE;
				 COMMIT;
		    
			WHEN TOO_MANY_ROWS THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho2
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Final vertex of arc trecho2'||p_keys||' is related to many nodes');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	END LOOP;

	-- 2.
	FOR reg IN (SELECT rowid FROM no2) LOOP
	 	
	 	BEGIN
	 	
	 		SELECT a.rowid INTO p_rowid_point
			   FROM trecho2 a, no2 n
	 		   WHERE (MDSYS.SDO_EQUAL(n.geom, get_point(a.geom)) = 'TRUE' OR 
			   		 MDSYS.SDO_EQUAL(n.geom, get_point(a.geom, SDO_UTIL.GETNUMVERTICES(a.geom))) = 'TRUE') AND 
			   		 reg.rowid = n.rowid AND rownum <= 1;
	 		
	 	EXCEPTION
	 	
		    WHEN NO_DATA_FOUND THEN
				 SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO p_keys
	 	 		 	FROM no2
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Node no2'||p_keys||' is not related to any vertex');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	END LOOP;
	
	IF (p_contains_error = TRUE) THEN
	   RETURN 'Not valid! See table Spatial_Error for more details.';
    ELSE
 	   RETURN 'Valid! No errors were found.';
    END IF;
	
END;
/
-- Validate the network between the trecho and no
CREATE OR REPLACE FUNCTION val_network_tre_no
RETURN VARCHAR IS

	p_geom_initial_vertex  MDSYS.SDO_GEOMETRY;
	p_geom_final_vertex    MDSYS.SDO_GEOMETRY;
	p_geom_vertex    	   MDSYS.SDO_GEOMETRY;
	p_rowid_initial_vertex rowid;
	p_rowid_final_vertex   rowid;
	p_rowid_point		   rowid;
	p_keys			   	   VARCHAR(500);
	p_contains_error	   BOOLEAN;

BEGIN
	 
	-- 1.
	FOR reg IN (SELECT rowid, geom FROM trecho) LOOP
	 
	 	p_geom_initial_vertex := get_point(reg.geom);
	 	p_geom_final_vertex := get_point(reg.geom, SDO_UTIL.GETNUMVERTICES(reg.geom));
	 	
	 	BEGIN

	 		SELECT rowid INTO p_rowid_initial_vertex
			   FROM no
	 		   WHERE MDSYS.SDO_EQUAL(geom, p_geom_initial_vertex) = 'TRUE';

	 	EXCEPTION 
		    
			WHEN NO_DATA_FOUND THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Initial vertex of arc trecho'||p_keys||' is not related to any node');
				 p_contains_error := TRUE;
				 COMMIT;
		    
			WHEN TOO_MANY_ROWS THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Initial vertex of arc trecho'||p_keys||' is related to many nodes');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	 	
	 	BEGIN

	 		SELECT rowid INTO p_rowid_final_vertex
			   FROM no
	 		   WHERE MDSYS.SDO_EQUAL(geom, p_geom_final_vertex) = 'TRUE';

	 	EXCEPTION 
		    
			WHEN NO_DATA_FOUND THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Final vertex of arc trecho'||p_keys||' is not related to any node');
				 p_contains_error := TRUE;
				 COMMIT;
		    
			WHEN TOO_MANY_ROWS THEN
				 SELECT ' idBairro = '||idBairro||' codBairro = '||codBairro INTO p_keys
	 	 		 	FROM trecho
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Final vertex of arc trecho'||p_keys||' is related to many nodes');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	END LOOP;

	-- 2.
	FOR reg IN (SELECT rowid FROM no) LOOP
	 	
	 	BEGIN
	 	
	 		SELECT a.rowid INTO p_rowid_point
			   FROM trecho a, no n
	 		   WHERE (MDSYS.SDO_EQUAL(n.geom, get_point(a.geom)) = 'TRUE' OR 
			   		 MDSYS.SDO_EQUAL(n.geom, get_point(a.geom, SDO_UTIL.GETNUMVERTICES(a.geom))) = 'TRUE') AND 
			   		 reg.rowid = n.rowid AND rownum <= 1;
	 		
	 	EXCEPTION
	 	
		    WHEN NO_DATA_FOUND THEN
				 SELECT ' idCidade = '||idCidade||' nomeCidade = '||nomeCidade INTO p_keys
	 	 		 	FROM no
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Node no'||p_keys||' is not related to any vertex');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	END LOOP;
	
	IF (p_contains_error = TRUE) THEN
	   RETURN 'Not valid! See table Spatial_Error for more details.';
    ELSE
 	   RETURN 'Valid! No errors were found.';
    END IF;
	
END;
/
