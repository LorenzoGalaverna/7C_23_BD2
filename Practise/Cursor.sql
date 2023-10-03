CREATE PROCEDURE get_customer_by_country(IN country_name VARCHAR(250), OUT list VARCHAR(500)) 
BEGIN 
	DECLARE finished INT DEFAULT 0;
	DECLARE f_name VARCHAR(250); 
	DECLARE l_name VARCHAR(250);
	DECLARE country VARCHAR(250);
    DECLARE cursorList CURSOR FOR
	
    SELECT
	    co.country,c.first_name,c.last_name
	FROM customer c
	    INNER JOIN address USING(address_id)
	    INNER JOIN city USING(city_id)
	    INNER JOIN country co USING(country_id);
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN cursorList;
    set list = '';

	WHILE finished = 0 
    DO
		FETCH cursorList INTO country, f_name, l_name;

		IF country = country_name THEN
			SET list = CONCAT(f_name,' ', l_name, ' ; ', list);
		END IF;

	END WHILE;
	CLOSE cursorList;
END //

CREATE PROCEDURE get_customer_by_country_l(IN country_name VARCHAR(250), OUT list VARCHAR(500)) 
BEGIN 
	DECLARE finished INT DEFAULT 0;
	DECLARE f_name VARCHAR(250); 
	DECLARE l_name VARCHAR(250);
	DECLARE country VARCHAR(250);
    DECLARE cursorList CURSOR FOR
    SELECT
	    co.country,c.first_name,c.last_name
	FROM customer c
	    INNER JOIN address USING(address_id)
	    INNER JOIN city USING(city_id)
	    INNER JOIN country co USING(country_id);
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    set list = '';

	OPEN cursorList;

	looplabel: LOOP
		FETCH cursorList INTO country, f_name, l_name;

		IF country = country_name THEN
			SET list = CONCAT(f_name,' ', l_name, ' ; ', list);
		END IF;

        IF finished = 1 THEN
			LEAVE looplabel;
		END IF;

	END LOOP looplabel;
	CLOSE cursorList;

END //

CALL get_customer_by_country('Argentina',@list);
SELECT @list;

Drop Procedure get_customer_by_country_l;