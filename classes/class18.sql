#CLASS18;
#1 - Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.
DELIMITER //

CREATE FUNCTION get_copies_amount(f_name VARCHAR(255), st_id INT) RETURNS INT DETERMINISTIC
BEGIN 
	DECLARE cant INT;
	SELECT
	    COUNT(i.inventory_id) INTO cant
	FROM film f
	    INNER JOIN inventory i USING(film_id)
	    INNER JOIN store st USING(store_id)
	WHERE
	    f.title = f_name AND st.store_id = st_id;
	RETURN (cant);
END // 

DELIMITER ;
SELECT get_copies_amount('BAKED CLEOPATRA',2);
#2 -Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. 
#You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.
DELIMITER //

DROP PROCEDURE IF EXISTS get_customer_by_country //

CREATE PROCEDURE get_customer_by_country(IN country_name VARCHAR(250), INOUT list VARCHAR(500)) 
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
DELIMITER ;
set @list = '';
CALL get_customer_by_country('Argentina',@list);
SELECT @list;

#3 - Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.
SHOW CREATE FUNCTION inventory_in_stock;
                                                                        ---CODE---
/*
CREATE FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;


    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
                                                                            -------
*/
-- Explation:
--1 The function begins by declaring two local variables: v_rentals and v_out. These variables will be used to store counts of rental records.
--2 It then performs the following SQL operations:
#a. It counts the number of rental records associated with the provided inventory_id and stores the result in the v_rentals variable.
#b. It checks if v_rentals is equal to 0. If there are no rental records for the inventory item, it means the item is available for rent, so it returns TRUE.
#c. If there are rental records (v_rentals > 0), it counts the number of rental records where the return_date is NULL, which indicates items that are currently rented out but not yet returned. This count is stored in the v_out variable.
#d. If v_out is greater than 0, it means there are items out on rental and not yet returned, so it returns FALSE. Otherwise, it returns TRUE.

-- Examples of usage
SELECT inventory_in_stock(3); -- This one throws 1 (TRUE, because MySQL detects boolean as 0 for FALSE and 1 for TRUE)

SELECT inventory_in_stock(1551); -- This one throws 0 (FALSE, because MySQL detects boolean as 0 for FALSE and 1 for TRUE)

SHOW CREATE PROCEDURE film_in_stock;
                                                                            ---CODE---
/*
CREATE PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);
     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
*/
                                                                            -------
-- Explanation:
--1 The procedure begins by declaring its input parameters (p_film_id and p_store_id) and an output parameter (p_film_count), which will be used to store the count of film copies in stock.
--2 In the body of the procedure, two SQL queries are executed:
#a. The first query selects inventory_id from the inventory table where the following conditions are met:
-- film_id is equal to p_film_id.
-- store_id is equal to p_store_id.
-- The inventory_in_stock function returns TRUE for that inventory_id.
#b. The second query counts the number of records that meet the same conditions as the first query. The result of this count is stored in the output parameter p_film_count.

CALL film_in_stock(2,2,@a);
SELECT @a;