-- SESSION 4: ACID Transactions

BEGIN;

UPDATE product
SET price = price + 100
WHERE product_id = 101;

UPDATE product
SET price = price + 50
WHERE product_id = 102;

COMMIT;

-- ROLLBACK example
BEGIN;

UPDATE product
SET price = 999999
WHERE product_id = 101;

ROLLBACK;

-- SAVEPOINT example
BEGIN;

UPDATE product SET price = price + 10 WHERE product_id = 101;

SAVEPOINT before_second_update;

UPDATE product SET price = price + 20 WHERE product_id = 102;

ROLLBACK TO SAVEPOINT before_second_update;

COMMIT;

-- Isolation level
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM product;
COMMIT;

-- Advisory lock
BEGIN;
SELECT pg_advisory_xact_lock(12345);
COMMIT;
