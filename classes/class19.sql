#CLASS19;
#1 - Create a user data_analyst;
CREATE USER data_analyst@localhost IDENTIFIED BY 'password';
SELECT user, host FROM mysql.user;
#2 - Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it;
SHOW GRANTS FOR data_analyst@localhost;
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

#3 - Login with this user and try to create a table. Show the result of that operation;
mysql -u data_analyst -p
USE sakila;
CREATE TABLE aaa(
    id INT
);  
-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'aaa'

#4 - Try to update a title of a film. Write the update script;
UPDATE film 
SET title = 'Cars' 
WHERE film_id = 1;

#5 - With root or any admin user revoke the UPDATE permission. Write the command;
mysql -u root -p
USE sakila;
SHOW GRANTS FOR 'data_analyst'@'localhost';
REVOKE UPDATE ON sakila.* from data_analyst;
SHOW GRANTS FOR 'data_analyst'@'localhost';

#6 - Login again with data_analyst and try again the update done in step 4. Show the result;
mysql -u data_analyst -p
USE sakila;
UPDATE film SET title = 'Cars' WHERE film_id = 1;
-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'