-- DBMS ASSIGNMENT - SESSION 4
-- Session Outcome:
-- Implement ACID transactions, stored procedures, triggers and views.


-- ============================================================
-- FILE: 01_transactions.sql
-- ============================================================

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


-- ============================================================
-- FILE: 02_functions_triggers_views.sql
-- ============================================================

-- SESSION 4: Functions, Trigger, Audit Log and View

CREATE TABLE IF NOT EXISTS audit_log (
    audit_id BIGSERIAL PRIMARY KEY,
    table_name TEXT,
    operation TEXT,
    row_id TEXT,
    changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION audit_product_change()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log(table_name, operation, row_id)
    VALUES (
        'product',
        TG_OP,
        COALESCE(NEW.product_id, OLD.product_id)::TEXT
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS product_audit_trigger ON product;

CREATE TRIGGER product_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON product
FOR EACH ROW
EXECUTE FUNCTION audit_product_change();

CREATE OR REPLACE FUNCTION get_product_count()
RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(*) INTO total FROM product;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW paid_orders AS
SELECT o.order_id, c.name, o.order_date
FROM orders o
JOIN customer c ON c.customer_id = o.customer_id
WHERE o.status = 'PAID';

SELECT get_product_count();

SELECT * FROM paid_orders;

SELECT * FROM audit_log;

