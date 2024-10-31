-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados

	-- No hacía falta DISTINCT, porque ya son todos diferentes....
SELECT DISTINCT title
	FROM film;
    
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

-- ****comprobación****
SELECT title, rating
	FROM film
    WHERE rating = 'PG-13';

-- ###### RESULTADO ########
	-- Solo pide nombres de películas
SELECT title
	FROM film
    WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
	
   SELECT title, description
	FROM film
    WHERE description LIKE '%mazing%';
    
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

-- ****comprobación****
SELECT title, length
	FROM film
    WHERE length > 120;
    
-- ###### RESULTADO ########
	-- Sólo pide el título de las películas
SELECT title
	FROM film
    WHERE length > 120;
    
-- 5. Recupera los nombres de todos los actores.

	-- Considero nombres y apellidos
SELECT CONCAT(first_name,' ',last_name) AS nombres_de_actores
	FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE 'Gibson';
			-- Comprobado: solo hay 1

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

-- Considero nombres y apellidos ---- Que lo he copiado del 5, vamos

-- ****comprobación****
		-- Comprobando dónde poner el LIMIT Y EL OFFSET para que salgan del 10 al 20
SELECT CONCAT(first_name,' ',last_name) AS nombres_de_actores, actor_id
	FROM actor
    ORDER BY actor_id
    LIMIT 11
    OFFSET 9;

-- ###### RESULTADO ########
	-- Sólo pide los nombres de actores: considero nombre y apellidos
SELECT CONCAT(first_name,' ',last_name) AS nombres_de_actores
	FROM actor
    ORDER BY actor_id
    LIMIT 11
    OFFSET 9;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

-- ****comprobación****
SELECT title, rating
	FROM film
    WHERE rating NOT IN ('R', 'PG-13');

-- ###### RESULTADO ########
	-- Sólo pide títulos
SELECT title
	FROM film
    WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
/*y muestra la clasificación junto con el recuento*/

SELECT rating AS clasificacion, COUNT(title) AS recuento
	FROM film
    GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
/*su nombre y apellido junto con la cantidad de películas alquiladas.*/

-- Relaciones: 	rental   => (customer_id) => customer 
-- 				recuento películas === nombre de clientes

	-- Resolvemos la cantidad de películas alquiladas por cada id de cliente
SELECT customer_id, COUNT(rental_id)
	FROM rental
    GROUP BY customer_id;  -- Lo agrupamos para que cuente los id de películas
    
-- ###### RESULTADO ########
	-- Unimos con la tabla clientes para saber el nombre del cliente
SELECT r.customer_id, CONCAT(c.first_name,' ',c.last_name) AS nombre_cliente ,COUNT(r.rental_id) AS num_peliculas_alquiladas
	FROM rental AS r
    INNER JOIN customer AS c
		ON r.customer_id = c.customer_id
    GROUP BY customer_id; -- Lo agrupamos para que cuente los id de películas

-- 11. Encuentra la cantidad total de películas alquiladas por categoría 
/*y muestra el nombre de la categoría junto con el recuento de alquileres.*/

-- Relaciones:
-- 	rental ## recuento películas alquiladas## => (inventory_id) => inventory
-- 	inventory => (film_id) => film
-- 	film => (film_id) => film_category ¡¡¡ojo!!! aunque sea la misma id, inventory no está relacionada con film_category
-- 	film_category => (category_id) => category ## nombre categoría##

-- Hacemos todas las relaciones
SELECT r.rental_id, i.inventory_id, i.film_id, f.film_id, fc.category_id, c.name
	FROM rental AS r
    INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
		INNER JOIN film AS f
        ON i.film_id = f.film_id
			INNER JOIN film_category AS fc
            ON f.film_id = fc.film_id
				INNER JOIN category AS c
                ON fc.category_id = c.category_id;
                
-- ###### RESULTADO ########
-- Necesitamos el recuento de películas agrupados por clientes. Solo necesitamos nombre de categoría y recuento
SELECT c.name AS categoria, COUNT(r.rental_id) AS num_peliculas_alquiladas
	FROM rental AS r
    INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
		INNER JOIN film AS f
        ON i.film_id = f.film_id
			INNER JOIN film_category AS fc
            ON f.film_id = fc.film_id
				INNER JOIN category AS c
                ON fc.category_id = c.category_id
GROUP BY categoria;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación 
 -- de la tabla film y muestra la clasificación junto con el promedio de duración

-- Relaciones : film ##length## => (film_id) => film_category
-- 				film_category => (category_id) => category ##name##

-- Hacemos las relaciones
SELECT f.length, fc.film_id, fc.category_id, c.name
	FROM film AS f
    INNER JOIN 	film_category AS fc
		ON f.film_id = fc.film_id
		INNER JOIN category AS c
			ON fc.category_id = c.category_id;
            
-- ###### RESULTADO ########
-- Hacemos una media de las duraciones, agrupando por categoría . 
-- Solo nos pide la clasificación y la media de duración

SELECT c.name AS categoría, AVG(f.length) AS duracion_media_peliculas
	FROM film AS f
    INNER JOIN 	film_category AS fc
		ON f.film_id = fc.film_id
		INNER JOIN category AS c
			ON fc.category_id = c.category_id
GROUP BY c.category_id;
        
-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

-- Relaciones:	film ## title = Indian Love## => (film_id) => film_actor
-- 	 			film_actor => (actor_id) => actor ## fist_name, last_name

-- Relacionamos las tablas
SELECT f.title, f.film_id, fa.actor_id, a.first_name, a.last_name
	FROM film AS f
    INNER JOIN film_actor AS fa
		ON f.film_id = fa.film_id
		INNER JOIN actor AS a
			ON fa.actor_id = a.actor_id;

-- ###### RESULTADO ########
-- Encontramos solo los actores de Indian Love. Solo nos pide el nombre de actores
SELECT CONCAT(a.first_name,' ', a.last_name) AS actores_Indian_Love
	FROM film AS f
    INNER JOIN film_actor AS fa
		ON f.film_id = fa.film_id
		INNER JOIN actor AS a
			ON fa.actor_id = a.actor_id
            WHERE f.title LIKE 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title, description
	FROM film
    WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

-- Vemos las películas que tienen asociadas los actores 
SELECT CONCAT(a.first_name,' ', a.last_name) AS actor, COUNT(fa.film_id) AS conteo_peliculas
	FROM actor AS a
    LEFT JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY actor;     
-- He hecho un left join para que me saque todos los actores
-- A ojo vemos que no hay ningún actor sin conteo de películas. Así que probamos con los que tienen 14 películas (Emily Dee)
SELECT CONCAT(a.first_name,' ', a.last_name) AS actor, COUNT(fa.film_id) AS conteo_peliculas
	FROM actor AS a
    LEFT JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY actor  
HAVING COUNT(fa.film_id) = 14;    

-- ###### RESULTADO ########
-- Lo hacemos con =0, aunque no muestre resultados. Pide solo lista de actores   
SELECT CONCAT(a.first_name,' ', a.last_name) AS actor
	FROM actor AS a
    LEFT JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY actor  
HAVING COUNT(fa.film_id) = 0;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

SELECT title, release_year
	FROM film
    WHERE release_year >= 2005 AND release_year <=2010;
-- Ha sido una tonteria porque solo hay películas del 2006

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family"

-- Relaciones : film ##ttitles## => (film_id) => film_category
-- 				film_category => (category_id) => category ##name##

-- Relacionamos todas las tablas
SELECT f.title, f.film_id, fc.category_id, c.name
	FROM film AS f
    INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
        INNER JOIN category AS c
			ON fc.category_id = c.category_id;
            

-- Buscamos solo la categoría de 'Family'
SELECT f.title, f.film_id, fc.category_id, c.name
	FROM film AS f
    INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
        INNER JOIN category AS c
			ON fc.category_id = c.category_id
WHERE f.title = 'Family';            
            
-- No existe la película 'Family'. Pero existe Family sweet. Trabajo con esa
SELECT f.title, f.film_id, fc.category_id, c.name
	FROM film AS f
    INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
        INNER JOIN category AS c
			ON fc.category_id = c.category_id
WHERE f.title = 'Family sweet';           
		-- Es de la categoría Horror

-- Sacamos todas las películas de la misma categoría que 'Family sweet', que es Horror

SELECT f.title
	FROM film AS f
    INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
        INNER JOIN category AS c
			ON fc.category_id = c.category_id
            WHERE c.name = (SELECT  c1.name
								FROM film AS f1
								INNER JOIN film_category AS fc1
									ON f1.film_id = fc1.film_id
									INNER JOIN category AS c1
										ON fc1.category_id = c1.category_id
							WHERE f1.title = 'Family sweet');  
                            
-- ###### RESULTADO ########                            
-- Pero como el ejercicio pide de la película Family, pues, aunque de lista vacía, ahí va:
SELECT f.title
	FROM film AS f
    INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
        INNER JOIN category AS c
			ON fc.category_id = c.category_id
            WHERE c.name = (SELECT  c1.name
								FROM film AS f1			
								INNER JOIN film_category AS fc1
									ON f1.film_id = fc1.film_id
									INNER JOIN category AS c1
										ON fc1.category_id = c1.category_id
							WHERE f1.title = 'Family'); 
                            
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

-- Vemos las películas que tiene cada actor
SELECT CONCAT(a.first_name,' ',a.last_name) AS actores_con_mas_10_peliculas, COUNT(fa.film_id) AS conteo_peliculas
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;
-- 	Echando un vistazo, ningún actor tiene menos de 10 películas. Con lo que la lista definitiva debería
-- 	la misma longitud que esta.#### Por cierto, no se dónde se mira la longitud de la consulta ####

-- ###### RESULTADO ########  
-- Acotamos para los actores con más de 10 películas y solo mostramos sus nombres y apellidos, según nos piden
SELECT CONCAT(a.first_name,' ',a.last_name) AS actores_con_mas_10_peliculas
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id)>10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title, rating, length
	FROM film
    WHERE rating LIKE 'R' AND length >120;
    
-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos 
-- y muestra el nombre de la categoría junto con el promedio de duración.

-- Relaciones:	category ## name ## => (category_id) => film_category
-- 				film_category => (film_id) => film ## lengt>120 ##

-- Unimos las tablas 
SELECT c.name, c.category_id, fc.film_id, f.length
	FROM category AS c
		INNER JOIN film_category AS fc
			ON c.category_id = fc.category_id
            INNER JOIN film AS f
				ON fc.film_id = f.film_id;

-- ###### RESULTADO ########  
-- Agrupamos las duraciones de las películas por categorías y buscamos aquéllas categorías con promedios >120 min
SELECT c.name AS categoria , AVG(f.length) AS promedio_duracion
	FROM category AS c
		INNER JOIN film_category AS fc
			ON c.category_id = fc.category_id
            INNER JOIN film AS f
				ON fc.film_id = f.film_id
GROUP BY categoria
HAVING promedio_duracion>120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
-- cantidad de películas en las que han actuado.

-- Unimos las tablas para comprobar
SELECT CONCAT(a.first_name,' ',a.last_name) AS nombre_actor, film_id
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id;

-- ###### RESULTADO ########  
-- Agrupamos por nombre_actor para hacer conteo de películas y elegir los actores con 5 o mas películas
SELECT CONCAT(a.first_name,' ',a.last_name) AS nombre_actor, COUNT(film_id) AS total_peliculas
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY nombre_actor
-- 	Aquí ya he comprobado que no hay ningún actor que tenga menos de 5 películas. El que menos, tiene 14
HAVING COUNT(film_id)>5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
-- encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

-- Relaciones:	rental ## return_date - rental_date > 5 ## => (inventory_id) => inventory
-- 				inventory => (film_id) => film ## title ##

-- Hacemos la consulta que nos proporciona los id_inventory alquilados por mas de 5 días
SELECT r.rental_id, i.inventory_id, DATEDIFF(r.return_date, r.rental_date) AS dias_alquilada 
	-- Le he preguntado a la Chati como se hace diferencia entre fechas pq con '-' no funcionaba
	FROM rental AS r
    INNER JOIN inventory AS i
		ON r.inventory_id = i.inventory_id
        WHERE DATEDIFF(r.return_date, r.rental_date) >5;
			-- No se para qué se tiene que sacar el rental_id, pero ahí está
      
-- Buscamos las películas que el inventory_id esté en la consulta anterior
SELECT f.title, inventory_id
	FROM film AS f
    INNER JOIN inventory AS i
		ON f.film_id = i.film_id;
        
-- ###### RESULTADO ########            
-- Como la película aparece tantas veces repetida como número de inventario tiene, las vamos a agrupar por f.title
SELECT f.title
	FROM film AS f
    INNER JOIN inventory AS i
		ON f.film_id = i.film_id
			WHERE i.inventory_id IN (SELECT i1.inventory_id
									FROM rental AS r
									INNER JOIN inventory AS i1
										ON r.inventory_id = i1.inventory_id
										WHERE DATEDIFF(r.return_date, r.rental_date) >5)
GROUP BY f.film_id;

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
-- exclúyelos de la lista de actores.

-- Relaciones :	actor # nombre actor # => (actor_id) => film_actor
-- 				film_actor => (film_id) => film # contar películas #
-- 				film =>	(film_id) => film_category
-- 				film_category => (category_id) => category ## nombre categoria ##
		
-- Relacionamos las tablas
-- Buscamos actores que han trabajado en películas de Horror
        
SELECT a.actor_id AS actor, COUNT(f.title) as num_peliculas_Horror
	FROM actor AS a
		INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
			INNER JOIN film AS f
            ON fa.film_id = f.film_id
				INNER JOIN film_category AS fc
					ON fc.film_id = f.film_id
					INNER JOIN category AS c
					ON fc.category_id = c.category_id
					WHERE c.name = 'Horror'
GROUP BY a.actor_id
HAVING COUNT(f.title) >= 1;

-- ###### RESULTADO ########  
-- Vamos a listar todos los actores y excluimos los de la consulta anterior. 
-- Así tendremos los que no han trabajado en peliculas de Horror
SELECT CONCAT(a1.first_name,' ', a1.last_name) AS actor
	FROM actor AS a1
		WHERE a1.actor_id NOT IN (SELECT a.actor_id 
									FROM actor AS a
										INNER JOIN film_actor AS fa
										ON a.actor_id = fa.actor_id
											INNER JOIN film AS f
											ON fa.film_id = f.film_id
												INNER JOIN film_category AS fc
													ON fc.film_id = f.film_id
													INNER JOIN category AS c
													ON fc.category_id = c.category_id
													WHERE c.name = 'Horror'
								GROUP BY a.actor_id
								HAVING COUNT(f.title) >= 1);

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
-- tabla film.

-- Relaciones:	film ## title, length ## => (film_id) => film_category
-- 				film_category => (category_id) => category ## nombre ##

-- Buscamos todas las películas que tienen una duración > 180 min

SELECT title, length
	FROM film
    WHERE length > 180;

-- Buscamos los film_id que tienen categoria comedia

SELECT c.name, fc.film_id
	FROM category AS c
    INNER JOIN film_category AS fc
		ON c.category_id = fc.category_id
        WHERE c.name = 'comedy';
			-- Esta la vamos a usar de subconsulta de la otra

-- ###### RESULTADO ########  
SELECT title, length
	FROM film
    WHERE length > 180 AND film_id IN (	SELECT fc.film_id
										FROM category AS c
										INNER JOIN film_category AS fc
											ON c.category_id = fc.category_id
											WHERE c.name = 'comedy');

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
-- mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

-- Consultamos todos los actores y las pelicualas que han hecho

SELECT actor_id, film_id
	FROM film_actor;
   
    
-- Hacemos un Self join para ver qué actores han trabajado con qué actores
SELECT fa1.actor_id, fa1.film_id, fa2.actor_id
	FROM film_actor AS fa1
	INNER JOIN film_actor AS fa2
    ON fa1.film_id = fa2.film_id

				







        
	



                






	
        
        




   


    



        




    











    



    








