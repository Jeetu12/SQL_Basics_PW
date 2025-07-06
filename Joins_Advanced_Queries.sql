-- Q9: Movie title and customer's first/last name who rented it (multiple joins)
SELECT f.title, c.first_name, c.last_name
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN customer AS c ON r.customer_id = c.customer_id;

-- Q10: Actors in film "Gone with the Wind"
SELECT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- Q11: Customer names and total spent on rentals (JOIN + SUM + GROUP BY)
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q12: Movie titles rented by each customer in a given city (e.g., London)
/* Uses joins across customer, address, city, rental, inventory, film */
SELECT DISTINCT ci.city, c.first_name, c.last_name, f.title
FROM customer AS c
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS ci ON a.city_id = ci.city_id
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON r.inventory_id = i.inventory_id
JOIN film AS f ON i.film_id = f.film_id
WHERE ci.city = 'London';

-- Q13: Top 5 rented movies with count (JOIN + COUNT + GROUP BY + ORDER + LIMIT)
SELECT f.title, COUNT(r.rental_id) AS times_rented
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY times_rented DESC
LIMIT 5;

-- Q14: Customers who rented from both store 1 and 2
SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON r.inventory_id = i.inventory_id
WHERE i.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;
