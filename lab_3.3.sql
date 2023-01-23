USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(inventory_id) FROM sakila.inventory
WHERE film_id IN (SELECT film_id FROM sakila.film 
WHERE title IN('Hunchback Impossible'));

-- 2. List all films whose length is longer than the average of all the films.
SELECT film_id, title, length FROM sakila.film
WHERE length > (SELECT AVG(length) FROM sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor_id FROM sakila.film_actor
WHERE film_id IN (SELECT film_id FROM sakila.film 
WHERE title IN('Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT film_id, title FROM sakila.film
WHERE film_id IN (SELECT film_id FROM sakila.film_category
WHERE category_id IN (SELECT category_id FROM sakila.category
WHERE name IN('Family')));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email FROM sakila.customer
WHERE customer_id IN (SELECT customer_id FROM sakila.address
WHERE city_id IN (SELECT city_id FROM sakila.city
WHERE country_id IN(SELECT country_id FROM sakila.country
WHERE country IN('Canada'))));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT film_id, title FROM sakila.film
WHERE film_id IN (
SELECT film_id FROM film_actor
WHERE actor_id = (
SELECT actor_id FROM (
SELECT actor_id, count(film_id) as number_films FROM sakila.film_actor
GROUP BY actor_id
ORDER BY number_films DESC
LIMIT 1) AS table1));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT film_id, title FROM sakila.film
WHERE film_id IN (SELECT film_id FROM sakila.inventory
WHERE inventory_id IN (SELECT inventory_id FROM sakila.rental
WHERE customer_id IN (
SELECT customer_id FROM (SELECT customer_id, sum(amount) as sum_amount FROM payment
GROUP BY customer_id
ORDER BY sum_amount DESC
LIMIT 1) as table1)));

-- 8. Customers who spent more than the average payments.
SELECT customer_id, sum(amount) AS t_amount FROM sakila.payment
GROUP BY customer_id
HAVING t_amount > (
SELECT AVG(t_amount) FROM (
SELECT sum(amount) AS t_amount FROM sakila.payment 
GROUP BY customer_id) AS table1)