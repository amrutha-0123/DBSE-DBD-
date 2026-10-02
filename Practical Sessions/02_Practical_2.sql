CREATE TABLE Loans (
 loan_id SERIAL PRIMARY KEY,
 member_id INT NOT NULL REFERENCES Members(member_id),
 book_id INT NOT NULL REFERENCES Books(book_id),
 borrowed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 returned_at TIMESTAMP
);

CREATE TABLE Donation_History (
 donation_id SERIAL PRIMARY KEY,
 book_id INT NOT NULL REFERENCES Books(book_id),
 donated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 donor_name VARCHAR(150)
);

INSERT INTO Loans (member_id,book_id) VALUES (1,1),(2,2);

SELECT m.full_name AS member_name,b.title AS book_title
FROM Loans l
JOIN Members m ON l.member_id=m.member_id
JOIN Books b ON l.book_id=b.book_id
WHERE l.returned_at IS NULL;

SELECT published_year,COUNT(book_id) AS total_books
FROM Books GROUP BY published_year ORDER BY published_year;

BEGIN;
WITH new_book AS (
 INSERT INTO Books(title,isbn,published_year)
 VALUES ('Project Hail Mary','9780593135204',2021)
 RETURNING book_id
)
INSERT INTO Donation_History(book_id,donor_name)
SELECT book_id,'Community Donor' FROM new_book;
COMMIT;

CREATE INDEX idx_books_isbn ON Books(isbn);
EXPLAIN SELECT * FROM Books WHERE isbn='9780593135204';
