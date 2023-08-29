#CLASS17;

#1 - Create two or three queries using address table in sakila db:
-- include postal_code in where (try with in/not it operator)
-- eventually join the table with city/country tables.
-- measure execution time.
-- Then create an index for postal_code on address table.
-- measure execution time again and compare with the previous ones.
-- Explain the results;
;   
SELECT a.address, a.address_id, a.postal_code,a.district, a.phone, ci.city, co.country
FROM address a
	INNER JOIN city ci USING(city_id)
	INNER JOIN country co USING(country_id)
WHERE a.postal_code IN(SELECT a2.postal_code
                        FROM address a2
                        WHERE a2.postal_code BETWEEN 10 and 1000);

-- Cost: 8ms

CREATE INDEX postalCode on address(postal_code);

-- Cost: 4ms

drop index postalCode on address;

SELECT *
FROM address 
WHERE postal_code >2000 AND postal_code<6000 AND postal_code % 2 = 1;

-- Cost: 5 ms

CREATE INDEX postalCode on address(postal_code);

-- Cost: 4 ms

drop index postalCode on address;

-- Documentacion: MySQL checks if the indexes exist, then MySQL uses the indexes to select exact physical corresponding rows of the table instead of scanning the whole table.

#2 - Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?

SELECT first_name FROM actor;
SELECT last_name FROM actor;
SHOW INDEX FROM actor;

-- Both querys spent the same time, but the last name column already has an index

#3 - Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.

SELECT description						
FROM film
WHERE description like '%Astounding%';
-- Cost: 7ms
CREATE FULLTEXT INDEX film_description_idx ON film(description);
SELECT description									
FROM film
WHERE MATCH(description) AGAINST('%Astounding%');
-- Cost: 4ms
drop index film_description_idx on film;

-- Full-text search is a powerful feature for conducting full-text searches in MySQL. 
-- It enables finding relevant results based on the frequency and location of words rather than just searching for exact matches.
-- Especially when dealing with larger bodies of text.