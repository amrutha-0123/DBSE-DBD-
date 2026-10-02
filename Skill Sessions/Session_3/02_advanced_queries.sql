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
