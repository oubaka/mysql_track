CREATE TABLE tastes (
    name VARCHAR(20),
    filling VARCHAR(20)
);

CREATE TABLE locations (
    lname VARCHAR(20),
    phone INT,
    address VARCHAR(20)
);

CREATE TABLE sandwiches (
    location VARCHAR(20),
    bread VARCHAR(20),
    filling VARCHAR(20),
    price DECIMAL
);

INSERT INTO tastes 
    (name, filling) 
VALUES 
    ("Brown", "Turkey"),
    ("Brown", "Beef"),
    ("Brown", "Ham"),
    ("Jones", "Cheese"),
    ("Green", "Beef"),
    ("Green", "Turkey"),
    ("Green", "Cheese");

INSERT INTO locations
    (lname, phone, address)
VALUES
    ("Lincoln", "6834523", "Lincoln Place"),
    ("O'Neill's", "6742134", "Pearse St"),
    ("Old Nag", "7678132", "Dame St"),
    ("Buttery", "7023421", "College St");

INSERT INTO sandwiches
    (location, bread, filling, price)
VALUES
    ("Lincoln", "Rye", "Ham", 1.25),
    ("O'Neill's", "White", "Cheese", 1.20),
    ("O'Neill's", "Whole", "Ham", 1.25),
    ("Old Nag", "Rye", "Beef", 1.35),
    ("Buttery", "White", "Cheese", 1.00),
    ("O'Neill's", "White", "Turkey", 1.35),
    ("Buttery", "White", "Ham", 1.10),
    ("Lincoln", "Rye", "Beef", 1.35),
    ("Lincoln", "White", "Ham", 1.30),
    ("Old Nag", "Rye", "Ham", 1.40);

-- Places where Jones can eat using a nested subquery
SELECT * 
FROM locations 
WHERE lname IN (
    SELECT location 
    FROM sandwiches 
    WHERE filling IN (
        SELECT filling 
        FROM tastes 
        WHERE name="Jones"
    )
);

-- Places where Jones can eat without using a nested subquery
 SELECT loc.* 
 FROM locations AS loc 
 JOIN sandwiches AS san 
 ON loc.lname = san.location 
 JOIN tastes AS ts 
 ON san.filling = ts.filling 
 WHERE ts.name = "Jones";

--  Number of people that can eat in each location
SELECT loc.*, COUNT(ts.name) AS people_count 
FROM locations AS loc 
JOIN sandwiches AS san 
ON loc.lname = san.location 
JOIN tastes AS ts 
ON san.filling = ts.filling 
GROUP BY loc.lname;