mysql> CREATE DATABASE IF NOT EXISTS bookflow_db;
Query OK, 1 row affected (0.01 sec)

mysql> USE bookflow_db;
Database changed
mysql> CREATE TABLE books (
    ->  book_id INT AUTO_INCREMENT PRIMARY KEY,
    ->  title VARCHAR(255) NOT NULL,
    ->  isbn VARCHAR(13) NOT NULL UNIQUE,
    ->  published_year INT,
    ->  CONSTRAINT chk_published_year CHECK (published_year < 2027)
    -> );
Query OK, 0 rows affected (0.02 sec)

mysql> CREATE TABLE members (
    ->  member_id INT AUTO_INCREMENT PRIMARY KEY,
    ->  full_name VARCHAR(100) NOT NULL,
    ->  email VARCHAR(150) NOT NULL UNIQUE
    -> );
Query OK, 0 rows affected (0.02 sec)

mysql> INSERT INTO books (title, isbn, published_year) VALUES
    -> ('The Alchemist', '9780061122415', 1988),
    -> ('Clean Code', '9780132350884', 2008),
    -> ('Atomic Habits', '9780735211292', 2018);
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO members (full_name, email) VALUES
    -> ('Puja Hansitha','puja@gmail.com'),
    -> ('Arpita Kumari', 'arpita@mail.com),
    '> ^C
mysql> ^C
mysql> INSERT INTO members (full_name, email) VALUES
    -> ('Puja Hansitha','puja@gmail.com'),
    -> ('Arpita Kumari', 'arpita@mail.com'),
    -> ('Amrutha V', 'amrutha@smtn.com');
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM books;
+---------+---------------+---------------+----------------+
| book_id | title         | isbn          | published_year |
+---------+---------------+---------------+----------------+
|       1 | The Alchemist | 9780061122415 |           1988 |
|       2 | Clean Code    | 9780132350884 |           2008 |
|       3 | Atomic Habits | 9780735211292 |           2018 |
+---------+---------------+---------------+----------------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM members
    -> ;
+-----------+---------------+------------------+
| member_id | full_name     | email            |
+-----------+---------------+------------------+
|         1 | Puja Hansitha | puja@gmail.com   |
|         2 | Arpita Kumari | arpita@mail.com  |
|         3 | Amrutha V     | amrutha@smtn.com |
+-----------+---------------+------------------+
3 rows in set (0.00 sec)

mysql> INSERT INTO books (title, isbn, published_year)
    -> VALUES ('FAKE Copy', '9780061122415', 2000);
ERROR 1062 (23000): Duplicate entry '9780061122415' for key 'books.isbn'
mysql> INSERT INTO books (title, isbn, published_year)
    -> VALUES (NULL, '9999999999999', 2010);
ERROR 1048 (23000): Column 'title' cannot be null
mysql> INSERT INTO books (title, isbn, published_year)
    -> VALUES ('Time Traveler', '8888888888888', 2030);
ERROR 3819 (HY000): Check constraint 'chk_published_year' is violated.
mysql> INSERT INTO members (full_name, email)
    -> VALUES ('Amrutha clone', 'amrutha@smtn.com');
ERROR 1062 (23000): Duplicate entry 'amrutha@smtn.com' for key 'members.email'
mysql> notee
