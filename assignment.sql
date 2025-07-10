-- SQL Basics Assignment Answers (all in one)

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

-- Q2: Explain the purpose of constraints and examples
/* 
Constraints enforce rules on data to maintain integrity.
They prevent invalid or inconsistent data entries:contentReference[oaicite:0]{index=0}. 
Common constraints include:
    - PRIMARY KEY: uniquely identifies each row (no NULLs, unique):contentReference[oaicite:1]{index=1}.
    - FOREIGN KEY: ensures referential integrity between tables.
    - UNIQUE: no duplicate values in a column.
    - NOT NULL: disallows NULL entries in a column.
    - CHECK: enforces a boolean condition (e.g., age >= 18).
These rules ensure data accuracy and follow business rules:contentReference[oaicite:2]{index=2}.
*/

-- Q3: NOT NULL constraint, and NULLs in primary key
/* 
Applying NOT NULL ensures that a column always has a value (i.e., no missing data). 
A primary key implicitly has NOT NULL; it cannot contain NULL values. 
Primary keys uniquely identify rows, so allowing NULL (no identity) would break uniqueness:contentReference[oaicite:3]{index=3}.
Thus, by definition, a primary key cannot be NULL:contentReference[oaicite:4]{index=4}.
*/

-- Q4: Add or remove constraints on the existing table
/*
To add a constraint: use ALTER TABLE ... ADD CONSTRAINT. 
Example: Make product_id a primary key:
    ALTER TABLE products ADD PRIMARY KEY (product_id);
To set a default on price:
    ALTER TABLE products ALTER COLUMN price SET DEFAULT 50.00;
To remove a constraint: use ALTER TABLE ... DROP CONSTRAINT (name).
Example: DROP CONSTRAINT products_price_default (if named).
These commands modify table definitions without dropping the table.
*/

-- Q5: Violating constraints consequences
/*
If you violate a constraint (e.g., insert a duplicate primary key or NULL into NOT NULL), 
the database throws an error and rejects the change. For example:
    INSERT INTO employees(emp_id, emp_name) VALUES (1, 'Alice'); 
    INSERT INTO employees(emp_id, emp_name) VALUES (1, 'Bob');
The second insert fails with the error: 
    "ERROR: duplicate key value violates unique constraint" 
(or "NULL value in column 'emp_name' violates NOT NULL constraint" if NULL).
This prevents invalid data from being stored.
*/

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

DROP TABLE IF EXISTS Students;
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    class_id INT
);
INSERT INTO Students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

DROP TABLE IF EXISTS Classes;
CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL
);
INSERT INTO Classes (class_id, class_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

SELECT s.student_name, c.class_name
FROM Students s
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

SELECT 
    p.order_id,
    c.customer_name,
    p.product_name
FROM 
    Products p
LEFT JOIN Orders o ON p.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;


-- 9. Total sales per Products

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert into Products
INSERT INTO Products (product_id, product_name) VALUES
(101, 'Laptop'),
(102, 'Phone');

-- Insert into Sales
INSERT INTO Sales (sale_id, product_id, amount) VALUES
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);

SELECT 
    p.product_name,
    SUM(s.amount) AS total_sales
FROM 
    Sales s
INNER JOIN Products p ON s.product_id = p.product_id
GROUP BY 
    p.product_name;


-- 10. Order quantities per Customers
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
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

DROP TABLE IF EXISTS Orders_Details;
CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert into Customers
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Insert into Orders
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

-- Insert into Order_Details
INSERT INTO Order_Details (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

SELECT 
    o.order_id,
    c.customer_name,
    od.quantity
FROM 
    Order_Details od
INNER JOIN Orders o ON od.order_id = o.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id;


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

-- Functions: Basic Aggregate Functions:-

SELECT COUNT(*) 
FROM rental;

SELECT AVG(rental_duration) 
FROM rental;

SELECT UPPER(first_name), UPPER(last_name) 
FROM customer;

SELECT rental_id, MONTH(rental_date) 
FROM rental;

SELECT customer_id, COUNT(*) 
FROM rental 
GROUP BY customer_id;

SELECT store_id, SUM(amount) 
FROM payment 
GROUP BY store_id;

SELECT fc.category_id, COUNT(*) 
FROM film_category fc
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY fc.category_id;

SELECT language_id, AVG(rental_rate) 
FROM film 
GROUP BY language_id;

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

-- 5. Difference in rental count from the average per customer
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
