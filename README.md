**Proyecto de Consultas en la Base de Datos Sakila**

**Índice**
1. Descripción del Proyecto
2. ¿Qué ofrezco con mi proyecto?
3. Estado del Proyecto
4. Demostración de funciones y aplicaciones
5. Acceso al Proyecto
6. Tecnologías utilizadas



**Descripción del proyecto**
Este proyecto consiste en realizar una serie de consultas SQL sobre la base de datos Sakila, que simula una tienda de alquiler de películas. Las consultas están diseñadas para obtener información detallada sobre películas, actores, categorías, clientes y alquileres.


**¿Qué ofezco con mi proyecto?**

- Consultas eficientes y personalizadas: Desde obtener los títulos de las películas más populares hasta realizar análisis complejos sobre los alquileres y las categorías de películas.
- Optimización de tus recursos: Uso de funciones avanzadas como JOIN, GROUP BY y HAVING para una exploración detallada de tus datos sin importar cuán grande sea tu base de datos.
- Informes y estadísticas a tu alcance: Obtén fácilmente el recuento de películas por categorías, la duración promedio de las películas y el número total de alquileres por cliente.
- Flexibilidad: Modifica las consultas según tus necesidades y adapta los resultados a la estrategia de tu negocio.


**Estado del Proyecto**
- Las consultas SQL están probadas.
- El código está listo para ser ejecutado en una base de datos Sakila.


**Demostración de funciones y aplicaciones**

1. Seleccionar los títulos de películas sin duplicados:

SELECT DISTINCT title
    FROM film;

2. Buscar películas que contengan la palabra "amazing" en su descripción:

SELECT title, `description`
    FROM film
    WHERE `description` LIKE '%amazing%';

3. Contar el total de películas alquiladas por cada cliente:

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS peliculas_alquiladas
    FROM customer AS c
    INNER JOIN rental AS r ON c.customer_id = r.customer_id
    INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id  
    GROUP BY c.customer_id, c.first_name, c.last_name;

Entre otras.


**Acceso al Proyecto**

1. Clonar el repositorio: git clone https://github.com/Adalab/bda-modulo-2-evaluacion-final-CristinaMSF.git

2. Configurar la Base de Datos:

- Instalar MySQL.
- Importa la base de datos Sakila.

3. Ejecutar las Consultas:

- Conéctate a la base de datos sakila.
- Ejecuta las consultas.


**Tecnologías Utilizadas**

- _MySQL_: Sistema de gestión de bases de datos relacional utilizado para ejecutar las consultas.
- _Sakila_: Base de datos de muestra, que simila una tienda de alquiler de películas.















