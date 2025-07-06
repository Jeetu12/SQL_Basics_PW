-- Q1: Primary keys vs. foreign keys in MavenMovies (conceptual)
/*
Primary keys uniquely identify table rows (e.g., actor_id in actor table).
Foreign keys link tables by referencing primary keys (e.g., film_actor.actor_id references actor.actor_id).
PKs enforce entity integrity (no duplicates, no NULLs), while FKs enforce referential integrity.
*/

-- Q2: List all details of actors
SELECT * FROM actor;

-- Q3: List all customer information
SELECT * FROM customer;

-- Q4: List different countries (distinct)
SELECT DISTINCT country FROM country;

-- Q5: Display all active customers
SELECT * FROM customer
WHERE active = 1;  -- assuming 'active' flag (1=active)

-- Q6: Rental IDs for customer with ID 1
SELECT rental_id FROM rental
WHERE customer_id = 1;

-- Q7: Films with rental duration > 5
SELECT title FROM film
WHERE rental_duration > 5;

-- Q8: Number of films with replacement cost > 15 and < 20
SELECT COUNT(*) AS film_count
FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- Q9: Count of unique first names of actors
SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM actor;

-- Q10: First 10 records from customer table
SELECT * FROM customer
LIMIT 10;

-- Q11: First 3 customers whose first name starts with 'b'
SELECT * FROM customer
WHERE first_name LIKE 'b%'
LIMIT 3;

-- Q12: Names of first 5 movies rated 'G'
SELECT title FROM film
WHERE rating = 'G'
LIMIT 5;

-- Q13: Customers whose first name starts with 'a'
SELECT * FROM customer
WHERE first_name LIKE 'a%';

-- Q14: Customers whose first name ends with 'a'
SELECT * FROM customer
WHERE first_name LIKE '%a';

-- Q15: First 4 cities starting and ending with 'a'
SELECT city FROM city
WHERE city LIKE 'a%a'
LIMIT 4;

-- Q16: Customers with 'NI' in their first name
SELECT * FROM customer
WHERE first_name LIKE '%NI%';

-- Q17: Customers with 'r' as second letter of first name
SELECT * FROM customer
WHERE first_name LIKE '_r%';

-- Q18: Customers whose first name starts with 'a' and length >= 5
SELECT * FROM customer
WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;

-- Q19: Customers whose first name starts with 'a' and ends with 'o'
SELECT * FROM customer
WHERE first_name LIKE 'a%o';

-- Q20: Films with rating PG or PG-13 using IN operator
SELECT * FROM film
WHERE rating IN ('PG', 'PG-13');

-- Q21: Films with length between 50 and 100
SELECT * FROM film
WHERE length BETWEEN 50 AND 100;

-- Q22: Top 50 actors (first 50 records)
SELECT * FROM actor
LIMIT 50;

-- Q23: Distinct film IDs from inventory table
SELECT DISTINCT film_id FROM inventory;
