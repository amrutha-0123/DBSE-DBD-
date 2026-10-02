CREATE DATABASE bookflow_db;

CREATE TABLE Books (
 book_id SERIAL PRIMARY KEY,
 title VARCHAR(255) NOT NULL,
 isbn VARCHAR(13) UNIQUE NOT NULL,
 published_year INT CHECK (published_year < 2027)
);

CREATE TABLE Members (
 member_id SERIAL PRIMARY KEY,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO Books (title,isbn,published_year) VALUES
('The Martian','9780553418026',2014),
('Dune','9780441172719',1965),
('Clean Code','9780132350884',2008);

INSERT INTO Members (full_name,email) VALUES
('Alice Johnson','alice@example.com'),
('Bob Smith','bob@example.com'),
('Carol Williams','carol@example.com');
