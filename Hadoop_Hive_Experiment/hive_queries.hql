CREATE DATABASE IF NOT EXISTS college;
USE college;

-- 3.1 Creating an Internal Table
CREATE TABLE IF NOT EXISTS students (
    id INT,
    name STRING,
    dept STRING,
    marks INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

-- 3.2 Creating an External Table
CREATE EXTERNAL TABLE IF NOT EXISTS students_ext (
    id INT,
    name STRING,
    dept STRING,
    marks INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/hive/external/students';

-- 4. Loading Data into Hive Table
LOAD DATA LOCAL INPATH 'students.csv' OVERWRITE INTO TABLE students;

-- ==========================================
-- 5. Viewing Table Data
-- ==========================================
SELECT * FROM students;

-- ==========================================
-- 6. Performing Analytical Queries
-- ==========================================
-- 6.1 Count number of students
SELECT COUNT(*) FROM students;

-- 6.2 Find average marks
SELECT AVG(marks) FROM students;

-- 6.3 Group by department
SELECT dept, COUNT(*) AS total_students FROM students GROUP BY dept;

-- 6.4 Highest marks
SELECT name, marks FROM students ORDER BY marks DESC LIMIT 1;

-- 6.5 Department-wise average marks
SELECT dept, AVG(marks) AS avg_marks FROM students GROUP BY dept;

-- 6.6 Filter students with marks > 80
SELECT name, marks FROM students WHERE marks > 80;

-- 7. Dropping a Table
DROP TABLE IF EXISTS students;
