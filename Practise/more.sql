-- Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. 
-- There should be returned column with two possible values 'Yes' and 'No'.
SELECT r.rental_id, f.film_id, CONCAT(c.first_name,' ', c.last_name), 
CASE 
    WHEN r.return_date is NULL THEN 'NO'
    WHEN r.return_date is not NULL THEN 'YES'
    ELSE 'UNKNOWN'
END as 'Returned?'
from rental r
inner join customer c USING(customer_id)
inner join inventory i using (inventory_id)
inner join film f using (film_id)
where MONTH(r.return_date) = 05 OR MONTH(r.return_date) = 06;

-- Create a view called actor_information where it should return, actor id, first name, 
-- last name and the amount of films he/she acted on.

CREATE OR REPLACE VIEW actor_information AS
select a.actor_id, Concat(a.first_name, ' ', a.last_name), Count(f.film_id) as 'peliculas actuadas'
from film f 
inner JOIN film_actor fa USING(film_id)
inner JOIN actor a USING(actor_id)
group by a.actor_id;

select * from actor_information

-- Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
CREATE OR REPLACE VIEW sales_by_film_category AS
select c.name, count(r.rental_id) as 'total_rental'
from rental r
inner join inventory i using(inventory_id)
inner join film f using(film_id)
INNER JOIN film_category fc using(film_id)
inner JOIN category c USING(category_id)
GROUP BY c.name;

SELECT * from sales_by_film_category


CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);
create Table employees_Audit(id int not null AUTO_INCREMENT PRIMARY KEY, time DATETIME, user varchar(100));
alter table employees_Audit add COLUMN employee_id int;
CREATE Trigger after_insert_employees
BEFORE INSERT ON employees FOR EACH ROW 
BEGIN
    INSERT INTO employees_Audit(time, user, employee_id)
    VALUES(CURRENT_TIMESTAMP, user(), new.employeeNumber);
END;

insert  into employees(employeeNumber,lastName,firstName,extension,email,officeCode,reportsTo,jobTitle) values 
(2000,'CARLITOS','GALAVERNA','x5800','negros@classicmodelcars.com','1',NULL,'CONSERJE');

DESCRIBE employees;
SELECT * FROM employees;
drop Trigger after_insert_employees;

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
------------------------------------------------------------------------------------------------

create function get_staff_id_by_inventory_id(inv_id int) RETURNS INT
DETERMINISTIC
BEGIN

    DECLARE id_staff int;
    SELECT st.staff_id into id_staff
    FROM store s
    JOIN staff st USING(store_id)
    JOIN inventory i USING(store_id)
    WHERE i.inventory_id = inv_id AND s.store_id = st.store_id;

    RETURN(id_staff);

END
DELIMITER $$
CREATE Procedure rent_film(IN cust_id int, in inv_id int)
BEGIN

DECLARE id_staff INT;
SELECT get_staff_id_by_inventory_id(inv_id) into id_staff;

INSERT INTO rental(rental_date, inventory_id, customer_id, staff_id)
SELECT CURRENT_TIMESTAMP, 
(inv_id),
(cust_id),
(id_staff);

INSERT INTO payment(payment_date, customer_id, staff_id, rental_id, amount)
SELECT CURRENT_TIMESTAMP,
(cust_id),
(id_staff),
(SELECT LAST_INSERT_ID()),
200;

END $$
DELIMITER ;

call rent_film(500,2);
select * from rental;
SELECT * from payment;