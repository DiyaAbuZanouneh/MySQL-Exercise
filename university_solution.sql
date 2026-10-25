DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university;

CREATE TABLE Students (
    student_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) NOT NULL,
    date_of_birth   DATE,
    gender          VARCHAR(10),
    major           VARCHAR(50),
    enrollment_year INT
);

CREATE TABLE Courses (
    course_id   INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    credits     INT,
    department  VARCHAR(50),
    capacity    INT DEFAULT 30
);

CREATE TABLE Instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100),
    hire_date     DATE,
    department    VARCHAR(50)
);

CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT,
    course_id     INT,
    grade         CHAR(1),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id)  REFERENCES Courses(course_id)
);

CREATE TABLE Course_Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_id INT,
    course_id     INT,
    semester      VARCHAR(10),   
    year          INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id),
    FOREIGN KEY (course_id)     REFERENCES Courses(course_id)
);


INSERT INTO Students (first_name, last_name, email, date_of_birth, gender, major, enrollment_year) VALUES
('Ahmad',  'Ali',     'ahmad@uni.edu',  '2003-05-10', 'Male',   'Computer Science', 2022),
('Sara',   'Hasan',   'sara@uni.edu',   '2004-02-15', 'Female', 'Mathematics',      2023),
('Omar',   'Khaled',  'omar@uni.edu',   '2002-11-20', 'Male',   'Physics',          2021),
('Lina',   'Yousef',  'lina@uni.edu',   '2003-08-01', 'Female', 'Computer Science', 2022),
('Yazan',  'Saleh',   'yazan@uni.edu',  '2004-01-30', 'Male',   'English',          2023),
('Rania',  'Nasser',  'rania@uni.edu',  '2003-03-12', 'Female', 'Computer Science', 2022),
('Khaled', 'Mahmoud', 'khaled@uni.edu', '2002-07-07', 'Male',   'Mathematics',      2021),
('Dana',   'Ibrahim', 'dana@uni.edu',   '2004-09-25', 'Female', 'Physics',          2023),
('Fadi',   'Odeh',    'fadi@uni.edu',   '2003-12-05', 'Male',   'English',          2022),
('Noor',   'Haddad',  'noor@uni.edu',   '2004-04-18', 'Female', 'Mathematics',      2023);

INSERT INTO Instructors (first_name, last_name, email, hire_date, department) VALUES
('Mohammad', 'Zaid',   'm.zaid@uni.edu',   '2015-09-01', 'Computer Science'),
('Huda',     'Salem',  'h.salem@uni.edu',  '2018-02-01', 'Computer Science'),
('Ali',      'Fares',  'a.fares@uni.edu',  '2012-09-01', 'Mathematics'),
('Maha',     'Jaber',  'm.jaber@uni.edu',  '2019-09-01', 'Physics'),
('Samer',    'Rashid', 's.rashid@uni.edu', '2016-02-01', 'English');

INSERT INTO Courses (course_name, course_code, credits, department, capacity) VALUES
('Databases',       'CS201',   3, 'Computer Science', 30),
('Programming 1',   'CS101',   3, 'Computer Science', 30),
('Calculus 1',      'MATH101', 3, 'Mathematics',      30),
('General Physics', 'PHY101',  4, 'Physics',          30),
('English Writing', 'ENG101',  2, 'English',          5),
('Statistics',      'MATH201', 3, 'Mathematics',      30);

INSERT INTO Course_Assignments (instructor_id, course_id, semester, year) VALUES
(1, 1, 'Fall', 2026),
(2, 2, 'Fall', 2026),
(3, 3, 'Fall', 2026),
(4, 4, 'Fall', 2026),
(5, 5, 'Fall', 2026),
(3, 6, 'Fall', 2026);

INSERT INTO Enrollments (student_id, course_id, grade) VALUES
(1, 1, 'A'), (1, 2, 'B'), (1, 3, 'A'), (1, 4, 'B'),
(2, 1, 'B'), (2, 3, 'C'),
(3, 2, 'A'), (3, 5, 'A'),
(4, 1, 'C'), (4, 4, NULL),
(5, 3, 'B'), (5, 5, 'B'),
(6, 1, 'A'), (6, 2, 'A'), (6, 4, 'A'), (6, 5, 'B'),
(7, 2, 'C'), (7, 3, NULL),
(8, 4, 'B'), (8, 5, 'A'),
(9, 1, 'B'), (9, 5, 'C'),
(10, 2, 'B'), (10, 3, 'A');


SELECT * FROM Students;

SELECT COUNT(*) AS total_courses FROM Courses;

SELECT s.first_name, s.last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c     ON e.course_id  = c.course_id
WHERE c.course_name = 'Databases';

SELECT first_name, last_name, email
FROM Instructors
WHERE department = 'Computer Science';

SELECT c.course_name, COUNT(e.student_id) AS students_count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

SELECT s.first_name, s.last_name, c.course_name, e.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c     ON e.course_id  = c.course_id
WHERE e.grade = 'A';

SELECT c.course_name, i.first_name, i.last_name, ca.semester, ca.year
FROM Course_Assignments ca
JOIN Courses c     ON ca.course_id     = c.course_id
JOIN Instructors i ON ca.instructor_id = i.instructor_id
WHERE ca.semester = 'Fall' AND ca.year = 2026;

SELECT c.course_name,
       AVG(CASE e.grade
             WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2
             WHEN 'D' THEN 1 WHEN 'F' THEN 0
           END) AS average_grade
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Databases'
GROUP BY c.course_name;


SELECT s.first_name, s.last_name, COUNT(*) AS courses_count
FROM Students s
JOIN Enrollments e         ON s.student_id = e.student_id
JOIN Course_Assignments ca ON e.course_id  = ca.course_id
WHERE ca.semester = 'Fall' AND ca.year = 2026
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(*) > 3;

SELECT s.first_name, s.last_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c     ON e.course_id  = c.course_id
WHERE e.grade IS NULL;

SELECT s.first_name, s.last_name,
       AVG(CASE e.grade
             WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2
             WHEN 'D' THEN 1 WHEN 'F' THEN 0
           END) AS avg_grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY avg_grade DESC
LIMIT 1;

SELECT c.department, COUNT(*) AS courses_count
FROM Course_Assignments ca
JOIN Courses c ON ca.course_id = c.course_id
WHERE ca.year = YEAR(CURDATE())
GROUP BY c.department
ORDER BY courses_count DESC
LIMIT 1;


SELECT c.course_name
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;


DELIMITER $$
CREATE FUNCTION get_age(dob DATE)
RETURNS INT
NOT DETERMINISTIC NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END $$
DELIMITER ;

SELECT first_name, last_name, get_age(date_of_birth) AS age FROM Students;

DELIMITER $$
CREATE PROCEDURE enroll_student(IN p_student_id INT, IN p_course_id INT)
BEGIN
    INSERT INTO Enrollments (student_id, course_id, grade)
    VALUES (p_student_id, p_course_id, NULL);
END $$
DELIMITER ;

CALL enroll_student(2, 2);

SELECT c.department,
       AVG(CASE e.grade
             WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2
             WHEN 'D' THEN 1 WHEN 'F' THEN 0
           END) AS avg_grade
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.department;

ALTER TABLE Students ADD CONSTRAINT uq_student_email UNIQUE (email);

DELIMITER $$
CREATE PROCEDURE enroll_if_space(IN p_student_id INT, IN p_course_id INT)
BEGIN
    DECLARE current_count INT;
    DECLARE max_capacity  INT;

    START TRANSACTION;

    SELECT capacity INTO max_capacity
    FROM Courses WHERE course_id = p_course_id
    FOR UPDATE;

    SELECT COUNT(*) INTO current_count
    FROM Enrollments WHERE course_id = p_course_id;

    IF current_count < max_capacity THEN
        INSERT INTO Enrollments (student_id, course_id, grade)
        VALUES (p_student_id, p_course_id, NULL);
        COMMIT;
        SELECT 'Enrolled successfully' AS result;
    ELSE
        ROLLBACK;
        SELECT 'Course is full' AS result;
    END IF;
END $$
DELIMITER ;

CALL enroll_if_space(1, 5);
CALL enroll_if_space(1, 6);

CREATE INDEX idx_course_code ON Courses(course_code);

EXPLAIN
SELECT s.first_name, s.last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c     ON e.course_id  = c.course_id
WHERE c.course_code = 'CS201';

SELECT s.first_name, s.last_name, c.course_name
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c     ON e.course_id  = c.course_id;


SELECT i.first_name, i.last_name, c.course_name
FROM Instructors i
LEFT JOIN Course_Assignments ca ON i.instructor_id = ca.instructor_id
LEFT JOIN Courses c             ON ca.course_id    = c.course_id;

SELECT first_name, last_name, email, 'Student' AS role FROM Students
UNION
SELECT first_name, last_name, email, 'Instructor' AS role FROM Instructors;


SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    s.major,
    c.course_name,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    IFNULL(e.grade, 'Incomplete')          AS grade,
    
    (SELECT SUM(c2.credits)
       FROM Enrollments e2
       JOIN Courses c2 ON e2.course_id = c2.course_id
      WHERE e2.student_id = s.student_id)  AS total_credits
FROM Students s
JOIN Enrollments e              ON s.student_id     = e.student_id
JOIN Courses c                  ON e.course_id      = c.course_id
LEFT JOIN Course_Assignments ca ON c.course_id      = ca.course_id
LEFT JOIN Instructors i         ON ca.instructor_id = i.instructor_id
ORDER BY student_name, c.course_name;
