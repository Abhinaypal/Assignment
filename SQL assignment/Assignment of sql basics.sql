CREATE DATABASE EMPLOYEES;

USE EMPLOYEES;

/* 1. Create a table called employees with the following structure
 emp_id (integer, should not be NULL and should be a primary key)
 emp_name (text, should not be NULL)
 age (integer, should have a check constraint to ensure the age is at least 18)
 email (text, should be unique for each employee)
 salary (decimal, with a default value of 30,000).
 Write the SQL query to create the above table with all constraints. */

CREATE TABLE employees (
    emp_id INTEGER NOT NULL PRIMARY KEY,
    emp_name TEXT NOT NULL,
    age INTEGER CHECK (age >= 18),
    email VARCHAR(100) UNIQUE,
    salary DECIMAL DEFAULT 30000
);


/*  2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide 
examples of common types of constraints. */


/* Constraints in a database enforce rules on data to ensure accuracy and consistency. 🛡️

- Primary Key: Makes sure each record is unique.
- Foreign Key: Maintains valid links between tables.
- NOT NULL: Prevents missing essential data.
- Unique: Avoids duplicate entries.
- Check: Validates that data meets specific criteria.

These constraints keep the database reliable and trustworthy by blocking incorrect or conflicting data from being entered. */

-- PRIMARY KEY

INSERT INTO employees (emp_id, emp_name) VALUES (1, 'John');
INSERT INTO employees (emp_id, emp_name) VALUES (1, 'Jane');

-- FOREIGN KEY
CREATE TABLE departments (dept_id INTEGER PRIMARY KEY, dept_name TEXT);
ALTER TABLE employees ADD dept_id INTEGER, ADD FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Prevents invalid dept_id values
INSERT INTO employees (emp_id, emp_name, dept_id) VALUES (5, 'Eve', 999);


-- NOT NULL
INSERT INTO employees (emp_id, emp_name, age) VALUES (1, NULL, 25);

-- UNIQUE
INSERT INTO employees (emp_id, emp_name, email) VALUES (2, 'Jane', 'john@example.com');

-- CHECK 
INSERT INTO employees (emp_id, emp_name, age) VALUES (3, 'Bob', 16);



/* 3 .Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify 
your answer. */

/* NOT NULL Constraint:  
It’s applied to a column to ensure that every row has a valid, non-empty value. 
This is crucial for fields that are essential—like names, IDs, or prices—so the data remains complete and meaningful.

Can a Primary Key contain NULL?  
No, it cannot. A primary key must uniquely identify each record in a table.  
- NULL values represent unknown or missing data, which can't be used for unique identification.
- Allowing NULLs would break the rule of uniqueness and make it impossible to reliably distinguish records.

In short: NOT NULL guarantees data presence, and primary keys rely on that presence for uniqueness and integrity. */

/* 4.  Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an 
example for both adding and removing a constraint.*/

/* To manage constraints in an existing SQL table, you use the ALTER TABLE command. This lets you add or drop constraints without recreating the table.
1. ADD A CONSTRAINT
.. USE ALTER TABLE TO MODIFY THE STRUCTURE
.. SPECIFY THE CONSTRAINT TYPE AND ITS CONDITION.

ADD A NOT NULL CONSTRAINT */

ALTER TABLE Employees
MODIFY emp_name VARCHAR(50) NOT NULL;

-- ADD A CHECK CONSTRAINT
ALTER TABLE Employees
ADD CONSTRAINT chk_salary CHECK (Salary > 0);

/* 2. STEP TO REMOVE THE CONSTRAINT
.. INDENTIFY THE NAME OF THE CONSTRAINT
.. USE ALTER TABLE WITH DROP CONSTRAINT */

ALTER TABLE Employees
DROP CONSTRAINT chk_salary;


/* 5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. 
Provide an example of an error message that might occur when violating a constraint.

-- CONSTRAINT VIOLANCE CONSEQUENCES
When you try to insert, update, or delete data that breaks a database constraint, the DBMS blocks the action to protect the integrity of the data. Here's what might happen:

Insert Failure: Adding a row with missing required data (violating NOT NULL) or duplicate values (violating UNIQUE) will trigger an error.

Update Failure: Changing a value that breaks a CHECK condition or causes key duplication will be rejected.

Delete Failure: Removing a record that's referenced by a FOREIGN KEY will be stopped unless cascading is enabled.

EXAMPLE ERROR MESSAGE:
ERROR 1048 (23000): Column 'FirstName' cannot be null
*/

/* 6.  You created a products table without constraints as follows:
 CREATE TABLE products (
 product_id INT,
 product_name VARCHAR(50),
 price DECIMAL(10, 2));  
 Now, you realise that
 The product_id should be a primary key
 The price should have a default value of 50.00 
 */
 
 CREATE TABLE products (
	product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2));
    
    
-- MAKE product_id PRIMARY KEY
ALTER TABLE products
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);

-- SET DEFAULT PRICE TO 50.00
ALTER TABLE products
MODIFY price DECIMAL(10, 2) DEFAULT 50.00;


/* 7. HAVE TWO TABLES
Write a query to fetch the student_name and class_name for each student using an INNER JOIN. */

CREATE TABLE classes (
	class_id INTEGER PRIMARY KEY,
    class_name TEXT NOT NULL
);

CREATE TABLE students (
	student_id INTEGER PRIMARY KEY,
    student_name TEXT NOT NULL,
    class_id INTEGER,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);
 -- INSERT DATA IN TABLES
 INSERT INTO classes (class_id, class_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

INSERT INTO students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 103);


-- INNER JOIN QUERY TO FETCH THE STUDENT NAME AND CLASS NAME
SELECT s.student_name, c.class_name
FROM students s
INNER JOIN classes c
ON s.class_id = c.class_id;

/* 8. Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are 
listed even if they are not associated with an order 
Hint: (use INNER JOIN and LEFT JOIN) */

CREATE TABLE orders (
	order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INTEGER NOT NULL
);

INSERT INTO orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-01', 101),
(2, '2024-01-03', 102);



CREATE TABLE customers (
	customer_name TEXT NOT NULL,
	customer_id INTEGER NOT NULL
);

INSERT INTO customers (customer_name, customer_id) VALUES
('Alice', 101),
('Bob', 102);



CREATE TABLE product (
	product_id INTEGER NOT NULL,
    product_name TEXT NOT NULL,
    order_id INTEGER,
    foreign key (order_id) references orders(order_id)
);

INSERT INTO product (product_id, product_name, order_id) values
(1, 'Laptop', 1),
(2, 'Phone', NULL);

SELECT p.order_id, c.customer_name, p.product_name
FROM product p
LEFT JOIN orders o ON p.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id;


/* 9. let's create two tables
1. Sales
2. products
*/


create table sales (
	sale_id integer primary key,
    product_id integer not null,
    amount int);

-- productss table
create table productss (
	product_id integer not null,
    product_name text not null
);

insert into sales (sale_id, product_id, amount) values
(1, 101, 500),
(2, 102, 300),
(3, 103, 700);

insert into productss (product_id, product_name) values
(101, 'Laptop'),
(102, 'Phone');

-- Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.
SELECT p.product_name, SUM(s.amount) AS total_sales
FROM productss p
INNER JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_name;


/* 10. lets create three tables */

create table orderss (
	order_id int,
    order_date text not null,
    customer_id int primary key);
    
create table customerss (
	customer_id int,
    customer_name text);
drop table order_details;
create table order_details (
	order_id integer,
    product_id int,
    quantity int);

insert into orderss (order_id, order_date, customer_id) values
(1, '2024-01-01', 1),
(2, '2024-01-05', 2);

insert into customerss (customer_id, customer_name) values
(1, 'Alice'),
(2, 'Bob');

insert into order_details (order_id, product_id, quantity) values
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

-- Write a query to display the order_id, customer_name, and the quantity of products ordered by each 
-- customer using an INNER JOIN between all three tables.
SELECT o.order_id, c.customer_name, SUM(od.quantity) AS total_quantity
FROM orderss o
INNER JOIN customerss c ON o.customer_id = c.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, c.customer_name;
