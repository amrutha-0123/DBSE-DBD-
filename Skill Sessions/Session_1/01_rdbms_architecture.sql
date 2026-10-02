-- SESSION 1: RDBMS Architecture & Data Independence
-- PostgreSQL SQL practical

DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    product_id INT REFERENCES products(product_id),
    quantity INT CHECK (quantity > 0)
);

INSERT INTO users (name, email) VALUES
('Asha', 'asha@example.com'),
('Ravi', 'ravi@example.com');

INSERT INTO products (name, price) VALUES
('Keyboard', 1499),
('Mouse', 799);

INSERT INTO orders (user_id, product_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1);

-- View the catalog/data dictionary
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'users';

-- Frontend mock data mapped to relational entities:
-- users    -> users
-- products -> products
-- orders   -> orders
