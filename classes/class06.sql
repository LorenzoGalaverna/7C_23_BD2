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
SELECT a1.first_name, a1.last_name FROM actor a1
WHERE EXISTS (SELECT * FROM film f1 JOIN film_actor fa on f1.film_id = fa.film_id
WHERE f1.film_id = fa.film_id AND a1.actor_id = fa.actor_id AND (f1.title = 'BETRAYED REAR' AND  f1.title != 'CATCH AMISTAD'));
#7
SELECT a1.first_name, a1.last_name FROM actor a1
WHERE EXISTS (SELECT * FROM film f1 JOIN film_actor fa on f1.film_id = fa.film_id
WHERE f1.film_id = fa.film_id AND a1.actor_id = fa.actor_id AND (f1.title = 'BETRAYED REAR' AND f1.title = 'CATCH AMISTAD'));
#8
SELECT a1.first_name, a1.last_name FROM actor a1
WHERE NOT EXISTS (SELECT * FROM film f1 JOIN film_actor fa on f1.film_id = fa.film_id
WHERE f1.film_id = fa.film_id AND a1.actor_id = fa.actor_id AND (f1.title = 'BETRAYED REAR' OR f1.title = 'CATCH AMISTAD'));
