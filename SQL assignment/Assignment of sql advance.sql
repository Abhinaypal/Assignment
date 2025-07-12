show databases;

use mavenmovies;
show tables;

-- Primary key

SELECT 
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    kcu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
    AND tc.TABLE_SCHEMA = 'mavenmovies'
ORDER BY tc.TABLE_NAME, kcu.COLUMN_NAME;

-- foreign key
SELECT 
    kcu.TABLE_NAME,
    kcu.CONSTRAINT_NAME,
    kcu.COLUMN_NAME,
    kcu.REFERENCED_TABLE_NAME,
    kcu.REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
WHERE tc.CONSTRAINT_TYPE = 'FOREIGN KEY'
    AND tc.TABLE_SCHEMA = 'mavenmovies'
ORDER BY kcu.TABLE_NAME, kcu.COLUMN_NAME;


/* Differences
A primary key uniquely identifies each record in a table. 
For example, film_id in the film table or customer_id in 
the customer table ensures that each film or customer has 
a distinct identity. These values must be unique and cannot be NULL.

A foreign key creates a link between two tables by referencing 
a primary key from another table. For instance, film_id in the 
inventory table refers to the film_id in the film table. This helps 
maintain relationships and ensures data consistency across related tables.
*/


--  2- List all details of actors
show tables;
SELECT *
FROM mavenmovies.actor;


--  3 -List all customer information from DB.

select * from mavenmovies.customer;

--  4 -List different countries.

select * from mavenmovies.country;

--  5 -Display all active customers.
SELECT *
FROM mavenmovies.customer
WHERE active = 1;


--  6 -List of all rental IDs for customer with ID 1.
SELECT rental_id
FROM mavenmovies.rental
WHERE customer_id = 1;


--  7 - Display all the films whose rental duration is greater than 5 .
select * from mavenmovies.film
where rental_duration>5;


--  8 - List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT COUNT(*) AS total_films
FROM mavenmovies.film
WHERE replacement_cost > 15 AND replacement_cost < 20;


--  9 - Display the count of unique first names of actors.
SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM mavenmovies.actor;


--  10- Display the first 10 records from the customer table .
SELECT * FROM customer LIMIT 10;

--  11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
SELECT *
FROM customer
WHERE first_name LIKE 'B%'
LIMIT 3;


--  12 -Display the names of the first 5 movies which are rated as ‘G’.
SELECT title
FROM film
WHERE rating = 'G'
LIMIT 5;


--  13-Find all customers whose first name starts with "a".
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'A%';


--  14- Find all customers whose first name ends with "a".
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%A';


--  15- Display the list of first 4 cities which start and end with ‘a’ .
SELECT city
FROM city
WHERE city LIKE 'A%A'
LIMIT 4;


--  16- Find all customers whose first name have "NI" in any position.
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%NI%';


--  17- Find all customers whose first name have "r" in the second position .
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '_R%';


--  18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'A%'
AND LENGTH(first_name) >= 5;


--   19- Find all customers whose first name starts with "a" and ends with "o".
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'A%O';


--  20 - Get the films with pg and pg-13 rating using IN operator.
SELECT title, rating
FROM film
WHERE rating IN ('PG', 'PG-13');


--  21 - Get the films with length between 50 to 100 using between operator.
SELECT title, length
FROM film
WHERE length BETWEEN 50 AND 100;


--  22 - Get the top 50 actors using limit operator.
SELECT actor_id, first_name, last_name
FROM actor
LIMIT 50;


--  23 - Get the distinct film ids from inventory table.
SELECT DISTINCT film_id
FROM inventory;



/* FUNCTIONS */

/*Question 1:
 Retrieve the total number of rentals made in the Sakila database.
 Hint: Use the COUNT() function.*/
 
SELECT COUNT(*) AS total_rentals
FROM rental;

/* Question 2:
 Find the average rental duration (in days) of movies rented from the Sakila database.
 Hint: Utilize the AVG() function.*/
 
SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration
FROM rental
WHERE return_date IS NOT NULL;

/* Question 3:
 Display the first name and last name of customers in uppercase.
 Hint: Use the UPPER () function.*/
 
SELECT UPPER(first_name) AS first_name, UPPER(last_name) AS last_name
FROM customer;


/* Question 4:
 Extract the month from the rental date and display it alongside the rental ID.
 Hint: Employ the MONTH() function.*/
 
SELECT rental_id, MONTH(rental_date) AS rental_month
FROM rental;

/* Question 5:
 Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
 Hint: Use COUNT () in conjunction with GROUP BY.*/
 
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;


/* Question 6:
 Find the total revenue generated by each store.
 Hint: Combine SUM() and GROUP BY.*/
 
SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
GROUP BY store.store_id;


/* Question 7:
 Determine the total number of rentals for each category of movies.
 Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.*/
 
SELECT category.name AS category_name, COUNT(rental.rental_id) AS total_rentals
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;


/*  Question 8:
 Find the average rental rate of movies in each language.
 Hint: JOIN film and language tables, then use AVG () and GROUP BY.*/
 
 SELECT l.name AS language_name, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;


/* Questions 9 -
 Display the title of the movie, customer s first name, and last name who rented it.
 Hint: Use JOIN between the film, inventory, rental, and customer tables.*/


SELECT f.title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

/* Question 10:
 Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
 Hint: Use JOIN between the film actor, film, and actor tables.*/

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

/* Question 11:
 Retrieve the customer names along with the total amount they've spent on rentals.
 Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.*/
 
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

/*  Question 12:
 List the titles of movies rented by each customer in a particular city (e.g., 'London').
 Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.*/
 
SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ct.city = 'London'
GROUP BY c.customer_id, f.title;

/* Question 13:
 Display the top 5 rented movies along with the number of times they've been rented.
 Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.*/
 
 SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

/* Question 14:
 Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
 Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.*/
 
SELECT customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

/* WINDOWS FUNCTION */

--  1. Rank the customers based on the total amount they've spent on rentals.
SELECT customer_id, first_name, last_name, total_spent
FROM (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) AS customer_totals
ORDER BY total_spent DESC;


--  2. Calculate the cumulative revenue generated by each film over time.
SELECT f.title, r.rental_date, SUM(p.amount) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title, r.rental_date
ORDER BY f.title, r.rental_date;

--  3. Determine the average rental duration for each film, considering films with similar lengths.
SELECT f.title, f.length, AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, f.length
ORDER BY f.length;

--  4. Identify the top 3 films in each category based on their rental counts.
SELECT category.name AS category_name, film.title, COUNT(rental.rental_id) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name, film.title
ORDER BY category.name, rental_count DESC;


-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals
 -- across all customers.
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS total_rentals,
       COUNT(r.rental_id) - (
           SELECT AVG(rental_count)
           FROM (
               SELECT COUNT(*) AS rental_count
               FROM rental
               GROUP BY customer_id
           ) AS avg_table
       ) AS difference_from_avg
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;


--  6. Find the monthly revenue trend for the entire rental store over time.
SELECT DATE_FORMAT(payment.payment_date, '%Y-%m') AS month,
       SUM(payment.amount) AS monthly_revenue
FROM payment
GROUP BY month
ORDER BY month;

--  7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
WITH customer_spending AS (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
ranked_customers AS (
    SELECT *, NTILE(5) OVER (ORDER BY total_spent DESC) AS spending_rank
    FROM customer_spending
)
SELECT customer_id, first_name, last_name, total_spent
FROM ranked_customers
WHERE spending_rank = 1;


--  8. Calculate the running total of rentals per category, ordered by rental count.

SELECT category.name AS category_name,
       film.title,
       COUNT(rental.rental_id) AS rental_count,
       SUM(COUNT(rental.rental_id)) OVER (PARTITION BY category.name ORDER BY COUNT(rental.rental_id)) AS running_total
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name, film.title
ORDER BY category.name, rental_count;


--  9. Find the films that have been rented less than the average rental count for their respective categories.
SELECT f.title, c.name AS category_name, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title, c.name, fc.category_id
HAVING COUNT(r.rental_id) < (
    SELECT AVG(rental_count)
    FROM (
        SELECT COUNT(r2.rental_id) AS rental_count
        FROM film f2
        JOIN film_category fc2 ON f2.film_id = fc2.film_id
        JOIN inventory i2 ON f2.film_id = i2.film_id
        JOIN rental r2 ON i2.inventory_id = r2.inventory_id
        WHERE fc2.category_id = fc.category_id
        GROUP BY f2.film_id
    ) AS category_avg
);


--  10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT DATE_FORMAT(payment.payment_date, '%Y-%m') AS month,
       SUM(payment.amount) AS monthly_revenue
FROM payment
GROUP BY month
ORDER BY monthly_revenue DESC
LIMIT 5;


/* Normalisation & CTE */

/*  1. First Normal Form (1NF):
               a. Identify a table in the Sakila database that violates 1NF. Explain how you
               would normalize it to achieve 1NF.*/

-- after this i am unable to write answers cause i am still reading sql and watching videos so it will take more time.