-- Drop database if exists
DROP DATABASE IF EXISTS BankDB;
CREATE DATABASE BankDB;
USE BankDB;

-- Drop table/procedure if exists (optional, extra safe)
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salary_log;
DROP PROCEDURE IF EXISTS transferMoney;
DROP PROCEDURE IF EXISTS updateEmployeeSalary;
DROP PROCEDURE IF EXISTS addEmployee;
DROP PROCEDURE IF EXISTS getEmployees;

-- Create accounts table
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50),
    balance INT
);

-- Insert sample data
INSERT INTO accounts VALUES
(1, 'Ram', 50000),
(2, 'Shyam', 30000),
(3, 'Sita', 20000);

SELECT * FROM accounts;

-- Transaction 1
START TRANSACTION;
UPDATE accounts SET balance = balance - 5000 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 5000 WHERE account_id = 2;
COMMIT;
SELECT * FROM accounts;

-- Transaction 2 with rollback
START TRANSACTION;
UPDATE accounts SET balance = balance - 10000 WHERE account_id = 2;
UPDATE accounts SET balance = balance + 10000 WHERE account_id = 3;
ROLLBACK;
SELECT * FROM accounts;

-- Transaction 3 with savepoint
START TRANSACTION;
UPDATE accounts SET balance = balance - 2000 WHERE account_id = 1;
SAVEPOINT sp1;
UPDATE accounts SET balance = balance + 2000 WHERE account_id = 3;
ROLLBACK TO sp1;
COMMIT;
SELECT * FROM accounts;

----------------------
# Triggers
----------------------
-- 1. Employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

-- 2. Salary log table
CREATE TABLE salary_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. BEFORE INSERT trigger
DELIMITER $$
CREATE TRIGGER check_salary 
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 10000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'salary must be at least 10000';
    END IF;
END $$
DELIMITER ;

-- 4. AFTER UPDATE trigger
DELIMITER $$
CREATE TRIGGER log_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_log(emp_id, old_salary, new_salary)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary);
END $$
DELIMITER ;

----------------------
# Stored Procedures
----------------------
-- 1. Get employees
DELIMITER $$
CREATE PROCEDURE getEmployees()
BEGIN
    SELECT * FROM employees;
END $$
DELIMITER ;
CALL getEmployees();

-- 2. Add employee
DELIMITER $$
CREATE PROCEDURE addEmployee(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO employees VALUES (p_id, p_name, p_salary);
END $$
DELIMITER ;
CALL addEmployee(5,'Hari',20000);

-- 3. Update employee salary
DELIMITER $$
CREATE PROCEDURE updateEmployeeSalary(
    IN p_id INT,
    IN p_salary DECIMAL(10,2)
)
BEGIN
    UPDATE employees SET salary = p_salary WHERE emp_id = p_id;
END $$
DELIMITER ;
CALL updateEmployeeSalary(5,25000);

SELECT * FROM employees;
SELECT * FROM salary_log;

-- 4. Transfer money procedure
DELIMITER $$
CREATE PROCEDURE transferMoney(
    IN from_id INT,
    IN to_id INT,
    IN amount INT
)
BEGIN
    START TRANSACTION;
    UPDATE accounts SET balance = balance - amount WHERE account_id = from_id;
    UPDATE accounts SET balance = balance + amount WHERE account_id = to_id;
    COMMIT;
END $$
DELIMITER ;
CALL transferMoney(1,2,3000);
SELECT * FROM accounts;