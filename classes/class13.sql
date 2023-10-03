#CLASS13

#Add a new customer
#To store 1
#For address use an existing address. The one that has the biggest address_id in 'United States'
;
INSERT INTO
    customer (store_id,first_name,last_name,email,address_id,active)
SELECT 1,'Lorenzo','Galaverna','lorenzojalaverna@gmail.com', MAX(a.address_id),1
FROM address a
    INNER JOIN city ci USING (city_id)
    INNER JOIN country co USING(country_id)
WHERE (
        co.country = "United States"
    );
SELECT * FROM customer WHERE last_name = "Galaverna";

#Add a rental
#Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
#Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
#Select any staff_id from Store 2.
;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (CURRENT_DATE(), (SELECT I.inventory_id 
                         FROM inventory I INNER JOIN film F USING(film_id)
                         WHERE F.title = 'ACADEMY DINOSAUR'
                         LIMIT 1), 600, CURRENT_DATE(), (SELECT MAX(staff_id)
                                                       FROM staff
                                                       WHERE store_id = 2));
SELECT * FROM rental WHERE customer_id = 600;

#Update film year based on the rating
#For example if rating is 'G' release date will be '2001'
#You can choose the mapping between rating and year.
#Write as many statements are needed.
;
UPDATE film SET release_year = 2001 WHERE rating ='G';
UPDATE film SET release_year = 2002 WHERE rating = 'PG';
UPDATE film SET release_year = 2003 WHERE rating ='PG-13';
UPDATE film SET release_year = 2004 WHERE rating ='NC-17';
UPDATE film SET release_year = 2005 WHERE rating = 'R';
SELECT * FROM film WHERE rating = 'PG';
SELECT DISTINCT rating, release_year
FROM film;

#Return a film
#Write the necessary statements and queries for the following steps.
#Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
#Use the id to return the film.
;
SELECT f.film_id
FROM film f
    INNER JOIN inventory i USING(film_id)
    INNER JOIN rental r USING(inventory_id)
WHERE r.return_date IS NULL
ORDER BY r.rental_date DESC
LIMIT 1;

#Try to delete a film
#Check what happens, describe what to do.
#Write all the necessary delete statements to entirely remove the film from the DB.
;

DELETE FROM film WHERE film_id='4';

#Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE)
-- No se puede borrar la pelicula ya que ya que tiene claves foraneas que dependen del id de la clave primaria de esta pelicula.
-- La solucion para esto es borrar primero(en order de hijo a padre) las row a las que la pelicula esta relacionada.
-- Tambien se puede desactivar FOREIGN KEY CHECK y luego volver a activarlo, pero esto no es recomendable
;

DELETE FROM rental
WHERE inventory_id IN (
        SELECT inventory_id
        FROM inventory
        WHERE film_id = 3
    );
DELETE FROM inventory WHERE film_id = 3;
DELETE FROM film_actor WHERE film_id = 3;
DELETE FROM film_category WHERE film_id = 3;
DELETE FROM film WHERE film_id = 3;

#Rent a film
#Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
#Add a rental entry
#Add a payment entry
#Use sub-queries for everything, except for the inventory id that can be used directly in the queries.
; 
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (CURRENT_DATE(), (SELECT I.inventory_id
                         FROM inventory AS I
                         WHERE NOT EXISTS(SELECT *
                                          FROM rental R
                                          WHERE R.inventory_id = I.inventory_id
                                            AND R.return_date = null)
                         LIMIT 1), 1, CURRENT_DATE(), 1);
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, (SELECT LAST_INSERT_ID()), 9.7, CURRENT_DATE())
