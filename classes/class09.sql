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