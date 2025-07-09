-- Normalization Questions (explanations in comments):

/*
1. First Normal Form (1NF):
   A table is in 1NF if all columns contain atomic (indivisible) values, with no repeating groups:contentReference[oaicite:5]{index=5}.
   In Sakila, all tables already use atomic columns, so 1NF is satisfied.
   If a table had a column with multiple values (e.g., a CSV list), it would violate 1NF.
   To normalize, split those multi-valued attributes into a separate table.
   (Example: if a film had a column 'actors' listing many actors, we'd create a film_actor table.)

2. Second Normal Form (2NF):
   A table is in 2NF if it is in 1NF and no non-key attribute depends on part of a composite key:contentReference[oaicite:6]{index=6}.
   Since Sakila tables typically use single-column primary keys, 2NF issues rarely occur.
   If a table had a composite PK and some column only depended on part of it, we would remove that column to a new table.
   (Example: If an order_items table had (order_id, product_id) as PK, but 'order_date' depended only on order_id, move 'order_date' to orders table.)

3. Third Normal Form (3NF):
   A table is in 3NF if it is in 2NF and no non-key attribute depends on another non-key attribute (no transitive dependency):contentReference[oaicite:7]{index=7}.
   This means every non-key column should depend only on the primary key.
   If Sakila had, say, a table where City -> Country, storing country directly, that would violate 3NF.
   To normalize, we would split the table so that City and Country are in separate tables, removing the transitive dependency.

4. Normalization Process Example:
   Suppose we have an unnormalized "Orders" table with OrderID, CustomerInfo (name, email), and a comma-separated list of items.
   - To achieve 1NF: split the items list into separate rows in an order_items table.
   - To achieve 2NF: if Order had a composite key (OrderID, ItemID) and OrderDate depended only on OrderID, move OrderDate to Orders table.
   - (Sakila's design is already normalized up to 3NF in practice.)
*/

-- CTE Queries:

-- 5. CTE Basics: a distinct list of actor names and film count
WITH actor_films AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
    FROM actor AS a
    JOIN film_actor AS fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT first_name, last_name, film_count
FROM actor_films;

-- 6. CTE with Joins: film title, language name, and rental rate
WITH film_lang AS (
    SELECT f.title, l.name AS language_name, f.rental_rate
    FROM film AS f
    JOIN language AS l ON f.language_id = l.language_id
)
SELECT * FROM film_lang;

-- 7. CTE for Aggregation: total revenue per customer
WITH customer_revenue AS (
    SELECT customer_id, SUM(amount) AS total_revenue
    FROM payment
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, cr.total_revenue
FROM customer AS c
JOIN customer_revenue AS cr ON c.customer_id = cr.customer_id;

-- 8. CTE with Window Function: rank films by rental_duration
WITH film_durations AS (
    SELECT film_id, title, rental_duration
    FROM film
)
SELECT film_id, title, rental_duration,
       RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
FROM film_durations;

-- 9. CTE and Filtering: customers with more than two rentals
WITH frequent_customers AS (
    SELECT customer_id, COUNT(*) AS rentals_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > 2
)
SELECT c.customer_id, c.first_name, c.last_name, fc.rentals_count
FROM customer AS c
JOIN frequent_customers AS fc ON c.customer_id = fc.customer_id;

-- 10. CTE for Date Calculations: total rentals per month
WITH monthly_rentals AS (
    SELECT YEAR(rental_date) AS yr, MONTH(rental_date) AS mon, COUNT(*) AS rentals_count
    FROM rental
    GROUP BY YEAR(rental_date), MONTH(rental_date)
)
SELECT yr, mon, rentals_count
FROM monthly_rentals;

-- 11. CTE and Self-Join: pairs of actors in the same film
WITH actor_pairs AS (
    SELECT fa1.film_id, fa1.actor_id AS actor1_id, fa2.actor_id AS actor2_id
    FROM film_actor AS fa1
    JOIN film_actor AS fa2
      ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT f.title,
       a1.first_name AS actor1_first, a1.last_name AS actor1_last,
       a2.first_name AS actor2_first, a2.last_name AS actor2_last
FROM actor_pairs AS ap
JOIN film AS f ON ap.film_id = f.film_id
JOIN actor AS a1 ON ap.actor1_id = a1.actor_id
JOIN actor AS a2 ON ap.actor2_id = a2.actor_id;

-- 12. Recursive CTE: find all staff reporting to a manager (using reports_to)
WITH RECURSIVE subordinates AS (
    SELECT staff_id, first_name, last_name, reports_to
    FROM staff
    WHERE reports_to = 2   -- starting manager (e.g., manager_id = 2)
    UNION ALL
    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
    FROM staff AS s
    JOIN subordinates AS sb ON s.reports_to = sb.staff_id
)
SELECT * FROM subordinates;
