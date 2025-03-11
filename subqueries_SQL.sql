-- Step 1: Count the number of copies of "Hunchback Impossible"
SELECT 
    COUNT(*) AS total_copies
FROM 
    inventory i
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    f.title = 'Hunchback Impossible';

-- Step 2: List films longer than the average length
SELECT 
    title, 
    length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);

-- Step 3: Retrieve actors from "Alone Trip"
SELECT 
    a.first_name, 
    a.last_name
FROM 
    actor a
WHERE 
    a.actor_id IN (
        SELECT 
            fa.actor_id
        FROM 
            film_actor fa
        JOIN 
            film f ON fa.film_id = f.film_id
        WHERE 
            f.title = 'Alone Trip'
    );

-- Bonus 1: Find all family films
SELECT 
    f.title
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';

-- Bonus 2 (Subquery): Retrieve customers from Canada
SELECT 
    first_name, 
    last_name, 
    email
FROM 
    customer
WHERE 
    address_id IN (
        SELECT 
            address_id
        FROM 
            address
        WHERE 
            city_id IN (
                SELECT 
                    city_id
                FROM 
                    city
                WHERE 
                    country_id = (
                        SELECT 
                            country_id
                        FROM 
                            country
                        WHERE 
                            country = 'Canada'
                    )
            )
    );

-- Bonus 3: Find films starred by the most prolific actor
SELECT 
    f.title
FROM 
    film f
JOIN 
    film_actor fa ON f.film_id = fa.film_id
WHERE 
    fa.actor_id = (
        SELECT 
            actor_id
        FROM 
            film_actor
        GROUP BY 
            actor_id
        ORDER BY 
            COUNT(film_id) DESC
        LIMIT 1
    );

-- Bonus 4: Retrieve films rented by the most profitable customer
SELECT 
    DISTINCT f.title
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.customer_id = (
        SELECT 
            customer_id
        FROM 
            payment
        GROUP BY 
            customer_id
        ORDER BY 
            SUM(amount) DESC
        LIMIT 1
    );

-- Bonus 5: Find clients who spent more than the average
SELECT 
    customer_id, 
    SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    SUM(amount) > (
        SELECT 
            AVG(total_spent)
        FROM (
            SELECT 
                SUM(amount) AS total_spent
            FROM 
                payment
            GROUP BY 
                customer_id
        ) AS subquery
    );