
drop database if exists imdb;
create database if not exists imdb;
use imdb;
create table film (
    film_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(20),
    description VARCHAR(20),
    release_year year
);

create table actor (
    actor_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20),
    last_name VARCHAR(20)
);

create table film_actor (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    actor_id INTEGER,
    film_id INTEGER
);

ALTER TABLE film
ADD last_update varchar(20);

ALTER TABLE actor
ADD last_update varchar(20);

ALTER TABLE film_actor
ADD FOREIGN KEY (actor_id) REFERENCES actor(actor_id);
ALTER TABLE film_actor
ADD FOREIGN KEY (film_id) REFERENCES film(film_id);

insert into  film(title, description, release_year) values ("Mision imposible 3", "pelicula de accion", 2017);
insert into  film(title, description, release_year) values ("Mision imposible 32", "pelicula de terror", 2018);
insert into  film(title, description, release_year) values ("Mision imposible 321", "pelicula de romance", 2019);

insert into  actor(first_name, last_name) values ("juan", "gala");
insert into  actor(first_name, last_name) values ("pedro", "fasf");
insert into  actor(first_name, last_name) values ("jose", "nazi");

insert into  film_actor(actor_id, film_id) values (1, 2);
insert into  film_actor(actor_id, film_id) values (1, 3);
insert into  film_actor(actor_id, film_id) values (2, 1);

