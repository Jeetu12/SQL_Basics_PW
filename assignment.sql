-- SQL Basics Assignment Answers

-- 1. Create the employees table

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  emp_id   INT            NOT NULL,
  emp_name VARCHAR(100)   NOT NULL,
  age      INT            CHECK (age >= 18),
  email    VARCHAR(255)   UNIQUE,
  salary   DECIMAL(10,2)  DEFAULT 30000,
  PRIMARY KEY (emp_id)
 ) ENGINE=InnoDB;

-- 2. Purpose of constraints & examples
-- (Explained in written document – not applicable to .sql script)

-- 3. NOT NULL usage & primary key nullability
-- (Explained in written document – not applicable to .sql script)

-- 4. Add and remove a CHECK constraint on employees.age
ALTER TABLE employees
  ADD CONSTRAINT chk_age_min CHECK (age >= 18);

ALTER TABLE employees
  DROP CHECK chk_age_min;

-- 5. Consequences of constraint violations
-- (Explained in written document – not applicable to .sql script)

-- 6. Modify the products table: add a primary key and a default price

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2)
);

ALTER TABLE products
  ADD PRIMARY KEY (product_id),
  MODIFY COLUMN price DECIMAL(10,2) DEFAULT 50.00;

-- 7. INNER JOIN: student_name and class_name

DROP TABLE IF EXISTS students;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    class_id INT
);
INSERT INTO students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

DROP TABLE IF EXISTS classes;
CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL
);
INSERT INTO classes (class_id, class_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

SELECT s.student_name, c.class_name
FROM students s
INNER JOIN classes c ON s.class_id = c.class_id;

-- 8. LEFT JOIN: products with customer and order info

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert into Customers
INSERT INTO Customers (customer_id, customer_name) VALUES
(101, 'Alice'),
(102, 'Bob');

-- Insert into Orders
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-01', 101),
(2, '2024-01-03', 102);

-- Insert into Products
INSERT INTO Products (product_id, product_name, order_id) VALUES
(1, 'Laptop', 1),
(2, 'Phone', NULL);

SELECT p.product_id, p.product_name, o.order_id, c.customer_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id;

-- 9. Total sales per product

DROP TABLE IF EXISTS products1;
CREATE TABLE products1 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert into products
INSERT INTO products1 (product_id, product_name) VALUES
(101, 'Laptop'),
(102, 'Phone');

-- Insert into sales
INSERT INTO sales (sale_id, product_id, amount) VALUES
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);


SELECT p.product_id, p.product_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products1 p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- 10. Order quantities per customer

DROP TABLE IF EXISTS customers1;
CREATE TABLE customers1 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS orders1;
CREATE TABLE orders1 (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

DROP TABLE IF EXISTS orders_details;
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert into customers1
INSERT INTO customers1 (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Insert into orders1
INSERT INTO orders1 (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

-- Insert into order_details
INSERT INTO order_details (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

SELECT o.order_id, c.customer_name, SUM(oi.quantity) AS total_quantity
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name;

--

-- Mavenmovies Database SQL Queries

-- 1. List primary keys and foreign keys
SELECT
  tc.TABLE_NAME,
  tc.CONSTRAINT_TYPE,
  kcu.COLUMN_NAME
FROM information_schema.TABLE_CONSTRAINTS tc
JOIN information_schema.KEY_COLUMN_USAGE kcu
  ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_SCHEMA = DATABASE()
  AND tc.CONSTRAINT_TYPE IN ('PRIMARY KEY', 'FOREIGN KEY');

-- 2. All actors
SELECT * FROM actor;

-- 3. All customers
SELECT * FROM customer;

-- 4. Distinct countries
SELECT DISTINCT country FROM country;

-- 5. Active customers
SELECT * FROM customer WHERE active = 1;

-- 6. Rentals by customer_id = 1
SELECT rental_id FROM rental WHERE customer_id = 1;

-- 7. Films with rental_duration > 5
SELECT * FROM film WHERE rental_duration > 5;
-- note: There is no column with rental_duration in the table rental.

-- 8. Count of films with replacement cost between 15 and 20
SELECT COUNT(*) FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- 9. Unique actor first names
SELECT COUNT(DISTINCT first_name) FROM actor;

-- 10. First 10 customers
SELECT * FROM customer LIMIT 10;

-- 11. Customers starting with 'b'
SELECT * FROM customer WHERE first_name LIKE 'b%' LIMIT 3;

-- 12. First 5 'G' rated movies
SELECT title FROM film WHERE rating = 'G' LIMIT 5;

-- 13. Customers with first_name starting 'a'
SELECT * FROM customer WHERE first_name LIKE 'a%';

-- 14. Customers with first_name ending 'a'
SELECT * FROM customer WHERE first_name LIKE '%a';

-- 15. Cities starting and ending with 'a'
SELECT city FROM city WHERE city LIKE 'a%' AND city LIKE '%a' LIMIT 4;

-- 16. Customers with 'NI' in name
SELECT * FROM customer WHERE first_name LIKE '%NI%';

-- 17. Customers with second char as 'r'
SELECT * FROM customer WHERE first_name LIKE '_r%';

-- 18. Customers starting with 'a' and name length >= 5
SELECT * FROM customer WHERE first_name LIKE 'a%' AND CHAR_LENGTH(first_name) >= 5;

-- 19. Customers starting with 'a' and ending with 'o'
SELECT * FROM customer WHERE first_name LIKE 'a%o';

-- 20. Films with rating in ('PG', 'PG-13')
SELECT * FROM film WHERE rating IN ('PG','PG-13');

-- 21. Films with length between 50 and 100
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

-- 22. First 50 actors
SELECT * FROM actor LIMIT 50;

-- 23. Distinct film_ids from inventory
SELECT DISTINCT film_id FROM inventory;

-- Aggregations
SELECT COUNT(*) FROM rental;
SELECT AVG(rental_duration) FROM rental;
SELECT UPPER(first_name), UPPER(last_name) FROM customer;
SELECT rental_id, MONTH(rental_date) FROM rental;
SELECT customer_id, COUNT(*) FROM rental GROUP BY customer_id;
SELECT store_id, SUM(amount) FROM payment GROUP BY store_id;
SELECT fc.category_id, COUNT(*) FROM film_category fc
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY fc.category_id;
SELECT language_id, AVG(rental_rate) FROM film GROUP BY language_id;

-- Joins
SELECT f.title, c.first_name, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;

SELECT a.*
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

SELECT c.customer_id, c.first_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

SELECT DISTINCT c.customer_id, c.first_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London';

-- Advanced
SELECT f.title, COUNT(*) AS times_rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY times_rented DESC
LIMIT 5;

SELECT customer_id
FROM rental
GROUP BY customer_id
HAVING COUNT(DISTINCT store_id) = 2;

--

-- Window Function Queries for MavenMovies (MySQL 8+)

-- 1. Rank the customers based on total amount spent
SELECT customer_id, SUM(amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM payment
GROUP BY customer_id;

-- 2. Cumulative revenue per film over time
SELECT f.film_id, f.title, r.rental_date, SUM(p.amount) OVER (
         PARTITION BY f.film_id ORDER BY r.rental_date
       ) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id;

-- 3. Average rental duration for films with similar length
SELECT film_id, title, length, rental_duration,
       AVG(rental_duration) OVER (PARTITION BY length) AS avg_rental_duration_by_length
FROM film;

-- 4. Top 3 films in each category by rental count
SELECT *
FROM (
  SELECT c.name AS category, f.title, COUNT(r.rental_id) AS rental_count,
         RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS rank_in_category
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f ON fc.film_id = f.film_id
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY c.name, f.title
) ranked
WHERE rank_in_category <= 3;

-- 5. Difference in rental count from average per customer
WITH rental_stats AS (
  SELECT customer_id, COUNT(*) AS rental_count
  FROM rental
  GROUP BY customer_id
),
avg_val AS (
  SELECT AVG(rental_count) AS avg_count FROM rental_stats
)
SELECT r.customer_id, r.rental_count, a.avg_count,
       r.rental_count - a.avg_count AS difference_from_avg
FROM rental_stats r CROSS JOIN avg_val a;

-- 6. Monthly revenue trend
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
       SUM(amount) AS total_revenue,
       SUM(SUM(amount)) OVER (ORDER BY DATE_FORMAT(payment_date, '%Y-%m')) AS running_total
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m');

-- 7. Top 20% of customers by total spending
WITH ranked_customers AS (
  SELECT customer_id, SUM(amount) AS total_spent,
         PERCENT_RANK() OVER (ORDER BY SUM(amount)) AS perc_rank
  FROM payment
  GROUP BY customer_id
)
SELECT * FROM ranked_customers
WHERE perc_rank >= 0.8;

-- 8. Running total of rentals per category by rental count
SELECT c.name AS category, COUNT(r.rental_id) AS rental_count,
       SUM(COUNT(r.rental_id)) OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id)) AS running_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- 9. Films rented less than average in their category
WITH film_rentals AS (
  SELECT f.film_id, f.title, c.name AS category, COUNT(r.rental_id) AS rental_count
  FROM film f
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY f.film_id, f.title, c.name
),
avg_cat AS (
  SELECT category, AVG(rental_count) AS avg_rentals
  FROM film_rentals
  GROUP BY category
)
SELECT f.*
FROM film_rentals f
JOIN avg_cat a ON f.category = a.category
WHERE f.rental_count < a.avg_rentals;

-- 10. Top 5 revenue months
WITH monthly_revenue AS (
  SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
         SUM(amount) AS revenue
  FROM payment
  GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
)
SELECT * FROM (
  SELECT *, RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
  FROM monthly_revenue
) ranked
WHERE revenue_rank <= 5;
