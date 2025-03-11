USE sakila;

# 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title   -- DISTINCT elimina los valores duplicados en la columna
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
    
-- filtra las películas cuya descripción contenga la palabra "amazing", sin importar si está en mayúsculas o minúsculas.
-- El operador LIKE y los símbolos % permiten buscar coincidencias en cualquier parte del texto.
-- no se puede usar IN porque IN se usa para comparar valores exactos en una lista y 
-- no permite buscar coincidencias parciales dentro de un texto.

# 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT *
	FROM film;
    
SELECT title
	FROM film
	WHERE length > 120;
    
# 5. Recupera los nombres de todos los actores.

SELECT DISTINCT first_name, last_name
	FROM actor; 
-- pongo un distinct por si se repiten y el last_name igual

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
-- GROUP BY: Agrupa las películas según su clasificación (rating), para contar las películas de cada tipo.

# 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS peliculas_alquiladas
	FROM customer AS C	
    INNER JOIN rental AS r ON c.customer_id = r.customer_id
    INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
    GROUP BY c.customer_id, c.first_name, c.last_name;

-- viendo diagrama tengo que hacer caminito desde c a invertory a rental. 

# 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT *
	FROM film;
    
SELECT c.name AS categoria, COUNT(*) AS recuento_alquileres
	FROM category AS c
    INNER JOIN film_category AS fc ON c.category_id = fc.category_id     -- Esta tabla sirve de puente entre las categorías y las películas.
    INNER JOIN film AS f ON fc.film_id = f.film_id  -- para obtener información sobre las películas de cada categoría.
    INNER JOIN inventory i ON f.film_id = i.film_id -- para asociar las películas con el inventario
	INNER JOIN rental r ON i.inventory_id = r.inventory_id -- para vincular las películas alquiladas.
	GROUP BY c.name;
    
-- utilizamos GROUP BY para agrupar las películas por categoría y luego contar cuántas películas hay en cada categoría:
-- Si no usas GROUP BY, SQL no sabe cómo agrupar las filas antes de aplicar las funciones agregadas (COUNT)

/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación 
junto con el promedio de duración. */

SELECT rating, AVG(length) AS promedio_duracion
	FROM film
	GROUP BY rating;

-- Agrupa los resultados por la clasificación (rating). De esta manera, calcularemos el promedio de duración para cada grupo de películas con la misma clasificación.

# 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT a.first_name, a.last_name
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id -- Une la tabla actor con la tabla intermedia film_actor utilizando la columna actor_id.
    INNER JOIN film AS f ON fa.film_id = f.film_id -- Une la tabla film_actor con la tabla film utilizando la columna film_id.
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
    
-- Unión externa izquierda entre la tabla actor y la tabla film_actor utilizando la columna actor_id. Esto garantiza que se incluyan todos los actores, incluso aquellos que no tienen registros correspondientes en film_actor.

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
-- unión interna entre film y film_category (alias fc) utilizando la columna film_id como clave común. Esto asegura que solo se incluyan las películas que tienen registros correspondientes en la tabla film_category.
--  Realiza una unión interna entre film_category y category (alias c) utilizando la columna category_id como clave común. Esto garantiza que solo se incluyan las categorías que tienen registros correspondientes en la tabla category.
-- permite buscar cualquier categoría que incluya "Family" en su nombre.


# 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.first_name, a.last_name 
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) > 10;

-- unión interna entre actor y film_actor utilizando actor_id como clave común. Esto permite asociar actores con sus participaciones en películas. 
-- Agrupa los resultados por actor_id, de modo que se puedan aplicar funciones de agregación (como COUNT) a cada grupo.
--  Filtra los grupos para incluir solo aquellos actores que aparecen en más de 10 películas. La cláusula HAVING se utiliza para filtrar resultados después de la agrupación.

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
    GROUP BY c.name  -- Agrupa los resultados por el nombre de la categoría.
    HAVING AVG(f.length) > 120; -- Filtra las categorías cuyo promedio de duración es superior a 120 minutos.
    
    
/*  21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas 
en las que han actuado.*/

SELECT a.first_name, a.last_name, COUNT(*) AS cantidad_peliculas
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
    INNER JOIN film AS f ON fa.film_id = f.film_id
    GROUP BY a.actor_id -- Agrupa los resultados por el identificador único del actor, asegurando que cada actor sea contado individualmente.
						-- garantiza que cada actor se cuente correctamente, incluso si hay actores con el mismo nombre o apellido.
    HAVING COUNT(*) >= 5; --  para aplicar condiciones sobre los resultados agregados después de la agrupación.
    
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
);    -- utilizo datediff para calcular la diferencia entre dos fechas

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

-- no se ocmo hacer para que no de not null si hubiese
            
    
    
-- 
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
    
/*Uniones:
Se realiza una unión interna (INNER JOIN) entre film y film_category utilizando f.film_id = fc.film_id.
Otra unión interna entre film_category y category con fc.category_id = c.category_id.
Condiciones:
Se filtra por la categoría cuyo nombre es 'Comedy' (c.name = 'Comedy').
Se filtra por películas cuya duración es mayor a 180 minutos (f.length > 180).