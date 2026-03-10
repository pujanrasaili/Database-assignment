-- Oracle SQL Lab: Student Table Operations
-- Author: Pujan Rasaili
-- Date: 10-March-2026

-- 1. Create Table
CREATE TABLE Students (
    StudentID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Age NUMBER,
    Course VARCHAR2(50)
);

-- 2. Insert Records
INSERT INTO Students VALUES (1, 'Ram', 20, 'Computer Science');
INSERT INTO Students VALUES (2, 'Sita', 19, 'Information Technology');
INSERT INTO Students VALUES (3, 'Hari', 21, 'Software Engineering');

-- 3. Display All Records
SELECT * FROM Students;

-- 4. Update a Record (Change Hari's Age to 22)
UPDATE Students
SET Age = 22
WHERE Name = 'Hari';

-- 5. Display Records After Update
SELECT * FROM Students;

-- 6. Delete a Record (Delete Sita)
DELETE FROM Students
WHERE StudentID = 2;

-- 7. Display Final Table
SELECT * FROM Students;
