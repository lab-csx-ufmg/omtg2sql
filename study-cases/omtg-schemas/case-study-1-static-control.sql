-- Validate the planar subdivision on RegionBoundary
CREATE OR REPLACE FUNCTION val_pla_sub_Reg
RETURN VARCHAR IS

	 p1_columns 	  VARCHAR(500);
	 p2_columns 	  VARCHAR(500);
	 p_contains_error BOOLEAN;
	 
BEGIN
	 
	 -- 1. ((Pi touch Pj) or (Pi disjoint Pj)) = T for all i, j such as i != j	 
	 FOR p IN (SELECT ps1.rowid as rowid1, ps2.rowid as rowid2
  	 	   	      FROM RegionBoundary ps1, RegionBoundary ps2
                  WHERE ps1.rowid != ps2.rowid AND
                        SDO_RELATE(ps1.geom, ps2.geom, 'MASK=TOUCH') != 'TRUE' AND -- not touch and not disjoint
						SDO_RELATE(ps1.geom, ps2.geom, 'MASK=ANYINTERACT') = 'TRUE') LOOP

 	 	SELECT ' Region_code = '||Region_code INTO p1_columns
 	 	   FROM RegionBoundary
 	 	   WHERE rowid = p.rowid1;
 	 	
 	 	SELECT ' Region_code = '||Region_code INTO p2_columns
 	 	   FROM RegionBoundary
 	 	   WHERE rowid = p.rowid2;

	    INSERT INTO spatial_error (type, error) 
           VALUES ('Planar Subdivision Error', 'Spatial relation between RegionBoundary'||p1_columns||' and'||p2_columns||' is not touch or disjoint');
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
-- Validate the spatial aggregation between the whole RegionBoundary and the part Neighborhood
CREATE OR REPLACE FUNCTION val_spa_agr_Reg_Nei
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
	 	   	      FROM RegionBoundary w, Neighborhood p
			      WHERE SDO_RELATE(w.geom, p.geom, 'MASK=CONTAINS+COVERS+OVERLAPBDYINTERSECT') = 'TRUE') LOOP
	 	 
	 	 INSERT INTO sa_aux (w_rowid, p_rowid, p_geom) 
		    VALUES (r.w_rowid, r.p_rowid, r.p_geom);
		  
	 END LOOP;
	 COMMIT;
	 
	 SELECT count(*) 
	    INTO count_parts 
		FROM Neighborhood;
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
		 	FROM RegionBoundary 
			WHERE rowid = w.w_rowid;
	 	 
	 	 FOR p IN (SELECT sa.p_rowid
		  	 	       FROM sa_aux sa
					   WHERE sa.w_rowid = w.w_rowid AND
					         SDO_RELATE(sa.p_geom, SDO_GEOM.SDO_INTERSECTION(geom_w, sa.p_geom, 0.5), 'MASK=EQUAL') != 'TRUE') LOOP
	 	 	
	 	 	SELECT ' code = '||code INTO p_columns
	 	 	FROM Neighborhood
	 	 	WHERE rowid = p.p_rowid;
	 	 	
	 	 	SELECT ' Region_code = '||Region_code INTO w_columns
	 	 	FROM RegionBoundary
	 	 	WHERE rowid = w.w_rowid;
	 	 	 
	 	 	INSERT INTO spatial_error (type, error)
		       VALUES ('Spatial Aggregation Error', 'Neighborhood'||p_columns||' intersection RegionBoundary'||w_columns|| ' is not equal to part');
			p_contains_error := TRUE;
			COMMIT;
			 
		 END LOOP;
	 END LOOP;
	 
	 -- 3. ((Pi touch Pj) or (Pi disjoint Pj)) = T for all i, j such as i != j
	 FOR w IN (SELECT distinct w_rowid FROM sa_aux) LOOP
	 
	 	 SELECT geom INTO geom_w 
		 	FROM RegionBoundary 
			WHERE rowid = w.w_rowid;
	 	 
	 	 FOR p IN (SELECT sa1.p_rowid as p_rowid1, sa2.p_rowid as p_rowid2
		  	 	       FROM sa_aux sa1, sa_aux sa2
					   WHERE sa1.w_rowid = w.w_rowid AND sa2.w_rowid = w.w_rowid AND sa1.p_rowid != sa2.p_rowid AND
					         SDO_RELATE(sa1.p_geom, sa2.p_geom, 'MASK=TOUCH') != 'TRUE' AND -- not touch and not disjoint
							 SDO_RELATE(sa1.p_geom, sa2.p_geom, 'MASK=ANYINTERACT') = 'TRUE') LOOP
	 	 	
	 	 	SELECT ' code = '||code INTO p_columns
	 	 	FROM Neighborhood
	 	 	WHERE rowid = p.p_rowid1;
	 	 	
	 	 	SELECT ' code = '||code INTO w_columns
	 	 	FROM Neighborhood
	 	 	WHERE rowid = p.p_rowid2;
	 	 	
	 	 	INSERT INTO spatial_error (type, error)
		       VALUES ('Spatial Aggregation Error', 'Spatial relation between parts Neighborhood'||p_columns||' and'||w_columns||' is not touch or disjoint');
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
		 	   	       FROM RegionBoundary 
					   WHERE rowid = w.w_rowid AND
					  		 SDO_RELATE(geom, SDO_GEOM.SDO_INTERSECTION(geom, geom_join, 0.5), 'MASK=EQUAL') != 'TRUE') LOOP
	 	 	
			SELECT ' Region_code = '||Region_code INTO w_columns
	 	 	FROM RegionBoundary
	 	 	WHERE rowid = w.w_rowid;
		    
	 	 	INSERT INTO spatial_error (type, error)
		       VALUES ('Spatial Aggregation Error', 'RegionBoundary'||w_columns||' intersection all its parts is not equal to whole');
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
-- Validate the network between the StreetSegment and StreetCrossing
CREATE OR REPLACE FUNCTION val_network_Str_Str
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
	FOR reg IN (SELECT rowid, geom FROM StreetSegment) LOOP
	 
	 	p_geom_initial_vertex := get_point(reg.geom);
	 	p_geom_final_vertex := get_point(reg.geom, SDO_UTIL.GETNUMVERTICES(reg.geom));
	 	
	 	BEGIN

	 		SELECT rowid INTO p_rowid_initial_vertex
			   FROM StreetCrossing
	 		   WHERE MDSYS.SDO_EQUAL(geom, p_geom_initial_vertex) = 'TRUE';

	 	EXCEPTION 
		    
			WHEN NO_DATA_FOUND THEN
				 SELECT ' id = '||id INTO p_keys
	 	 		 	FROM StreetSegment
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Initial vertex of arc StreetSegment'||p_keys||' is not related to any node');
				 p_contains_error := TRUE;
				 COMMIT;
		    
			WHEN TOO_MANY_ROWS THEN
				 SELECT ' id = '||id INTO p_keys
	 	 		 	FROM StreetSegment
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Initial vertex of arc StreetSegment'||p_keys||' is related to many nodes');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	 	
	 	BEGIN

	 		SELECT rowid INTO p_rowid_final_vertex
			   FROM StreetCrossing
	 		   WHERE MDSYS.SDO_EQUAL(geom, p_geom_final_vertex) = 'TRUE';

	 	EXCEPTION 
		    
			WHEN NO_DATA_FOUND THEN
				 SELECT ' id = '||id INTO p_keys
	 	 		 	FROM StreetSegment
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Final vertex of arc StreetSegment'||p_keys||' is not related to any node');
				 p_contains_error := TRUE;
				 COMMIT;
		    
			WHEN TOO_MANY_ROWS THEN
				 SELECT ' id = '||id INTO p_keys
	 	 		 	FROM StreetSegment
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Final vertex of arc StreetSegment'||p_keys||' is related to many nodes');
				 p_contains_error := TRUE;
				 COMMIT;
	 	END;
	END LOOP;

	-- 2.
	FOR reg IN (SELECT rowid FROM StreetCrossing) LOOP
	 	
	 	BEGIN
	 	
	 		SELECT a.rowid INTO p_rowid_point
			   FROM StreetSegment a, StreetCrossing n
	 		   WHERE (MDSYS.SDO_EQUAL(n.geom, get_point(a.geom)) = 'TRUE' OR 
			   		 MDSYS.SDO_EQUAL(n.geom, get_point(a.geom, SDO_UTIL.GETNUMVERTICES(a.geom))) = 'TRUE') AND 
			   		 reg.rowid = n.rowid AND rownum <= 1;
	 		
	 	EXCEPTION
	 	
		    WHEN NO_DATA_FOUND THEN
				 SELECT ' id = '||id INTO p_keys
	 	 		 	FROM StreetCrossing
	 	 		 	WHERE rowid = reg.rowid;
	 	 		 	
	 	 		 INSERT INTO spatial_error (type, error)
				 		VALUES ('Arc-Node Network Error', 'Node StreetCrossing'||p_keys||' is not related to any vertex');
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
