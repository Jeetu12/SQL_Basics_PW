-- 1. Rank customers by total spending (window function RANK)
WITH cust_spend AS (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
    FROM customer AS c
    JOIN payment AS p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM cust_spend;

-- 2. Cumulative revenue by each film over time (running sum by film)
WITH film_rentals AS (
    SELECT f.film_id, f.title, r.rental_date, f.rental_rate
    FROM film AS f
    JOIN inventory AS i ON f.film_id = i.film_id
    JOIN rental AS r ON i.inventory_id = r.inventory_id
)
SELECT film_id, title, rental_date,
       SUM(rental_rate) OVER (PARTITION BY film_id ORDER BY rental_date
                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                             ) AS cumulative_revenue
FROM film_rentals
ORDER BY film_id, rental_date;

-- 3. Average rental duration for each film among films of same length (window function)
SELECT film_id, title, length, rental_duration,
       AVG(rental_duration) OVER (PARTITION BY length) AS avg_duration_same_length
FROM film;

-- 4. Top 3 films in each category by rental count (window function RANK)
WITH film_rents AS (
    SELECT f.film_id, f.title, c.name AS category, COUNT(r.rental_id) AS rent_count
    FROM film AS f
    JOIN film_category AS fc ON f.film_id = fc.film_id
    JOIN category AS c ON fc.category_id = c.category_id
    JOIN inventory AS i ON f.film_id = i.film_id
    JOIN rental AS r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title, c.category_id, c.name
)
SELECT category, title, rent_count
FROM (
    SELECT category, title, rent_count,
           RANK() OVER (PARTITION BY category ORDER BY rent_count DESC) AS rk
    FROM film_rents
) AS ranked
WHERE rk <= 3;

-- 5. Difference in rental count between each customer and average (window function)
SELECT customer_id, rentals_count,
       rentals_count - AVG(rentals_count) OVER () AS diff_from_avg
FROM (
    SELECT customer_id, COUNT(*) AS rentals_count
    FROM rental
    GROUP BY customer_id
) AS cust_counts;

-- 6. Monthly revenue trend (GROUP BY Year, Month)
SELECT YEAR(payment_date) AS year, MONTH(payment_date) AS month, SUM(amount) AS total_revenue
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY year, month;

-- 7. Customers in top 20% by total spending (window function PERCENT_RANK)
SELECT customer_id, first_name, last_name, total_spent
FROM (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent,
           PERCENT_RANK() OVER (ORDER BY SUM(p.amount) DESC) AS pr
    FROM customer AS c
    JOIN payment AS p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) AS ranked
WHERE pr <= 0.20;

-- 8. Running total of rentals per category ordered by count (window SUM)
WITH cat_rentals AS (
    SELECT c.name AS category, COUNT(r.rental_id) AS rentals_count
    FROM category AS c
    JOIN film_category AS fc ON c.category_id = fc.category_id
    JOIN inventory AS i ON fc.film_id = i.film_id
    JOIN rental AS r ON i.inventory_id = r.inventory_id
    GROUP BY c.category_id, c.name
)
SELECT category, rentals_count,
       SUM(rentals_count) OVER (ORDER BY rentals_count DESC
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                               ) AS running_total
FROM cat_rentals;

-- 9. Films rented less than average for their category
WITH film_rentals AS (
    SELECT f.film_id, f.title, fc.category_id, c.name AS category, COUNT(r.rental_id) AS rent_count
    FROM film AS f
    JOIN film_category AS fc ON f.film_id = fc.film_id
    JOIN category AS c ON fc.category_id = c.category_id
    LEFT JOIN inventory AS i ON f.film_id = i.film_id
    LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title, fc.category_id, c.name
),
category_avg AS (
    SELECT category_id, AVG(rent_count) AS avg_rentals
    FROM film_rentals
    GROUP BY category_id
)
SELECT fr.category, fr.title, fr.rent_count
FROM film_rentals AS fr
JOIN category_avg AS ca ON fr.category_id = ca.category_id
WHERE fr.rent_count < ca.avg_rentals;

-- 10. Top 5 months with highest revenue
SELECT YEAR(payment_date) AS year, MONTH(payment_date) AS month, SUM(amount) AS total_revenue
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY total_revenue DESC
LIMIT 5;
