#CLASS14

#Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.
;
SELECT
    CONCAT(c.first_name, ', ', c.last_name) AS 'Nombre', ad.address, ci.city, co.country
FROM customer c
    INNER JOIN address ad USING(address_id)
    INNER JOIN city ci USING(city_id)
    INNER JOIN country co USING(country_id)
WHERE co.country = 'Argentina';

#Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: 
#https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.
;
SELECT
    f.title,l.name,f.rating,
    CASE
        WHEN f.rating LIKE 'G' THEN '(General Audiences) – All ages admitted'
        WHEN f.rating LIKE 'PG' THEN '(Parental Guidance Suggested) – Some material may not be suitable for children'
        WHEN f.rating LIKE 'PG-13' THEN '(Parents Strongly Cautioned) – Some material may be inappropriate for children under 13'
        WHEN f.rating LIKE 'R' THEN '(Restricted) – Under 17 requires accompanying parent or adult guardian'
        WHEN f.rating LIKE 'NC-17' THEN '(Adults Only) – No one 17 and under admitted'
    END 'Rating Text'
FROM film f
    INNER JOIN language l USING(language_id);

#Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced 
#by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
;
SELECT
    ac.actor_id,CONCAT(ac.first_name,' ',ac.last_name)as 'Nombre Actor/Actriz', f.film_id, f.title, f.release_year
FROM film f
    INNER JOIN film_actor USING(film_id)
    INNER JOIN actor ac USING(actor_id)
WHERE
    CONCAT(first_name, ' ', last_name) LIKE TRIM(UPPER('NICK WAHLBERG'));

#Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned 
#column with two possible values 'Yes' and 'No'.
;
SELECT
    f.title, r.rental_date, c.first_name,
    CASE
        WHEN r.return_date IS NULL THEN 'No' ELSE 'Yes'
    END 'Returned?'
FROM rental r
    INNER JOIN inventory i USING(inventory_id)
    INNER JOIN film f USING(film_id)
    INNER JOIN customer c USING(customer_id)
WHERE
    MONTH(r.rental_date) = '05'OR MONTH(r.rental_date) = '06'

#Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.
;

-- In SQL, the CAST and CONVERT functions are used to convert one data type to another. They can be particularly useful 
-- when you need to manipulate or compare data of different types. Both functions serve a similar purpose, but there are some 
-- differences in how they are used and the scenarios in which they are applicable.

-- CAST Function:
-- The CAST function is used to explicitly convert one data type into another. It's quite straightforward and widely 
-- supported across different database systems. 
-- The basic syntax for the CAST function is:
CAST(expression AS target_data_type)

-- Example using the Sakila database:
;
SELECT title, CAST(length AS DECIMAL(5,1)) AS decimal_length
FROM film;

-- CONVERT Function:
-- The CONVERT function is specific to Microsoft SQL Server. It serves the same purpose as the CAST function but provides additional 
-- functionality like specifying different styles for converting data, which can be useful for datetime conversions.
-- The basic syntax for the CONVERT function is:
CONVERT(target_data_type, expression, style)

-- Where target_data_type is the desired data type, expression is the value you want to convert, and style is optional 
-- and used primarily for datetime conversions.

-- Example using the Sakila database:
;
SELECT payment_id,
       CONVERT(VARCHAR(20), payment_date, 120) AS formatted_date
FROM payment;

-- Differences:

-- Compatibility: CAST is a more standard and widely supported function, while CONVERT is specific to Microsoft SQL Server.

-- Function Syntax: The syntax for both functions is slightly different, with CONVERT accepting an additional optional 
-- parameter style for datetime conversions.

-- Portability: If you're writing SQL code that you plan to use across different database systems, it's generally safer to use 
-- the CAST function due to its broader compatibility.

#Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.
;
-- NVL:

-- Available in: Oracle Database
-- Purpose: The NVL function replaces NULL values with a specified value. If the first argument is NULL, the function returns the second argument; otherwise, it returns the first argument.
-- Syntax: NVL(expr1, expr2)
-- Usage Example:
;
SELECT NVL(first_name, 'Unknown') AS customer_name
FROM customer;

-- ISNULL:

-- Available in: Microsoft SQL Server
-- Purpose: The ISNULL function replaces NULL values with a specified value. Similar to NVL, if the first 
-- argument is NULL, it returns the second argument; otherwise, it returns the first argument.
-- Syntax: ISNULL(check_expression, replacement_value)
-- Usage Example:
;
SELECT ISNULL(first_name, 'Unknown') AS customer_name
FROM customer;

-- IFNULL:

-- Available in: MySQL
-- Purpose: The IFNULL function also replaces NULL values with a specified value. If the first argument is NULL, 
-- it returns the second argument; otherwise, it returns the first argument.
-- Syntax: IFNULL(expr1, expr2)
-- Usage Example:
;
SELECT IFNULL(return_date, 'Unknown') AS return_date
FROM rental;

-- COALESCE:

-- Available in: Many relational database systems, including Oracle, SQL Server, MySQL, PostgreSQL, etc.
-- Purpose: The COALESCE function returns the first non-NULL value in a list of expressions. It is quite 
-- versatile as it can take multiple arguments and returns the first non-NULL value encountered from left to right.
-- Syntax: COALESCE(expr1, expr2, ...)
-- Usage Example:
;
SELECT COALESCE(return_date, 'Unknown') AS return_date
FROM rental;
