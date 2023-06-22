#Here is the number of copies of the film Hunchback Impossible exist in the inventory system?

SELECT
count(*) 
FROM inventory i
JOIN film f ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible";

#Here is the list of all films whose length is longer than the average of all the films.

SELECT *
FROM film
WHERE length > (SELECT AVG(length) FROM film);

#Here are all actors who appear in the film Alone Trip.

SELECT
    fa.actor_id,
    (	SELECT first_name
        FROM actor
        WHERE actor_id = fa.actor_id) AS first_name,
    (	SELECT last_name
        FROM actor
        WHERE actor_id = fa.actor_id) AS last_name
FROM film_actor fa
JOIN film f ON f.film_id = fa.film_id
WHERE f.title = "Alone Trip";

#Here are all movies categorized as family films.

SELECT
    fc.film_id,
    (SELECT title
	 FROM film
	 WHERE film_id = fc.film_id) AS title,
    (SELECT name
	 FROM category
	 WHERE category_id = fc.category_id) AS category
FROM film_category fc
WHERE fc.category_id = (
    SELECT category_id
    FROM category
    WHERE name = 'Family');

#Here are the name and email from customers from Canada using subqueries.

SELECT
	first_name,
    last_name
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE country_id = (
			SELECT country_id
			FROM country
			WHERE country = 'Canada'))
);

#Here are the name and email from customers from Canada using join

SELECT 
	c.first_name,
    c.last_name
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
WHERE co.country = 'Canada';


#Here are the films starred by the most prolific actor

SELECT
	title
FROM film
WHERE film_id IN (
	SELECT 
		fa2.film_id
	FROM film_actor fa2
	WHERE fa2.actor_id = (
		SELECT
			fa.actor_id
		FROM film_actor fa
		GROUP BY fa.actor_id
		ORDER BY count(fa.actor_id) DESC
		LIMIT 1)); 

#Here are the films rented by most profitable customer.
SELECT
	f.title
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE r.customer_id = (
	SELECT
		p.customer_id
	FROM payment p
	GROUP BY p.customer_id
	ORDER BY sum(amount) DESC
	LIMIT 1)
;

#Here is the list of client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT
customer_id,
SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
SELECT
AVG(total_amount) AS average_amount
FROM (
SELECT
p2.customer_id,
SUM(p2.amount) AS total_amount
FROM payment p2
GROUP BY p2.customer_id
) subquery
)
ORDER BY total_amount DESC;

