-- DBMS ASSIGNMENT - SESSION 2
-- Session Outcome:
-- Construct ER diagrams with entities, attributes, relationships, cardinalities and map them into relational tables.


-- ============================================================
-- FILE: 01_create_er_tables.sql
-- ============================================================

-- SESSION 2: ER Model & ER-to-Relational Mapping

DROP TABLE IF EXISTS payment, order_item, orders, product, address, customer CASCADE;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE product (
    product_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    customer_id INT NOT NULL REFERENCES customer(customer_id)
);

CREATE TABLE order_item (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    product_id INT NOT NULL REFERENCES product(product_id),
    quantity INT CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY,
    order_id INT UNIQUE REFERENCES orders(order_id),
    amount NUMERIC(10,2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL
);

CREATE TABLE address (
    address_id INT PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customer(customer_id),
    address_line VARCHAR(200),
    city VARCHAR(80),
    pincode VARCHAR(10)
);

-- Cardinalities:
-- Customer 1:N Order
-- Order 1:N OrderItem
-- Product 1:N OrderItem
-- Order 1:0..1 Payment
-- Customer 1:N Address

