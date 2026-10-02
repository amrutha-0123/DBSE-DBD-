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
