create database testdb;

use testdb;

create table employees(
emp_no int not null,
birth_date date not null,
first_name varchar(14) not null,
last_name varchar(16) not null,
gender enum ('M','F') not null,
hire_date Date not null,
primary key (emp_no) 
);

INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date) VALUES
(10001, '1975-01-01', 'John', 'Doe', 'M', '2000-06-01'),
(10002, '1980-05-15', 'Jane', 'Smith', 'F', '2001-09-23'),
(10003, '1985-07-30', 'Alice', 'Johnson', 'F', '2002-12-11'),
(10004, '1990-02-20', 'Bob', 'Williams', 'M', '2003-04-15');



CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);
INSERT INTO departments (dept_no, dept_name) VALUES
('d001', 'Human Resources'),
('d002', 'Engineering'),
('d003', 'Marketing'),
('d004', 'Sales');


CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date) VALUES
(10001, 'd001', '2000-06-01', '2005-06-01'),
(10002, 'd002', '2001-09-23', '2006-09-23'),
(10003, 'd003', '2002-12-11', '2007-12-11');


CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date) VALUES
(10001, 'd001', '2000-06-01', '2005-06-01'),
(10001, 'd002', '2005-06-01', '2010-06-01'),
(10002, 'd002', '2001-09-23', '2006-09-23'),
(10003, 'd003', '2002-12-11', '2007-12-11'),
(10004, 'd004', '2003-04-15', '2008-04-15');


CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
);

INSERT INTO titles (emp_no, title, from_date, to_date) VALUES
(10001, 'Senior Manager', '2000-06-01', '2005-06-01'),
(10001, 'Manager', '2005-06-01', '2010-06-01'),
(10002, 'Engineer', '2001-09-23', '2006-09-23'),
(10003, 'Marketing Specialist', '2002-12-11', '2007-12-11'),
(10004, 'Sales Associate', '2003-04-15', '2008-04-15');


CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
); 

INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES
(10001, 60000, '2000-06-01', '2001-06-01'),
(10001, 65000, '2001-06-01', '2002-06-01'),
(10001, 70000, '2002-06-01', '2003-06-01'),
(10002, 50000, '2001-09-23', '2002-09-23'),
(10003, 55000, '2002-12-11', '2003-12-11'),
(10004, 45000, '2003-04-15', '2004-04-15');

-- PROBLEM 1--
SELECT gender, COUNT(*)
FROM employees
GROUP BY gender
ORDER BY COUNT(*) DESC;

-- PROBLEM 2--
SELECT title, ROUND(AVG(salary), 2) AS avg_salary
FROM titles
JOIN salaries ON titles.emp_no = salaries.emp_no
AND titles.from_date <= salaries.from_date
AND (titles.to_date IS NULL OR salaries.to_date <= titles.to_date)
GROUP BY title
ORDER BY avg_salary DESC;

-- PROBLEM 3--
SELECT e.first_name, e.last_name, COUNT(d.dept_no) AS num_departments
FROM employees e
JOIN dept_emp d ON e.emp_no = d.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name
HAVING COUNT(d.dept_no) >= 2
ORDER BY e.first_name, e.last_name;

-- PROBLEM 4--
SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary = (
    SELECT MAX(salary)
    FROM salaries
)
LIMIT 1;


 

