CREATE TABLE IF NOT EXISTS email_subscribers (
    email VARCHAR(50) NOT NULL,
    phone INT NOT NULL,
    city VARCHAR(50) NOT NULL
);

load data local infile 'C:/Users/Admin/Downloads/email_subscribers.csv' into table email_subscribers
fields terminated by ','
lines terminated by '\n';

-- What all cities did people respond from
SELECT DISTINCT city 
FROM email_subscribers;

-- How many people responded from each city
SELECT city, COUNT(email) 
FROM email_subscribers 
GROUP BY city;

-- Which city were the maximum respondents from?
SELECT city, COUNT(email) FROM email_subscribers
GROUP BY city 
HAVING COUNT(email) = 
(
    SELECT MAX(user_count) AS maximum
    FROM (
        SELECT city, COUNT(email) AS user_count 
        FROM email_subscribers 
        GROUP BY city     
    ) AS sub
);

-- What all email domains did people respond from ?
SELECT DISTINCT SUBSTRING_INDEX(email, '@', -1) 
FROM email_subscribers;

-- Which is the most popular email domain among the respondents ?
SELECT SUBSTRING_INDEX(email, '@', -1) AS domains, COUNT(email) AS rating
FROM email_subscribers
GROUP BY domains
HAVING rating = (
    SELECT MAX(email_count) 
    FROM (
        SELECT COUNT(SUBSTRING_INDEX(email, '@', -1)) AS email_count
        FROM email_subscribers
        GROUP BY SUBSTRING_INDEX(email, '@', -1)
    ) AS sub
);