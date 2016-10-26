-- User has mnay Articles
-- Article belongs to a Category
-- User is of 2 types admin, normal
-- User can create many comments
-- Article can have many comments

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,    
    type ENUM("admin", "normal") DEFAULT 'normal'
);

CREATE TABLE articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    user_id INT NOT NULL,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    user_id INT NOT NULL,
    content TINYTEXT NOT NULL
);

INSERT INTO users 
    (name, type) 
VALUES
    ("Tunde", "admin"),
    ("Brown", "admin"),
    ("Jones", "normal"),
    ("user3", "normal");    

INSERT INTO categories 
    (name)
VALUES
    ("Politics"),
    ("Health"),
    ("Sports"),
    ("Entertainment");

INSERT INTO articles
    (category_id, user_id, name)
VALUES
    (1, 1, "The return of Buhari"),
    (2, 2, "Better food for better living"),
    (3, 3, "Mancity topping the tables"),
    (4, 4, "Wizkid live in Lagos"),
    (1, 1, "Jonathan to assist Buhari"),
    (2, 2, "Side effects of eating late at night"),
    (3, 3, "Leaders of UEFA"),
    (4, 4, "Best of Yemi Alade");    

INSERT INTO comments
    (article_id, user_id, content)
VALUES
    (1, 2, "Why should he return a 2nd time"),
    (1, 3, "I think returning makes sense"),
    (1, 4, "May God help our country"),
    (1, 3, "The government should sit up on this matter"),
    (2, 3, "Now which food is best for a married man"),
    (2, 4, "I know that food is more like a medicine"),
    (2, 2, "As for me any food goes"),
    (2, 1, "Will like to eat less at nigt"),
    (2, 1, "How many balls of eba is adequate for an adult"),
    (3, 1, "I think Mancity is the Leader"),
    (3, 2, "Why do you think Mancity is?"),
    (3, 2, "Can you really prove this."),
    (4, 1, "Wizzy bobo at it again"),
    (4, 3, "As for me, I dont care"),    
    (6, 2, "Pot belly is the result"),    
    (8, 2, "For me the best is Kissing"),
    (8, 1, "I like Nagode too");    


-- select all article with user name = user3
SELECT art.* 
FROM users AS us 
JOIN articles AS art 
ON us.id = art.user_id 
WHERE us.name = "user3";

-- For all the articles being selected above, select all the articles and also the comments associated with those articles in a single query (Do this using subquery also)
SELECT art.*, com.* 
FROM users AS us 
JOIN articles AS art 
ON us.id = art.user_id 
JOIN comments As com 
ON com.article_id = art.id 
WHERE us.name = "user3";

-- using subquery
SELECT * 
FROM comments AS com, (
    SELECT * 
    FROM articles 
    WHERE user_id = (
        SELECT id 
        FROM users 
        WHERE name="user3"
    )
) AS art 
WHERE com.article_id = art.id;

-- Write a query to select all articles which do not have any comments (Do using subquery also)
 EXPLAIN SELECT * 
 FROM articles AS art 
 LEFT JOIN comments As com 
 ON art.id = com.article_id 
 WHERE com.id IS NULL;

--  using subquery
EXPLAIN SELECT * 
FROM articles 
WHERE id NOT IN (
    SELECT article_id 
    FROM comments
);

-- Write a query to select article which has maximum comments.
EXPLAIN SELECT art.*, COUNT(com.id) AS comment_count 
FROM articles AS art 
JOIN comments AS com 
ON art.id = com.article_id 
GROUP BY art.id
HAVING comment_count = (
    SELECT MAX(list.comment_count) 
    FROM (
        SELECT art.*, COUNT(com.id) AS comment_count 
        FROM articles AS art 
        JOIN comments AS com 
        ON art.id = com.article_id 
        GROUP BY art.id    
    ) AS list
);

-- Write a query to select article which does not have more than one comment by the same user ( do this using left join and group by )
SELECT art.*, COUNT(com.id) AS comment_count 
FROM articles AS art 
LEFT JOIN comments AS com 
ON art.id = com.article_id 
GROUP BY com.article_id, com.user_id
HAVING comment_count <= 1;