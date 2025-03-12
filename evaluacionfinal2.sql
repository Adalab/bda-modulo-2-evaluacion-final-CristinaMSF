USE sakila;

# 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT *                -- tabla que utilizo
	FROM film; 
    
SELECT DISTINCT title   -- uso DISTINCT porque elimina los valores duplicados en la columna
	FROM film;

# 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT *				-- tabla que utilizo
	FROM film; 
    
SELECT title
	FROM film
    WHERE rating = "PG-13";
    
# 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT *				-- tabla que utilizo
FROM film; 

SELECT title, `description`               
	FROM film
    WHERE `description` LIKE '%amazing%'; -- LIKE para filtrar las peliculas con amazing
										-- pensé en usar un IN, pero se usa para comparar valores exactos en una lista y 
										-- no permite buscar coincidencias parciales
-- uso las comillas inversas para que sql identifique la palabra como columna y no como una palabra reservada

# 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT *				-- tabla que utilizo
	FROM film;
    
SELECT title
	FROM film
	WHERE length > 120;
    
# 5. Recupera los nombres de todos los actores.

SELECT *				-- tabla que utilizo
	FROM film; 
    
SELECT DISTINCT first_name, last_name    -- pongo DISTINCT por si se repiten y last_name igual
	FROM actor; 

# 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT *					-- tabla que utilizo
FROM actor; 

SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE '%Gibson%'; 
    
/*utilizo LIKE para buscar cualquier apellido que contenga la palabra "Gibson" en cualquier parte del texto, también pensé en usar un
'=', que ocurre que solo encontraría actores que su apellido sea exactamente "Gibson", sin permitir ninguna variación, si se el apellido
fuese 'Gibson-Klaus' o algun compuesto de ese tipo, no lo encontraria, por eso opté por usar el LIKE, y si tenemos un base de datos con
muchos nombres y apellidos, tardaríamos mucho en revisar*/
    
# 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT *					-- tabla que utilizo
FROM actor; 

SELECT first_name
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20;

# 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. 

SELECT *					-- tabla que utilizo
	FROM film;

SELECT title
	FROM film
    WHERE rating != "PG-13" AND rating != "R";
-- he usado != porque es una exclusión exacta según el enunciado, usaría NOT LIKE si necesite excluir valores que coincidan parcialmente

# 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT *				   -- tabla que utilizo
FROM film;

SELECT rating, COUNT(*) AS total_peliculas
	 FROM film
     GROUP BY rating;   
     
-- pongo el AS para crear un alias y así renombro la columna
-- GROUP BY necasario siempre que utilicemos una funcion agregada agrupa las películas según su clasificación (rating), 
-- para contar las películas de cada tipo

# 10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.


SELECT *					-- tablas que utilizo
FROM customer;

SELECT *
FROM rental;

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id)  AS peliculas_alquiladas
	FROM customer AS C			
    INNER JOIN rental AS r ON c.customer_id = r.customer_id
    INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id  
    GROUP BY c.customer_id, c.first_name, c.last_name;
    
-- viendo diagrama tengo que hacer caminito desde c a invertory a rental, por eso uso INNER
-- primer INNER con tabla r que sirve de puente entre las customer y rental por medio de customer_id
-- segundo INNER enlace entre inventory y rental, por medio de inventory_id
-- GROUP BY para agrupar los resultados por cliente y contar cuántas películas ha alquilado cada uno

# 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT *				   -- tabla que utilizo
FROM category;					

SELECT *
FROM film_category;

SELECT *
FROM inventory;

SELECT *
FROM rental;

SELECT *
FROM film;
    
SELECT c.name AS categoria, COUNT(rental_id) AS recuento_alquileres
	FROM category AS c
    INNER JOIN film_category AS fc ON c.category_id = fc.category_id     
    INNER JOIN film AS f ON fc.film_id = f.film_id  
    INNER JOIN inventory i ON f.film_id = i.film_id
	INNER JOIN rental r ON i.inventory_id = r.inventory_id 
	GROUP BY c.name;
  
-- primer INNER con tabla fc que sirve de puente entre las categorías y las películas
-- segundo INNER para obtener información sobre las películas de cada categoría
-- tercer INNER para asociar las películas con el inventario
-- cuarto INNER para vincular las películas alquiladas.
-- GROUP BY para agrupar las películas por categoría y luego contar cuántas películas hay en cada categoría, y así,
-- poder agrupar las filas después de usar el COUNT, función agregada

/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación 
junto con el promedio de duración. */

SELECT *				   -- tabla que utilizo
FROM film;

SELECT rating AS clasificacion, AVG(length) AS promedio_duracion
	FROM film
	GROUP BY rating;

-- uso el GROUP BY porque es necesario para agrupar los resultados por la clasificación (rating)y poder calcular el promedio

# 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT * 				 -- tablas que utilizo
FROM actor;

SELECT *
FROM film_actor;

SELECT *
FROM film;

SELECT a.first_name, a.last_name
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id 
    INNER JOIN film AS f ON fa.film_id = f.film_id 
	WHERE title LIKE '%Indian Love%';
    
-- primer INNER vincula la tabla actor con la tabla intermedia film_actor utilizando la columna actor_id
-- segundo INNER vincula la tabla film_actor con la tabla film utilizando la columna film_id

# 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT *				   -- tabla que utilizo
FROM film;

SELECT title
	FROM film
    WHERE `description` LIKE '%dog5%' OR `description` LIKE '%cat%';
    
# 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

SELECT * 				 -- tablas que utilizo
FROM actor;

SELECT *
FROM film_actor;

SELECT a.actor_id, a.first_name, a.last_name
	FROM actor AS a
	LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	WHERE fa.actor_id IS NULL; 

-- unión externa izquierda entre la tabla actor y la tabla film_actor utilizando la columna actor_id
-- con esto me aseguro que incluya todos los actores, incluso los que no tienen registros en film_actor.
-- utilizo  IS en vez de '=' porque NULL no representa un valor como tal, sino la falta del mismo

# 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT *				 -- tabla que utilizo
	FROM film; 
    
SELECT title
	FROM film 
    WHERE release_year BETWEEN 2005 AND 2010;

-- intervalo son comillas por el dato que es 

# 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT *					-- tablas que utilizo
	FROM film; 
    
SELECT *
	FROM category;
    
SELECT *
FROM film_category;
    
SELECT title
	FROM film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id
    WHERE c.name LIKE '%Family%';

-- primer INNER para enlazar film y film_category utilizando la columna film_id
-- segundo INNER para enlazar film_category y category utilizando la columna category_id 
-- con el WHERE busco cualquier categoría que incluya "Family" en su nombre

# 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT *					-- tablas que utilizo
FROM actor;

SELECT *
FROM film_actor;

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING cantidad_peliculas > 10;
   
-- primer INNER para enlazar actor y film_actor utilizando actor_id  
-- no necesito hacer otra union a film porque la tabla film_actor ya tiene el film_id de cada película en la que ha actuado un actor
-- con GROUP BY agrupo los resultados por actor_id, para usar luego la funcion de agregacion COUNT
-- con el HAVING filtro los grupos para incluir solo actores que aparecen en más de 10 películas
-- para filtrar resultados después de la agrupación del GROUP

# 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT *                     -- tablas que utilizo
	FROM film;
    
SELECT title
	FROM film
    WHERE rating = "R" AND length > 120;

-- con WHERE filtro dos condiciones

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la 
categoría junto con el promedio de duración.*/

SELECT *					 -- tablas que utilizo
FROM film;

SELECT *
FROM category;

SELECT *
FROM film_category;

SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
	FROM category as c
    INNER JOIN film_category as fc ON c.category_id = fc.category_id 
    INNER JOIN film as f ON fc.film_id = f.film_id                
	GROUP BY c.name                   
	HAVING promedio_duracion > 120;

-- primer INNER JOIN para vincular las tablas category y film_category mediante category_id.
-- segundo INNER JOIN para vincular film_category con film para obtener la duración de las películas.
-- uso GROUP BY para agrupar las películas por categoría y calcular el promedio de duración dentro de cada categoría
-- uso HAVING para filtrar solo las categorías con promedio de duración es mayor a 120, con un alias

/*  21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas 
en las que han actuado.*/

SELECT *					 -- tablas que utilizo
FROM film;

SELECT *
FROM actor;

SELECT *
FROM film_actor;

SELECT a.first_name, a.last_name, COUNT(f.film_id) AS cantidad_peliculas
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
    INNER JOIN film AS f ON fa.film_id = f.film_id
    GROUP BY a.actor_id 
	HAVING cantidad_peliculas >= 5;
    
-- primer INNER JOIN con film_actor para asociar actores con las películas en las que han participado
-- segundo INNER JOIN con film para obtener información sobre las películas en las que han actuado los actores
-- uso GROUP BY para agrupar por actor y contar cuántas películas ha realizado cada uno
-- uso HAVING para filtrar solo los actores que han participado en al menos 5 películas
-- el COUNT en este caso cuenta el numero de ves que aparece un film_id por cada actor

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los 
rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */

SELECT *						-- tablas que utilizo
	FROM film; 

SELECT *
	FROM rental;

SELECT *
	FROM inventory;

-- primero he creado la subconsulta aparte         
                             
SELECT rental_id                                      
	FROM rental AS r                                        
	WHERE DATEDIFF(return_date, rental_date) > 5;
    
-- solución final   

SELECT r.rental_id, f.title
	FROM rental AS r
	INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id  
	INNER JOIN film AS f ON i.film_id = f.film_id                
	WHERE r.rental_id IN (                                     
					SELECT rental_id                                        
						FROM rental AS r                                        
						WHERE DATEDIFF(return_date, rental_date) > 5            
);
        
/* la consulta principal obtiene los rental_id y el title de las películas, filtrando solo aquellas en las que
la duración de alquiler es mayor a 5 días. La condición en WHERE con IN filtra los alquileres cuyo rental_id está en el 
conjunto de resultados de la subconsulta. he creado la subconsulta utilizando la función DATEDIFF para calcular la diferencia 
entre return_date y rental_date, y selecciona aquellos alquileres en la que la duración es mayor a 5 días. */

/*  23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos 
de la lista de actores.*/

SELECT *				-- tablas que utilizo
	FROM actor; 

SELECT *
	FROM film;

SELECT *
	FROM category;
    
-- primero he creado la subconsulta aparte 
     
SELECT fa.actor_id
			FROM film_actor AS fa
			INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
			INNER JOIN category AS c ON fc.category_id = c.category_id
			WHERE c.name = 'Horror';

-- solución final  

SELECT first_name, last_name
	FROM actor AS a
	WHERE actor_id NOT IN (
		SELECT fa.actor_id
			FROM film_actor AS fa
			INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
			INNER JOIN category AS c ON fc.category_id = c.category_id
			WHERE c.name = 'Horror'
);
-- uso un INNER JOIN para relacionar la tabla film_category para vincular las películas con sus categorías
-- uso un segundo INNER JOIN con la tabla category para obtener las categorías de las películas
-- con el where filtro las películas que tienen la categoría 'Horror'

/*en este ejercicio he creado una consulta principal para obtener los actores con actor_id que 
no están en el conjunto de actores que han trabajado en películas de la categoría "Horror" con la condición NOT IN 
y una subconsulta en la que filtro los actores que han participado en películas de la categoría
"Horror" con un INNER JOIN con las tablas film_category y category */

# 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT *						-- tablas que utilizo
	FROM film;

SELECT *
	FROM category;

SELECT title 
	FROM film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id
    WHERE c.name = "Comedy" AND f.length > 180;
    
-- uso un INNER JOIN con la tabla film_category para vincular las películas con sus categorías
-- hago un segundo INNER JOIN con la tabla category para obtener las categorías de las películas
-- y uso un WHERE para filtrar las películas con categoría que sea 'Comedy' y un AND para filtrar 
-- las películas que tienen una duración mayor a 180 minutos
    