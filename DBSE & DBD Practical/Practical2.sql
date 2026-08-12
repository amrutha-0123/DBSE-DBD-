mysql> CREATE DATABASE library_db;
Query OK, 1 row affected (0.01 sec)

mysql> USE library_db;
Database changed
mysql> CREATE TABLE Books (
    ->     book_id INT PRIMARY KEY,
    ->     title VARCHAR(100) NOT NULL,
    ->     isbn VARCHAR(20) UNIQUE,
    ->     published_year INT CHECK (published_year < 2027)
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> INSERT INTO Books (book_id, title, isbn, published_year) VALUES
    -> (1, 'The Great Gatsby', '9780743273565', 1925),
    -> (2, 'To Kill a Mockingbird', '9780061120084', 1960),
    -> (3, '1984', '9780451524935', 1949);
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM Books;
+---------+-----------------------+---------------+----------------+
| book_id | title                 | isbn          | published_year |
+---------+-----------------------+---------------+----------------+
|       1 | The Great Gatsby      | 9780743273565 |           1925 |
|       2 | To Kill a Mockingbird | 9780061120084 |           1960 |
|       3 | 1984                  | 9780451524935 |           1949 |
+---------+-----------------------+---------------+----------------+
3 rows in set (0.01 sec)

mysql> CREATE TABLE Members (
    ->     member_id INT PRIMARY KEY,
    ->     full_name VARCHAR(100),
    ->     email VARCHAR(100) UNIQUE
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> INSERT INTO Members (member_id, full_name, email) VALUES
    -> (101, 'John Smith', 'john.smith@email.com'),
    -> (102, 'Emma Wilson', 'emma.wilson@email.com'),
    -> (103, 'Michael Brown', 'michael.brown@email.com');
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM Members;
+-----------+---------------+-------------------------+
| member_id | full_name     | email                   |
+-----------+---------------+-------------------------+
|       101 | John Smith    | john.smith@email.com    |
|       102 | Emma Wilson   | emma.wilson@email.com   |
|       103 | Michael Brown | michael.brown@email.com |
+-----------+---------------+-------------------------+
3 rows in set (0.00 sec)

mysql> CREATE TABLE Loans (
    ->     loan_id INT PRIMARY KEY,
    ->     member_id INT,
    ->     book_id INT,
    ->     loan_date DATE,
    ->     FOREIGN KEY (member_id) REFERENCES Members(member_id),
    ->     FOREIGN KEY (book_id) REFERENCES Books(book_id)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> INSERT INTO Loans (loan_id, member_id, book_id, loan_date) VALUES
    -> (1, 101, 1, '2025-01-05'),
    -> (2, 102, 2, '2025-01-08'),
    -> (3, 103, 3, '2025-01-10'),
    -> (4, 101, 2, '2025-02-01'),
    -> (5, 102, 1, '2025-02-05'),
    -> (6, 103, 2, '2025-02-12'),
    -> (7, 101, 3, '2025-03-01'),
    -> (8, 102, 3, '2025-03-07'),
    -> (9, 103, 1, '2025-03-15'),
    -> (10, 101, 1, '2025-04-01');
Query OK, 10 rows affected (0.01 sec)
Records: 10  Duplicates: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM Loans;
+---------+-----------+---------+------------+
| loan_id | member_id | book_id | loan_date  |
+---------+-----------+---------+------------+
|       1 |       101 |       1 | 2025-01-05 |
|       2 |       102 |       2 | 2025-01-08 |
|       3 |       103 |       3 | 2025-01-10 |
|       4 |       101 |       2 | 2025-02-01 |
|       5 |       102 |       1 | 2025-02-05 |
|       6 |       103 |       2 | 2025-02-12 |
|       7 |       101 |       3 | 2025-03-01 |
|       8 |       102 |       3 | 2025-03-07 |
|       9 |       103 |       1 | 2025-03-15 |
|      10 |       101 |       1 | 2025-04-01 |
+---------+-----------+---------+------------+
10 rows in set (0.00 sec)

mysql> SELECT m.full_name AS Member_Name, b.title AS Book_Title
    -> FROM Loans l
    -> INNER JOIN Members m ON l.member_id = m.member_id
    -> INNER JOIN Books b ON l.book_id = b.book_id;
+---------------+-----------------------+
| Member_Name   | Book_Title            |
+---------------+-----------------------+
| John Smith    | The Great Gatsby      |
| John Smith    | To Kill a Mockingbird |
| John Smith    | 1984                  |
| John Smith    | The Great Gatsby      |
| Emma Wilson   | To Kill a Mockingbird |
| Emma Wilson   | The Great Gatsby      |
| Emma Wilson   | 1984                  |
| Michael Brown | 1984                  |
| Michael Brown | To Kill a Mockingbird |
| Michael Brown | The Great Gatsby      |
+---------------+-----------------------+
10 rows in set (0.01 sec)

mysql> SELECT published_year, COUNT(book_id) AS Total_Books
    -> FROM Books
    -> GROUP BY published_year
    -> ORDER BY published_year;
+----------------+-------------+
| published_year | Total_Books |
+----------------+-------------+
|           1925 |           1 |
|           1949 |           1 |
|           1960 |           1 |
+----------------+-------------+
3 rows in set (0.01 sec)

mysql> CREATE TABLE Donation_History (
    ->     donation_id INT PRIMARY KEY,
    ->     book_id INT,
    ->     donor_name VARCHAR(100),
    ->     donation_date DATE,
    ->     FOREIGN KEY (book_id) REFERENCES Books(book_id)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> INSERT INTO Books (book_id, title, isbn, published_year)
    -> VALUES (4, 'Animal Farm', '9780451526342', 1945);
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> INSERT INTO Donation_History
    -> (donation_id, book_id, donor_name, donation_date)
    -> VALUES (1, 4, 'Raj Kumar', CURDATE());
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> COMMIT;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT * FROM Books;
+---------+-----------------------+---------------+----------------+
| book_id | title                 | isbn          | published_year |
+---------+-----------------------+---------------+----------------+
|       1 | The Great Gatsby      | 9780743273565 |           1925 |
|       2 | To Kill a Mockingbird | 9780061120084 |           1960 |
|       3 | 1984                  | 9780451524935 |           1949 |
|       4 | Animal Farm           | 9780451526342 |           1945 |
+---------+-----------------------+---------------+----------------+
4 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM Donation_History;
+-------------+---------+------------+---------------+
| donation_id | book_id | donor_name | donation_date |
+-------------+---------+------------+---------------+
|           1 |       4 | Raj Kumar  | 2026-08-12    |
+-------------+---------+------------+---------------+
1 row in set (0.00 sec)

mysql> CREATE INDEX idx_books_isbn ON Books(isbn);
Query OK, 0 rows affected (0.05 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM Books
    -> WHERE isbn = '9780451524935';
+---------+-------+---------------+----------------+
| book_id | title | isbn          | published_year |
+---------+-------+---------------+----------------+
|       3 | 1984  | 9780451524935 |           1949 |
+---------+-------+---------------+----------------+
1 row in set (0.01 sec)

mysql> SHOW TABLES;
+----------------------+
| Tables_in_library_db |
+----------------------+
| books                |
| donation_history     |
| loans                |
| members              |
+----------------------+
4 rows in set (0.02 sec)

mysql> Terminal close -- exit!
