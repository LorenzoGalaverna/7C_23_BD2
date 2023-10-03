#CLASS15
;
#Create a view named list_of_customers, it should contain the following columns:
#customer id
#customer full name,
#address
#zip code
#phone
#city
#country
#status (when active column is 1 show it as 'active', otherwise is 'inactive')
#store id
;
CREATE OR REPLACE VIEW list_of_costumers AS
	SELECT c.customer_id, CONCAT(c.first_name,'',c.last_name) as 'Full Name', a.phone, a.address, a.postal_code, ci.city, co.country, 
    CASE
           WHEN active = 1 THEN 'ACTIVE'
           WHEN active = 0 THEN 'INACTIVE'
           ELSE 'UNKNOWN'
    END AS status, c.store_id
	FROM customer c 
    JOIN address a on c.address_id = a.address_id 
    JOIN city ci on a.city_id = ci.city_id 
    JOIN country co on ci.country_id = co.country_id;

SELECT * FROM list_of_costumers;
#Create a view named film_details, it should contain the following 
#columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors 
#separated by comma. Hint use GROUP_CONCAT
;
CREATE OR REPLACE VIEW film_details AS
	SELECT f.film_id, f.title, f.description, c.name, f.length, f.rating, f.replacement_cost, group_concat(' ',a.first_name,' ',a.last_name) AS 'Actores'
	FROM film f  
    INNER JOIN film_category USING(film_id) 
    INNER JOIN category c USING(category_id) 
    INNER JOIN film_actor USING(film_id) 
    INNER JOIN actor a USING(actor_id) 
    GROUP BY f.film_id, c.name;

SELECT * FROM film_details;

#Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
;
CREATE OR REPLACE VIEW sales_by_film_category AS
	SELECT c.name as 'category', count(r.rental_id) as 'total_rental' 
  FROM film 
  JOIN film_category USING (film_id) 
  JOIN category c USING (category_id) 
  JOIN inventory USING (film_id) 
  JOIN rental r USING (inventory_id) 
  group by c.name;

SELECT * FROM sales_by_film_category;

#Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
;
CREATE OR REPLACE VIEW actor_information AS
	SELECT a.actor_id, a.first_name, a.last_name, count(f.film_id) as 'Peliculas que Participo'
	FROM actor a 
    JOIN film_actor USING (actor_id) 
    JOIN film f USING (film_id) 
    GROUP BY a.actor_id 
    ORDER BY a.actor_id;

SELECT * FROM actor_information;

#Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
;
select											
    `a`.`actor_id` AS `actor_id`,
    `a`.`first_name` AS `first_name`,
    `a`.`last_name` AS `last_name`,
    group_concat(								
        distinct concat(						
            `c`.`name`,							
            ': ', (								
                select							
                    group_concat(
                        `f`.`title`
                        order by
                            `f`.`title` ASC separator ', '
                    )
                from ( (
                            `sakila`.`film` `f`
                            join `sakila`.`film_category` `fc` on( (`f`.`film_id` = `fc`.`film_id`)
                            )
                        )
                        join `sakila`.`film_actor` `fa` on( (`f`.`film_id` = `fa`.`film_id`)
                        )
                    )
                where ( (
                            `fc`.`category_id` = `c`.`category_id`
                        )
                        and (
                            `fa`.`actor_id` = `a`.`actor_id`
                        )
                    )
            )
        )
        order by
            `c`.`name` ASC separator '; '
    ) AS `film_info`
from ( ( (														
                `sakila`.`actor` `a`							
                left join `sakila`.`film_actor` `fa` on( (		
                        `a`.`actor_id` = `fa`.`actor_id`
                    )
                )
            )
            left join `sakila`.`film_category` `fc` on( (
                    `fa`.`film_id` = `fc`.`film_id`
                )
            )
        )
        left join `sakila`.`category` `c` on( (
                `fc`.`category_id` = `c`.`category_id`
            )
        )
    )
group by
    `a`.`actor_id`,
    `a`.`first_name`,
    `a`.`last_name`;

/*
La vista "actor_info" da información sobre los actores sin que estos esten repetidos,
siendo estos: su ID, nombre, apellido y películas en las que actuaron.
Las películas se presentan ordenadas por categoría, y dentro de cada categoría se muestran 
los nombres de las películas en las que el actor participó.
*/
;

#Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
:
/*
es una tabla virtual, que representa el resultado de una consulta que se guarda en una tabla de la base de datos. 
Esto proporciona un acceso mucho más eficiente, a costa de un incremento en el tamaño de la base de datos y a una 
posible falta de sincronía. Además, dado que la vista se almacena como una tabla real, se puede hacer con ella lo 
mismo que con cualquier otra tabla.
Alternativas:
Índices: Los índices pueden acelerar las consultas al proporcionar una estructura de datos optimizada para la búsqueda rápida de registros. Sin embargo, los índices no son tan flexibles como las vistas materializadas y solo son efectivos para consultas que se ajustan a los patrones de los índices existentes.
Caché de consultas: Algunos sistemas de bases de datos y aplicaciones utilizan cachés de consultas para almacenar en memoria los resultados de las consultas más frecuentes. Sin embargo, los cachés de consultas solo ofrecen mejoras de rendimiento temporales y pueden ocupar mucha memoria.
Donde existen:
Oracle Database:
Oracle ofrece un sólido soporte para vistas materializadas, incluidos diferentes tipos de vistas materializadas, como vistas materializadas completas, de actualización rápida y de actualización parcial.

Microsoft SQL Server:
SQL Server proporciona vistas materializadas conocidas como "Indexed Views" (Vistas indexadas), que se actualizan automáticamente cuando cambian los datos subyacentes.

PostgreSQL:
PostgreSQL admite vistas materializadas y permite a los usuarios crear, consultar y actualizarlas manualmente.
*/