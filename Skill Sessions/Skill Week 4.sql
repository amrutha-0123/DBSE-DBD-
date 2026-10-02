-- SKILL SESSION 04: TRANSACTIONS & STORED LOGIC
-- Covers ACID transactions, COMMIT, ROLLBACK, SAVEPOINT,
-- stored procedure, function, trigger, and view.

CREATE DATABASE IF NOT EXISTS transaction_skill_db;
USE transaction_skill_db;

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    holder_name VARCHAR(100) NOT NULL,
    balance DECIMAL(10,2) NOT NULL
);

INSERT INTO Accounts VALUES
(1, 'Jhanasri', 10000.00),
(2, 'Amrutha', 5000.00);

-- Transaction with SAVEPOINT
START TRANSACTION;

UPDATE Accounts
SET balance = balance - 1000
WHERE account_id = 1;

SAVEPOINT after_debit;

UPDATE Accounts
SET balance = balance + 1000
WHERE account_id = 2;

COMMIT;

SELECT * FROM Accounts;

-- Stored Procedure
DELIMITER //

CREATE PROCEDURE GetAccountBalance(IN p_account_id INT)
BEGIN
    SELECT account_id, holder_name, balance
    FROM Accounts
    WHERE account_id = p_account_id;
END //

DELIMITER ;

CALL GetAccountBalance(1);

-- Stored Function
DELIMITER //

CREATE FUNCTION AccountStatus(p_balance DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_balance >= 5000 THEN
        RETURN 'ACTIVE';
    ELSE
        RETURN 'LOW BALANCE';
    END IF;
END //

DELIMITER ;

SELECT holder_name, balance, AccountStatus(balance) AS status
FROM Accounts;

-- Audit table and trigger
CREATE TABLE Account_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    old_balance DECIMAL(10,2),
    new_balance DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER account_balance_audit
AFTER UPDATE ON Accounts
FOR EACH ROW
BEGIN
    IF OLD.balance <> NEW.balance THEN
        INSERT INTO Account_Audit(account_id, old_balance, new_balance)
        VALUES(NEW.account_id, OLD.balance, NEW.balance);
    END IF;
END //

DELIMITER ;

-- View
CREATE VIEW Account_Report AS
SELECT account_id, holder_name, balance, AccountStatus(balance) AS status
FROM Accounts;

SELECT * FROM Account_Report;
