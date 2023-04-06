SELECT title, special_features FROM film WHERE rating = "PG-13";
SELECT title, length FROM film;
SELECT title, rental_rate, replacement_cost FROM film WHERE replacement_cost >= 20.00 and replacement_cost <= 24.00;
SELECT title, c.name ,rating, special_features FROM film 
INNER JOIN film_category fc ON film.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE special_features = "Behind the Scenes";
SELECT a.first_name, a.last_name FROM film 
INNER JOIN film_actor fa ON film.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
WHERE title = "ZOOLANDER FICTION";
SELECT a.address, c.city, co.country FROM store 
INNER JOIN address a ON store.address_id = a.address_id
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id
WHERE store_id = 1;
SELECT f1.title, f2.title, f1.rating, f2.rating FROM film f1, film f2 
WHERE f1.rating = f2.rating and f1.film_id != f2.film_id;

SELECT title, st.first_name, st.last_name from film
INNER JOIN inventory i ON film.film_id = i.film_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN staff st ON s.manager_staff_id = st.staff_id
WHERE i.store_id = 2;