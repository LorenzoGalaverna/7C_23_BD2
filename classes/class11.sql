DROP DATABASE IF EXISTS sakila;
CREATE DATABASE IF NOT EXISTS sakila;
USE sakila;
'''
CREATE TABLE [table_name]
(
	[primarykey INT AUTO_INCREMENT PRIMARY KEY],
    [field_name data_type],
    [CONSTRAINT [constraint_name] FOREIGN KEY ([column_name]) REFERENCES [table_name] (table_column)]
);

/////////

ALTER TABLE table_name
  ADD CONSTRAINT 
    PRIMARY KEY (name)

////////

ALTER TABLE contacts
  ADD last_name varchar(40) NOT NULL
    AFTER/FIRST contact_id;

///

ALTER TABLE contacts
  MODIFY last_name varchar(50) NULL;

///

ALTER TABLE table_name
  DROP COLUMN column_name;

///

ALTER TABLE contacts
  CHANGE COLUMN contact_type ctype
    varchar(20) NOT NULL;

///

ALTER TABLE inventory ADD 
  CONSTRAINT fk_inventory_products
    FOREIGN KEY (product_name, location)
    REFERENCES products (product_name, location);

///

INSERT INTO FILM (TITLE, DESCRIPCION, RELEASE_YEAR)
VALUES ('The Shawshank Redemption',
        'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
        '1994-09-22'),
       ('The Godfather', 'An organized crime dynasty transfers control from father to son.', '1972-03-24'),
       ('The Dark Knight',
        'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        '2008-07-18'),
       ('Pulp Fiction',
        'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.',
        '1994-05-21'),
       ('Forrest Gump',
        'The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate, and other historical events unfold through the perspective of an Alabama man with an IQ of 75, whose only desire is to be reunited with his childhood sweetheart.',
        '1994-07-06');
///

SELECT customer_id,  
first_name,  
last_name,  
(SELECT MAX(amount)  
FROM payment  
WHERE payment.customer_id = customer.customer_id) AS max_amount  
FROM customer  
ORDER BY max_amount DESC,  
customer_id DESC;  

///

SELECT c.customer_id, first_name, last_name, COUNT(*)
  FROM rental r1, customer c
 WHERE c.customer_id = r1.customer_id
GROUP BY c.customer_id, first_name, last_name
HAVING COUNT(*) = 1

///
LIKE 'J%';

MIN()
MAX()
COUNT()
AVG()
SUM()

///
'''

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
SELECT f.title  FROM film f WHERE f.length = (SELECT MIN(LENGTH) FROM film) 
and not EXISTS (SELECT * FROM film f2 
                where f2.film_id <> f.film_id and f.LENGTH = f2.LENGTH) ;

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

#---------------------------------------------------------------------------#
#CLASS09
;
#1
SELECT co.country as Pais,count(ci.city) as CantidadCiudades 
	from country co 
    join city ci on co.country_id = ci.country_id 
    group by co.country 
    order by co.country;

#2
SELECT co.country as Pais,count(ci.city) as CantidadCiudades 
	from country co
    join city ci on co.country_id = ci.country_id 
	group by co.country
    having count(ci.city) >10
    order by CantidadCiudades DESC;

#3
SELECT c.first_name,c.last_name, a.address,(SELECT COUNT(*) FROM rental r WHERE c.customer_id = r.customer_id) as PelisRentadas,
    (SELECT SUM(p.amount) FROM payment p WHERE c.customer_id = p.customer_id) as DineroGastado FROM customer c
JOIN address a on c.address_id = a.address_id
GROUP BY c.first_name, c.last_name, a.address, c.customer_id
ORDER BY DineroGastado DESC;

#4
SELECT categ.name , AVG(f.length) as PromedioDuracionPeliculas 
	FROM film f JOIN film_category fc ON fc.film_id = f.film_id JOIN category categ ON fc.category_id = categ.category_id
group by categ.name
order by PromedioDuracionPeliculas DESC;

#5
SELECT f.rating, COUNT(p.payment_id) as Ventas
	FROM film f
	JOIN inventory i ON i.film_id = f.film_id
	JOIN rental r ON r.inventory_id = i.inventory_id
	JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY rating
ORDER BY Ventas DESC;

#practica;
select c.first_name, c.last_name
from customer c
inner join rental r on c.customer_id = r.customer_id
where r.return_date = null
;

#2;
select r.rental_id, p.amount
from rental r
inner join payment p on r.rental_id = p.rental_id
where p.amount between 2 and 7;

#3;
select c.first_name, 
(SELECT min(p.amount) FROM payment p WHERE c.customer_id = p.customer_id) as pagominimo, 
(SELECT max(p.amount) FROM payment p WHERE c.customer_id = p.customer_id) as pagomaximo,
(SELECT GROUP_CONCAT(p.amount SEPARATOR ', ') FROM payment p WHERE c.customer_id = p.customer_id)
from customer c;

#4;
select f.title, (SELECT min(f.)) FROM payment p WHERE c.customer_id = p.customer_id) as pagominimo, 

#;
SELECT a.last_name
from actor a 
where exists (SELECT * from film f join film_actor fa on f.film_id = fa.film_id where a.actor_id = fa.actor_id and fa.film_id = f.film_id and (f.title = 'BETRAYED REAR' and 'CATCH AMISTAD'))
and not exists (SELECT * from film f join film_actor fa on f.film_id = fa.film_id where a.actor_id = fa.actor_id and fa.film_id = f.film_id and f.title = 'ACE GOLDFINGER') ;


#;
select f.title, COUNT(fa.actor_id)
from film f inner join film_actor fa on f.film_id=fa.film_id
GROUP BY f.title
having COUNT(fa.actor_id) > 4;

#;
SELECT first_name, last_name
FROM actor a1
WHERE a1.first_name LIKE 'A%'
AND EXISTS(SELECT first_name, last_name
                FROM actor a2
                WHERE a1.first_name = a2.first_name
                AND a1.actor_id <> a2.actor_id);