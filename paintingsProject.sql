USE vaishnavi;
SELECT * FROM artist;
SELECT * FROM canvas;
SELECT * FROM museum;
SELECT * FROM museumhr;
SELECT * FROM product;
SELECT * FROM subject;
SELECT * FROM work;


-- Q1) Fetch all the paintings which are not displayed on any museum

SELECT DISTINCT w.name, w.museum_id
FROM work w
JOIN museum m
ON w.museum_id = m.museum_id
WHERE m.museum_id IS NULL;


-- Q2) Are there museuems without any paintings?
SELECT m.*
FROM museum m
LEFT JOIN work w
ON m.museum_id = w.museum_id
WHERE w.museum_id IS NULL;


-- Q3) How many paintings have an asking price of more than their regular price? 
SELECT w.*
FROM work w
LEFT JOIN product p 
ON w.work_id = p.work_id
WHERE p.sale_price > p.regular_price;


-- Q4) Identify the paintings whose asking price is less than 50% of its regular price
SELECT w.*, p.sale_price, p.regular_price
FROM work w
LEFT JOIN product p 
ON w.work_id = p.work_id
WHERE p.sale_price < (p.regular_price)*0.5;


-- Q5) Which canva size costs the most?
SELECT c.size_id, c.width, c.height, c.label, MAX(p.sale_price)
FROM canvas c
LEFT JOIN product p 
ON c.size_id = p.size_id
GROUP BY c.size_id, c.width, c.height, c.label
ORDER BY MAX(p.sale_price) DESC
LIMIT 3;


-- Q6) Identify the museums with invalid city information in the given dataset
SELECT *
FROM museum
WHERE NOT city LIKE '[%A-Z%]' AND
      city REGEXP '[0-9]';
      
      
-- Q7) Museum_Hours table has 1 invalid entry. Identify it and remove it.
SELECT *
FROM museumhr
WHERE NOT day IN ("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday");

DELETE FROM museumhr
WHERE day IN (
    SELECT day
    FROM (
        SELECT day
        FROM museumhr
        WHERE NOT day IN ("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
	) AS subquery
);



-- Q8) Fetch the top 10 most famous painting subject
SELECT distinct subject, COUNT(subject) AS most_famous
FROM subject
GROUP BY subject
ORDER BY COUNT(subject) DESC
LIMIT 10;


-- Q9) Identify the museums which are open on both Sunday and Monday. Display museum name, citY
SELECT DISTINCT m.name, m.city
FROM museum m
LEFT JOIN museumhr h
ON m.museum_id = h.museum_id
WHERE day IN ("Sunday", "Monday");


-- Q10) How many museums are open every single day?
SELECT COUNT(DISTINCT m.name)
FROM museum m
LEFT JOIN museumhr h
ON m.museum_id = h.museum_id;


-- Q11) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
SELECT m.name, m.address, m.city, m.state, m.country, COUNT(w.museum_id)
FROM museum m
LEFT JOIN work w
ON m.museum_id = w.museum_id
GROUP BY m.name, m.address, m.city, m.state, m.country
ORDER BY COUNT(w.museum_id) DESC
LIMIT 5;


-- Q12) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
SELECT a.full_name, COUNT(w.artist_id)
FROM artist a 
LEFT JOIN work w
ON a.artist_id = w.artist_id
GROUP BY a.full_name
ORDER BY COUNT(w.artist_id) DESC
LIMIT 5;



-- Q13) Display the 3 least popular canva sizes
SELECT c.width, c.height, c.label, COUNT(p.size_id)
FROM canvas c 
LEFT JOIN product p 
ON c.size_id = p.size_id
GROUP BY c.width, c.height, c.label
ORDER BY COUNT(p.size_id) ASC
LIMIT 3;



-- Q14) Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?
SELECT m.name, m.state, h.day, TIMESTAMPDIFF(HOUR, h.open, h.close) AS Total_Hours
FROM museum m
LEFT JOIN museumhr h 
ON m.museum_id = h.museum_id
GROUP BY m.name, m.state, h.day, Total_Hours
ORDER BY Total_Hours DESC
LIMIT 3;


-- Q15) Which museum has the most no of most popular painting style?

SELECT m.name, m.state, w.style, COUNT(w.museum_id)
FROM museum m
LEFT JOIN work w ON m.museum_id = w.museum_id
WHERE m.museum_id IN (
    SELECT w.museum_id
    FROM work w
    GROUP BY w.museum_id
    ORDER BY COUNT(w.style) DESC
)
GROUP BY m.name, m.state, w.style
ORDER BY COUNT(w.museum_id) DESC
LIMIT 1;






