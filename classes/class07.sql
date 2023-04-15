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
