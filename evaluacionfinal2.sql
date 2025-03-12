USE sakila;

# 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title  
	FROM film;

# 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT *
	FROM film; 
    
SELECT title 
	FROM film
    WHERE rating = "PG-13";
    
# 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
	FROM film
    WHERE description LIKE '%amazing%';

# 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT *
	FROM film;
    
SELECT title
	FROM film
	WHERE length > 120;
    
# 5. Recupera los nombres de todos los actores.

SELECT DISTINCT first_name, last_name
	FROM actor; 


# 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE '%Gibson%'; 
    
# 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20;

# 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. 

SELECT *
	FROM film;

SELECT title 
	FROM film
    WHERE rating != "PG-13" AND rating != "R";

# 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(*) AS total_peliculas
	 FROM film
     GROUP BY rating;

# 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS peliculas_alquiladas
	FROM customer AS C	
    INNER JOIN rental AS r ON c.customer_id = r.customer_id
    INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
    GROUP BY c.customer_id, c.first_name, c.last_name;

# 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT *
	FROM film;
    
SELECT c.name AS categoria, COUNT(*) AS recuento_alquileres
	FROM category AS c
    INNER JOIN film_category AS fc ON c.category_id = fc.category_id     
    INNER JOIN film AS f ON fc.film_id = f.film_id  
    INNER JOIN inventory i ON f.film_id = i.film_id
	INNER JOIN rental r ON i.inventory_id = r.inventory_id 
	GROUP BY c.name;
    
/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación 
junto con el promedio de duración. */

SELECT rating, AVG(length) AS promedio_duracion
	FROM film
	GROUP BY rating;

# 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT a.first_name, a.last_name
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id 
    INNER JOIN film AS f ON fa.film_id = f.film_id 
	WHERE title LIKE '%Indian Love%';

# 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
	FROM film
    WHERE description LIKE '%dog5%' OR description LIKE '%cat%';
    
# 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

SELECT a.actor_id, a.first_name, a.last_name
	FROM actor AS a
	LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	WHERE fa.actor_id IS NULL; 
    
# 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT *
	FROM film; 
    
SELECT title
	FROM film 
    WHERE release_year BETWEEN 2005 AND 2010;

# 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT *
	FROM film; 
    
SELECT *
	FROM category;
    
SELECT f.title
	FROM film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fa.category_id = c.category_id
    WHERE c.name LIKE '%Family%';

# 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.first_name, a.last_name 
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) > 10;

# 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT *
	FROM film;
    
SELECT title 
	FROM film
    WHERE rating = "R" AND length > 120;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la 
categoría junto con el promedio de duración.*/

SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
	FROM film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id
    GROUP BY c.name  
    HAVING AVG(f.length) > 120; 
    
/*  21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas 
en las que han actuado.*/

SELECT a.first_name, a.last_name, COUNT(*) AS cantidad_peliculas
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
    INNER JOIN film AS f ON fa.film_id = f.film_id
    GROUP BY a.actor_id 
    HAVING COUNT(*) >= 5; 
    
/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los 
rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */

SELECT *
	FROM film; 

SELECT *
	FROM rental;
    
SELECT f.title 
	FROM film AS f
    WHERE f.film_id IN (
		SELECT r.rental_id 
			FROM rental AS r
				WHERE DATEDIFF(r.return_date, r.rental_date) > 5
);   

/*  23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos 
de la lista de actores.*/

SELECT *
	FROM actor; 

SELECT *
	FROM film;

SELECT *
	FROM category;
    
SELECT first_name, last_name
	FROM actor AS a
    WHERE actor_id NOT IN (
		SELECT a.actor_id
			FROM actor AS a
            INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
            INNER JOIN film AS f ON fa.film_id = f.film_id
            INNER JOIN film_category AS fc ON f.film_id = fc.film_id
            INNER JOIN category AS c ON fc.category_id = c.category_id
            WHERE c.name LIKE '%Horror%'
);

SELECT first_name, last_name
	FROM actor AS a
	WHERE actor_id NOT IN (
		SELECT fa.actor_id
			FROM film_actor AS fa
			INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
			INNER JOIN category AS c ON fc.category_id = c.category_id
			WHERE c.name = 'Horror'
);

# 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT *
	FROM film;

SELECT *
	FROM category;

SELECT f.title 
	FROM film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id
    WHERE c.name = "Comedy"
    AND f.length > 180;
    