CREATE TABLE Students (
    StudentID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Age NUMBER,
    Course VARCHAR2(50)
);

INSERT INTO Students VALUES (1, 'Ram', 20, 'Computer Science');
INSERT INTO Students VALUES (2, 'Sita', 19, 'Information Technology');
INSERT INTO Students VALUES (3, 'Hari', 21, 'Software Engineering');

SELECT * FROM Students;

UPDATE Students
SET Age = 22
WHERE Name = 'Hari';

SELECT * FROM Students;

DELETE FROM Students
WHERE StudentID = 2;

SELECT * FROM Students;
