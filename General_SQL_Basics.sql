-- Q1: Create a table employees with constraints
CREATE TABLE employees (
    emp_id INT PRIMARY KEY NOT NULL,  -- emp_id is primary key and NOT NULL
    emp_name TEXT NOT NULL,           -- emp_name cannot be NULL
    age INT CHECK (age >= 18),        -- age must be at least 18
    email TEXT UNIQUE,               -- email must be unique across employees
    salary DECIMAL DEFAULT 30000     -- default salary is 30000
);

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

-- Q6: Alter table to add constraints (product_id PK, price default 50.00)
ALTER TABLE products
    ADD PRIMARY KEY (product_id);  -- Make product_id the primary key

ALTER TABLE products
    ALTER COLUMN price SET DEFAULT 50.00;  -- Set default price to 50.00

-- Q7: Join example – student_name and class_name from two tables
SELECT s.student_name, c.class_name
FROM Students AS s
JOIN Classes AS c
    ON s.class_id = c.class_id;

-- Q8: Left join example – list all products with orders
SELECT o.order_id, c.customer_name, p.product_name
FROM Products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
LEFT JOIN Orders AS o
    ON oi.order_id = o.order_id
LEFT JOIN Customers AS c
    ON o.customer_id = c.customer_id;

-- Q9: Total sales amount per product using INNER JOIN and SUM()
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items AS oi
JOIN Products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- Q10: Orders and quantity by customer using INNER JOIN
SELECT o.order_id, c.customer_name, od.quantity
FROM Orders AS o
JOIN Customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS od
    ON o.order_id = od.order_id;
