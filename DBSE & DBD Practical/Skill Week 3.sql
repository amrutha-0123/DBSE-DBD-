-- SKILL SESSION 03: SQL — ADVANCED QUERYING
-- Covers DML, JOINs, subqueries, CTEs, aggregation,
-- window functions, CASE, JSON, and set operations.

CREATE DATABASE IF NOT EXISTS advanced_sql_db;
USE advanced_sql_db;

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200),
    category VARCHAR(100),
    price DECIMAL(10,2),
    published_year INT
);

INSERT INTO Books VALUES
(1, 'The Martian', 'Science Fiction', 499.00, 2014),
(2, 'Dune', 'Science Fiction', 599.00, 1965),
(3, 'Clean Code', 'Programming', 699.00, 2008),
(4, 'Atomic Habits', 'Self Help', 450.00, 2018),
(5, 'Project Hail Mary', 'Science Fiction', 650.00, 2021);

-- SELECT
SELECT * FROM Books;

-- UPDATE
UPDATE Books
SET price = price + 25
WHERE category = 'Programming';

-- JOIN-style self query example
SELECT a.title AS book1, b.title AS book2
FROM Books a
JOIN Books b ON a.category = b.category
WHERE a.book_id < b.book_id;

-- Subquery
SELECT title, price
FROM Books
WHERE price > (SELECT AVG(price) FROM Books);

-- CTE
WITH ScienceFictionBooks AS (
    SELECT *
    FROM Books
    WHERE category = 'Science Fiction'
)
SELECT title, price
FROM ScienceFictionBooks
ORDER BY price DESC;

-- GROUP BY and HAVING
SELECT category, COUNT(*) AS total_books, AVG(price) AS average_price
FROM Books
GROUP BY category
HAVING COUNT(*) >= 1;

-- Window functions
SELECT
    title,
    category,
    price,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS row_number_in_category,
    RANK() OVER (ORDER BY price DESC) AS price_rank
FROM Books;

-- CASE expression
SELECT
    title,
    price,
    CASE
        WHEN price >= 650 THEN 'Expensive'
        WHEN price >= 500 THEN 'Moderate'
        ELSE 'Affordable'
    END AS price_category
FROM Books;

-- Set operation
SELECT title FROM Books WHERE category = 'Science Fiction'
UNION
SELECT title FROM Books WHERE price > 600;
