-- DBMS ASSIGNMENT - SESSION 3
-- Session Outcome:
-- Develop advanced SQL queries using joins, subqueries, CTEs, aggregations and window functions.


-- ============================================================
-- FILE: 01_schema_and_data.sql
-- ============================================================

-- SESSION 3: Advanced SQL
-- Schema and sample data

DROP TABLE IF EXISTS order_item, orders, product, customer CASCADE;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    city TEXT
);

CREATE TABLE product (
    product_id INT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    price NUMERIC(10,2),
    metadata JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    order_date DATE,
    status TEXT
);

CREATE TABLE order_item (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES product(product_id),
    quantity INT,
    unit_price NUMERIC(10,2)
);

INSERT INTO customer VALUES
(1,'Asha','asha@example.com','Hyderabad'),
(2,'Ravi','ravi@example.com','Bengaluru'),
(3,'Maya','maya@example.com','Hyderabad');

INSERT INTO product VALUES
(101,'Keyboard','Accessories',1499,'{"brand":"KeyPro"}'),
(102,'Mouse','Accessories',799,'{"brand":"ClickPro"}'),
(103,'Monitor','Displays',12999,'{"brand":"ViewPro"}');

INSERT INTO orders VALUES
(1001,1,'2026-09-01','PAID'),
(1002,2,'2026-09-03','PAID'),
(1003,1,'2026-09-05','PENDING');

INSERT INTO order_item VALUES
(1,1001,101,2,1499),
(2,1001,102,1,799),
(3,1002,103,1,12999),
(4,1003,102,3,799);


-- ============================================================
-- FILE: 02_advanced_queries.sql
-- ============================================================

-- SESSION 3: 20 SQL queries

-- 1 SELECT
SELECT * FROM product;

-- 2 INSERT
INSERT INTO product VALUES
(104,'Webcam','Accessories',2499,'{"brand":"VisionPro"}');

-- 3 UPDATE
UPDATE product
SET price = price * 1.05
WHERE category = 'Accessories';

-- 4 DELETE
DELETE FROM product WHERE product_id = 104;

-- 5 INNER JOIN
SELECT o.order_id, c.name, o.status
FROM orders o
INNER JOIN customer c ON o.customer_id = c.customer_id;

-- 6 LEFT JOIN
SELECT c.name, o.order_id
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 7 RIGHT JOIN
SELECT c.name, o.order_id
FROM customer c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- 8 FULL JOIN
SELECT c.name, o.order_id
FROM customer c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

-- 9 CROSS JOIN
SELECT c.name, p.name
FROM customer c CROSS JOIN product p;

-- 10 SELF JOIN
SELECT c1.name AS customer1, c2.name AS customer2
FROM customer c1
JOIN customer c2 ON c1.customer_id < c2.customer_id;

-- 11 Subquery
SELECT name, price
FROM product
WHERE price > (SELECT AVG(price) FROM product);

-- 12 CTE
WITH customer_totals AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM orders o
    JOIN order_item oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT * FROM customer_totals;

-- 13 GROUP BY
SELECT category, COUNT(*) AS product_count
FROM product
GROUP BY category;

-- 14 HAVING
SELECT category, COUNT(*) AS product_count
FROM product
GROUP BY category
HAVING COUNT(*) >= 1;

-- 15 ROW_NUMBER
SELECT name, price,
       ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num
FROM product;

-- 16 RANK
SELECT category, name, price,
       RANK() OVER (
           PARTITION BY category
           ORDER BY price DESC
       ) AS price_rank
FROM product;

-- 17 LAG / LEAD
SELECT order_id, order_date,
       LAG(order_date) OVER (ORDER BY order_date) AS previous_order,
       LEAD(order_date) OVER (ORDER BY order_date) AS next_order
FROM orders;

-- 18 CASE
SELECT order_id,
       CASE
           WHEN status = 'PAID' THEN 'Completed'
           WHEN status = 'PENDING' THEN 'Awaiting Payment'
           ELSE 'Other'
       END AS status_label
FROM orders;

-- 19 JSONB
SELECT name, metadata ->> 'brand' AS brand
FROM product;

-- 20 UNION / INTERSECT / EXCEPT
SELECT city FROM customer WHERE city = 'Hyderabad'
UNION
SELECT city FROM customer WHERE city = 'Bengaluru';

SELECT city FROM customer
INTERSECT
SELECT city FROM customer WHERE city LIKE 'H%';

SELECT city FROM customer
EXCEPT
SELECT city FROM customer WHERE city = 'Hyderabad';

-- Parameterised query example:
-- SELECT * FROM orders WHERE customer_id = $1;

