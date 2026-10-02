-- SKILL SESSION 01: RDBMS FOUNDATIONS
-- Topics: DBMS vs file system, RDBMS architecture,
-- three-schema model, data independence, catalog/data dictionary.

CREATE DATABASE IF NOT EXISTS bookflow_skill_db;
USE bookflow_skill_db;

CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    published_year INT
);

CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO Books (title, isbn, published_year) VALUES
('The Martian', '9780553418026', 2014),
('Dune', '9780441172719', 1965);

INSERT INTO Members (full_name, email) VALUES
('Jhanasri Thota', 'jhanasri@example.com'),
('Amrutha J', 'amrutha@example.com');

SELECT * FROM Books;
SELECT * FROM Members;

-- Data dictionary / catalog information
DESCRIBE Books;
DESCRIBE Members;

-- Metadata query
SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bookflow_skill_db';
