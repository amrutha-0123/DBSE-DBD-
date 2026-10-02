-- SKILL SESSION 02: ENTITY-RELATIONSHIP MODELLING
-- Demonstrates entities, attributes, relationships,
-- 1:N relationship, and relational mapping.

CREATE DATABASE IF NOT EXISTS library_er_db;
USE library_er_db;

-- Entity: MEMBER
CREATE TABLE Member (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Entity: BOOK
CREATE TABLE Book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL
);

-- Relationship: MEMBER borrows BOOK
-- One member can have many loans; each loan refers to one book.
CREATE TABLE Loan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrowed_on DATE NOT NULL,
    returned_on DATE,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

INSERT INTO Member (full_name, email) VALUES
('Jhanasri Thota', 'jhanasri@example.com'),
('Amrutha J', 'amrutha@example.com');

INSERT INTO Book (title, isbn) VALUES
('The Martian', '9780553418026'),
('Dune', '9780441172719');

INSERT INTO Loan (member_id, book_id, borrowed_on)
VALUES
(1, 1, CURDATE()),
(1, 2, CURDATE());

SELECT
    m.full_name,
    b.title,
    l.borrowed_on,
    l.returned_on
FROM Loan l
JOIN Member m ON l.member_id = m.member_id
JOIN Book b ON l.book_id = b.book_id;
