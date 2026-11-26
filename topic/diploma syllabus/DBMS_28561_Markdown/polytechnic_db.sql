-- =====================================================================
-- polytechnic_db: DBMS (28561) নোটের সব SQL উদাহরণের জন্য Practice Database
-- MySQL 8.0+ এ চালান:  mysql -u root -p < polytechnic_db.sql
-- =====================================================================
DROP DATABASE IF EXISTS polytechnic_db;
CREATE DATABASE polytechnic_db CHARACTER SET utf8mb4;
USE polytechnic_db;

CREATE TABLE department (
    dept_id    INT PRIMARY KEY,
    dept_name  VARCHAR(40) NOT NULL UNIQUE,
    building   VARCHAR(20)
);

CREATE TABLE student (
    roll       INT PRIMARY KEY,
    name       VARCHAR(40) NOT NULL,
    dept_id    INT,
    semester   TINYINT CHECK (semester BETWEEN 1 AND 8),
    cgpa       DECIMAL(3,2),
    city       VARCHAR(30),
    phone      VARCHAR(15),
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY,
    name       VARCHAR(40) NOT NULL,
    dept_id    INT,
    salary     INT,
    join_date  DATE,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE course (
    course_code VARCHAR(10) PRIMARY KEY,
    title       VARCHAR(40) NOT NULL,
    credit      TINYINT,
    dept_id     INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE enrollment (
    roll        INT,
    course_code VARCHAR(10),
    marks       INT,
    PRIMARY KEY (roll, course_code),
    FOREIGN KEY (roll) REFERENCES student(roll),
    FOREIGN KEY (course_code) REFERENCES course(course_code)
);

CREATE TABLE account (
    acc_no   INT PRIMARY KEY,
    holder   VARCHAR(40),
    balance  INT CHECK (balance >= 0)
);

INSERT INTO department VALUES
(1, 'Computer',   'Building-A'),
(2, 'Civil',      'Building-B'),
(3, 'Electrical', 'Building-C'),
(4, 'Mechanical', 'Building-D');

INSERT INTO student VALUES
(101, 'Rahim',   1, 6, 3.75, 'Dhaka',      '01711111111'),
(102, 'Karim',   1, 6, 3.20, 'Sirajganj',  '01722222222'),
(103, 'Nila',    1, 4, 3.90, 'Dhaka',      NULL),
(104, 'Sumon',   2, 6, 2.95, 'Bogura',     '01744444444'),
(105, 'Mitu',    2, 4, 3.45, 'Pabna',      '01755555555'),
(106, 'Jamal',   3, 6, 3.10, 'Sirajganj',  NULL),
(107, 'Rina',    3, 2, 3.60, 'Rajshahi',   '01777777777'),
(108, 'Hasan',   4, 6, 2.80, 'Dhaka',      '01788888888'),
(109, 'Tania',   1, 2, 3.55, 'Natore',     '01799999999'),
(110, 'Arif',    NULL, 1, NULL, 'Bogura',  '01700000000');

INSERT INTO teacher VALUES
(1, 'Mr. Alam',    1, 55000, '2015-03-01'),
(2, 'Ms. Nasrin',  1, 48000, '2018-07-15'),
(3, 'Mr. Kabir',   2, 52000, '2016-01-10'),
(4, 'Ms. Shirin',  3, 45000, '2020-02-01'),
(5, 'Mr. Habib',   4, 60000, '2012-09-20');

INSERT INTO course VALUES
('28561', 'Database Management System', 3, 1),
('28562', 'Computer Networking',        3, 1),
('28541', 'Java Programming',           3, 1),
('26461', 'Structural Mechanics',       4, 2),
('26761', 'Electrical Machines',        4, 3),
('27061', 'Thermodynamics',             3, 4);

INSERT INTO enrollment VALUES
(101, '28561', 82), (101, '28562', 75), (101, '28541', 88),
(102, '28561', 64), (102, '28562', 70),
(103, '28561', 91), (103, '28541', 85),
(104, '26461', 58), (105, '26461', 72),
(106, '26761', 66), (107, '26761', 79),
(108, '27061', 55), (109, '28541', 77);

INSERT INTO account VALUES
(1, 'Rahim', 5000),
(2, 'Karim', 2000);
