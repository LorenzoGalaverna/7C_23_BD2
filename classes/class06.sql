-- Active: 1666884782294@@127.0.0.1@3306@sakila
#CLASS04
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

#-----------------------------------------------------------------------------------#
#CLASS06
;
#1
SELECT a1.first_name, a1.last_name FROM actor a1
WHERE EXISTS (SELECT * FROM actor a2 WHERE a1.last_name = a2.last_name AND a1.actor_id != a2.actor_id)
ORDER BY a1.last_name;
#2
SELECT a1.first_name, a1.last_name FROM actor a1
WHERE NOT EXISTS (SELECT * FROM film_actor fm WHERE a1.actor_id = fm.actor_id);
#3
SELECT c1.first_name, c1.last_name FROM customer c1
WHERE (SELECT count(*) FROM rental r WHERE c1.customer_id = r.customer_id)=1;
#4
SELECT c1.first_name, c1.last_name FROM customer c1
WHERE (SELECT count(*) FROM rental r WHERE c1.customer_id = r.customer_id)>1;
#5
SELECT a1.first_name, a1.last_name FROM actor a1
WHERE EXISTS (SELECT * FROM film f1 JOIN film_actor fa on f1.film_id = fa.film_id
WHERE f1.film_id = fa.film_id AND a1.actor_id = fa.actor_id AND (f1.title = 'BETRAYED REAR' or f1.title = 'CATCH AMISTAD'));
#6
SELECT actor_id, first_name, last_name
FROM actor AS A
WHERE EXISTS(SELECT title FROM film AS F INNER JOIN film_actor FA ON F.film_id = FA.film_id
             WHERE F.film_id = FA.film_id AND A.actor_id = FA.actor_id AND F.title = 'BETRAYED REAR')
AND NOT EXISTS (SELECT title FROM film AS F INNER JOIN film_actor FA ON F.film_id = FA.film_id
             WHERE F.film_id = FA.film_id AND A.actor_id = FA.actor_id AND F.title = 'CATCH AMISTAD');
#7
SELECT actor_id, first_name, last_name
FROM actor AS A
WHERE EXISTS(SELECT title FROM film AS F INNER JOIN film_actor FA ON F.film_id = FA.film_id
             WHERE F.film_id = FA.film_id AND A.actor_id = FA.actor_id AND F.title = 'BETRAYED REAR')
AND EXISTS (SELECT title FROM film AS F INNER JOIN film_actor FA ON F.film_id = FA.film_id
             WHERE F.film_id = FA.film_id AND A.actor_id = FA.actor_id AND F.title = 'CATCH AMISTAD');
#8
SELECT a1.first_name, a1.last_name FROM actor a1
WHERE NOT EXISTS (SELECT * FROM film f1 JOIN film_actor fa on f1.film_id = fa.film_id
WHERE f1.film_id = fa.film_id AND a1.actor_id = fa.actor_id AND (f1.title = 'BETRAYED REAR' OR f1.title = 'CATCH AMISTAD'));

#---------------------------------------------------------------------------#
#CLASS07
;
#1
SELECT title, rating, length
FROM film
WHERE length = (SELECT min(length) FROM film);

#2
SELECT title, length
FROM film
WHERE length < ALL (SELECT min(length) FROM film);

#3
SELECT c.first_name,c.last_name, a.address, (SELECT min(amount) FROM payment p WHERE c.customer_id = p.customer_id ) AS Paga_minima
FROM customer c
JOIN address a ON c.address_id = a.address_id
ORDER BY c.first_name;

#4
SELECT c.first_name,c.last_name, a.address,(SELECT min(amount) FROM payment p WHERE c.customer_id = p.customer_id ) AS Paga_minima, 
(SELECT max(amount) FROM payment p WHERE c.customer_id = p.customer_id ) AS Paga_maxima
FROM customer c
JOIN address a ON c.address_id = a.address_id
ORDER BY c.first_name;