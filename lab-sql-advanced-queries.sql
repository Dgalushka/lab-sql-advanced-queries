use sakila;
-- 1. List each pair of actors that have worked together

SELECT * FROM film_actor;

select count(*) from film_actor;

SELECT fa1.actor_id AS actor_id_1, fa1.film_id AS film_id, fa2.actor_id AS actor_id_2
FROM film_actor fa1 
JOIN film_actor fa2 
ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id;

-- 2. For each film, list actor that has acted in more films

-- step 1. I was able to select amount of films acted for each actor_id per each film_id.

WITH cte_films_acted AS (
	SELECT actor_id, count(distinct film_id) films_acted FROM film_actor
	GROUP BY actor_id
) 
SELECT * FROM (
 SELECT film_id, actor_id, films_acted  FROM film_actor FA1
 JOIN cte_films_acted USING (actor_id)
WHERE film_id = FA1.film_id
) a1
ORDER BY film_id, films_acted desc; 
 
 -- Could not think of better way to do it, so just ordered DESC films_acted column and then counted rows per each film_id, selected only rn 1 from each film_id
 
 WITH cte_films_acted AS (
    SELECT actor_id, COUNT(DISTINCT film_id) AS films_acted
    FROM film_actor
    GROUP BY actor_id
)
SELECT film_id, actor_id, films_acted
FROM (
    SELECT film_id, actor_id, films_acted,
           ROW_NUMBER() OVER (PARTITION BY film_id ORDER BY films_acted DESC) AS rn
    FROM (
        SELECT film_id, actor_id, films_acted
        FROM film_actor FA1
        JOIN cte_films_acted USING (actor_id)
        ORDER BY film_id, films_acted DESC
    ) a
) a1
WHERE rn = 1;



