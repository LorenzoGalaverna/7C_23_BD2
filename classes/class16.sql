#CLASS16;
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
insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

#1- Insert a new employee to , but with an null email. Explain what happens.

insert into
    employees(employeeNumber,lastName,firstName,extension,email,officeCode,reportsTo,jobTitle)
    values (
        1,
        'juanceto',
        'oblak',
        'aaa',
        NULL,
        '1',
        '1',
        'limpiavidrios'
    )

-- Este ingreso de datos no es posible ya que un requerimiento del campo email, es que no sea nulo y es por esto que da error.

#2- Run the first the query;

UPDATE employees SET employeeNumber = employeeNumber - 20;

-- Esta query reduce el employeenumber en 20 numeros en todos los valores

#What did happen? Explain. Then run this other

UPDATE employees SET employeeNumber = employeeNumber + 20;

-- Al ejecutar esta query devuelve un error (Duplicate entry '1056' for key 'employees.PRIMARY'), 
-- esto se debe a que hay 2 employees con una diferencia de 20 numeros en su id.
-- Pero cuando intenta agregar 20 al primero este numero choca con el del segundo y de esta forma da error.

#3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.;
ALTER TABLE employees ADD age int check(age >= 16 and age <= 70);

#4- Describe the referential integrity between tables film, actor and film_actor in sakila db.;

-- La tablafilm_actor funciona como tabla intermedia establesciendo una relacion de muchos a muchos entre las otras 2 conteniendo 
-- las FOREIGN KEYS las cuales refieren a las tablas. Esto previene que la relacion este mal hecha o incompleta.

#5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates 
#operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the 
#row (assume multiple users, other than root, can connect to MySQL and change this table).

ALTER TABLE employees ADD lastUpdate datetime;

ALTER TABLE employees ADD lastUpdateUser varchar(50);

DELIMITER $$
CREATE TRIGGER before_employees_update BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    SET NEW.lastUpdate = now();
    SET NEW.lastUpdateUser = CURRENT_USER;
END$$
CREATE TRIGGER before_employees_insert BEFORE insert ON employees
    FOR EACH ROW 
BEGIN
    SET NEW.lastUpdate = now();
    SET NEW.lastUpdateUser = CURRENT_USER;
END$$
DELIMITER ;

UPDATE employees SET age = 70 WHERE employeeNumber = 982;
select * from employees;
#6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

SHOW TRIGGERS FROM sakila;

-- TRIGGERS:

CREATE DEFINER=`user`@`%` TRIGGER `ins_film` 
    AFTER INSERT ON `film`
    FOR EACH ROW 
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END

-- ins_film: despues de que se inserta un valor, este trigger inserta el film_id,title y la description a film_text.

CREATE DEFINER=`user`@`%` TRIGGER `upd_film`
    AFTER UPDATE ON `film`
    FOR EACH ROW
BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END

-- upd_film: cuando el titulo, description o film_id de una pelicual es actualizada, esta cambia tambien el title, description y film_id 
-- del film_text, de esta manera actualizandola.
  
  CREATE DEFINER=`user`@`%` TRIGGER `del_film`
    AFTER DELETE ON `film`
    FOR EACH ROW
  BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END

-- del_film: borra el film_text de una pelicula que fue borrada.