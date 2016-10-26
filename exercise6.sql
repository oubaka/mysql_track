-- What do different columns in the output of EXPLAIN mean? What possible values can those have? What is the meaning of those values?

/*
    -Name: id 
    -Desc: a sequential identifier for each SELECT with the query (especially when there are subqueries)

    -Name: select_type
    -Desc: the type of the SELECT query
    -Possible Values: 
        -Name: SIMPLE
        -Desc: the query is a simple SELECT query without any subqueries or UNIONs
        
        -Name: PRIMARY 
        –Desc: the SELECT is in the outermost query in a JOIN

        -Name: DERIVED 
        –Desc: the SELECT is part of a subquery within a FROM clause

        -Name: SUBQUERY 
        –Desc: the first SELECT in a subquery

        -Name: DEPENDENT SUBQUERY
        -Desc: a subquery which is dependent upon on outer query

        -Name: UNCACHEABLE SUBQUERY 
        –Desc: a subquery which is not cacheable (there are certain conditions for a query to be cacheable)

        -Name: UNION 
        –Desc: the SELECT is the second or later statement of a UNION

        -Name: DEPENDENT UNION 
        –Desc: the second or later SELECT of a UNION is dependent on an outer query

        -Name: UNION RESULT 
        –Desc: the SELECT is a result of a UNION

    -Name: table 
    –Desc: the table referred to by the row

    -Name: type 
    –Desc: how MySQL joins the tables used. This is one of the most insightful fields in the output because it can indicate missing indexes or how the query is written should be reconsidered
    -Possible Values:
        -Name: system 
        –Desc: the table has only zero or one row

        -Name: const 
        –Desc: the table has only one matching row which is indexed. This is the fastest type of join because the table only has to be read once and the column’s value can be treated as a constant when joining other tables.

        -Name: eq_ref 
        –Desc: all parts of an index are used by the join and the index is PRIMARY KEY or UNIQUE NOT NULL. This is the next best possible join type.

        -Name: ref 
        –Desc: all of the matching rows of an indexed column are read for each combination of rows from the previous table. This type of join appears for indexed columns compared using = or <=> operators.

        -Name: fulltext 
        –Desc: the join uses the table’s FULLTEXT index.

        -Name: ref_or_null 
        –Desc: this is the same as ref but also contains rows with a null value for the column.

        -Name: index_merge 
        –Desc: the join uses a list of indexes to produce the result set. The key column of EXPLAIN‘s output will contain the keys used.

        -Name: unique_subquery – 
        -Desc: an IN subquery returns only one result from the table and makes use of the primary key.

        -Name: index_subquery 
        –Desc: the same as unique_subquery but returns more than one result row.

        -Name: range 
        –Desc: an index is used to find matching rows in a specific range, typically when the key column is compared to a constant using operators like BETWEEN, IN, >, >=, etc.

        -Name: index 
        –Desc: the entire index tree is scanned to find matching rows.

        -Name: all 
        –Desc: the entire table is scanned to find matching rows for the join. This is the worst join type and usually indicatesthe lack of appropriate indexes on the table.

    -Name: possible_keys 
    –Desc: shows the keys that can be used by MySQL to find rows from the table, though they may or may not be used in practice. In fact, this column can often help in optimizing queries since if the column is NULL, it indicates no relevant indexes could be found.
    
    -Name: key 
    –Desc: indicates the actual index used by MySQL. This column may contain an index that is not listed in the possible_key column. MySQL optimizer always look for an optimal key that can be used for the query. While joining many tables, it may figure out some other keys which is not listed in            possible_key but are more optimal.

    -Name: key_len 
    –Desc: indicates the length of the index the Query Optimizer chose to use. For example, a key_len value of 4 means it requires memory to store four characters. Check out MySQL’s data type storage requirements to know more about this.

    -Name: ref 
    –Desc: Shows the columns or constants that are compared to the index named in the key column. MySQL will either pick a constant value to be compared or a column itself based on the query execution plan. You can see this in the example given below

    -Name: rows 
    –Desc lists the number of records that were examined to produce the output. This Is another important column worth focusing on optimizing queries, especially for queries that use JOIN and subqueries.

    -Name: Extra 
    –Desc: contains additional information regarding the query execution plan. Values such as “Using temporary”, “Using filesort”, etc. in this column may indicate a troublesome query. For a complete list of possible values and their meaning, 
*/

/*
    2.
    We use EXPLAIN to optimize slow SQL queries used in our application. 
    Let’s say we have a comments table in our application that has a foreign key, user_id, referencing to users table. 
    EXPLAINing the query that finds all the comments made by a user gives us following result.
*/

EXPLAIN SELECT * FROM comments WHERE user_id = 41;
+-------------+------+---------------+---------+-------+---------+-------------+
| select_type | type | key           | key_len | ref   | rows    | Extra       |
+-------------+------+---------------+---------+-------+---------+-------------+
| SIMPLE      | ALL  | NULL          | NULL    | NULL  | 1002345 | Using where |
+-------------+------+---------------+---------+-------+---------+-------------+

/*
    2.1 The value under 'rows' column in the output of EXPLAIN query and SELECT query after it are same. What does it mean?

    Ans: This means that each row is scanned to produce the result set

    2.2 Is the SELECT query optimal? If no, how do we optimize it?

    Ans: No, this query is not optimal.
        We can optimize it by indexing the user_id column
*/

/*
    3.
    In Rails world, we have something called polymorphic associations 
    (http://guides.rubyonrails.org/association_basics.html#polymorphic-associations). Let’s say in our web application, 
    we can let users comment on photographs and articles. 
    Some of the rows in comments table are represented as following:
*/

SELECT * FROM comments LIMIT 5;
+----+------------------+----------------+---------+
| id | commentable_type | commentable_id | user_id |
+----+------------------+----------------+---------+
| 1  | Article          | 1              | 1       |
+----+------------------+----------------+---------+
| 2  | Photo            | 1              | 1       |
+----+------------------+----------------+---------+
| 3  | Photo            | 2              | 2       |
+----+------------------+----------------+---------+
| 4  | Photo            | 2              | 2       |
+----+------------------+----------------+---------+
| 5  | Article          | 1              | 2       |
+----+------------------+----------------+---------+

EXPLAIN SELECT * FROM comments WHERE commentable_id = 1 AND commentable_type = 'Article' AND user_id = 1;
+-------------+------+---------------+---------+-------+---------+-------------+
| select_type | type | key           | key_len | ref   | rows    | Extra       |
+-------------+------+---------------+---------+-------+---------+-------------+
| SIMPLE      | ALL  | NULL          | NULL    | NULL  | 1000025 | Using where |
+-------------+------+---------------+---------+-------+---------+-------------+

/*
    It seems that we do not have any index on any of the columns. 
    And whole comments table is scanned to fetch those comments. 
    We decide to index columns in comments table to optimize the SELECT query. What column(s) will you index in which order? 
    Ask the exercise creator for a hint if you are confused.

    Ans: Indexing is done on commentable_id and user_id column
*/

/*
    EXPLAIN a SELECT query against one of your databases which employs an INNER JOIN between two tables. 
    What does the output look like? What do the values under different columns mean? 
    Do you get only one row in EXPLAIN's output?
*/

EXPLAIN 
SELECT art.*, com.*
FROM users AS us
JOIN articles AS art
ON us.id = art.user_id
JOIN comments As com
ON com.article_id = art.id
WHERE us.name = "user3";
+------+-------------+-------+--------+---------------+---------+---------+----------------------+------+-------------------------------------------------+
| id   | select_type | table | type   | possible_keys | key     | key_len | ref                  | rows | Extra                                           |
+------+-------------+-------+--------+---------------+---------+---------+----------------------+------+-------------------------------------------------+
|    1 | SIMPLE      | com   | ALL    | NULL          | NULL    | NULL    | NULL                 |   17 |                                                 |
|    1 | SIMPLE      | art   | eq_ref | PRIMARY       | PRIMARY | 4       | track.com.article_id |    1 |                                                 |
|    1 | SIMPLE      | us    | ALL    | PRIMARY       | NULL    | NULL    | NULL                 |    4 | Using where; Using join buffer (flat, BNL join) |
+------+-------------+-------+--------+---------------+---------+---------+----------------------+------+-------------------------------------------------+

/*
    The result shows that 3 simple queries are involved in the execution
    under the type column, it shows that the query is optimized on at row 2 (eq_ref)
    under the rows column, it shows the number of rows scanned for each table involved

    Yes only one row is gotten, as indicated by the id column
*/

EXPLAIN 
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
+------+-------------+----------+--------+---------------+---------+---------+----------------------+------+-------------+
| id   | select_type | table    | type   | possible_keys | key     | key_len | ref                  | rows | Extra       |
+------+-------------+----------+--------+---------------+---------+---------+----------------------+------+-------------+
|    1 | PRIMARY     | com      | ALL    | NULL          | NULL    | NULL    | NULL                 |   17 |             |
|    1 | PRIMARY     | articles | eq_ref | PRIMARY       | PRIMARY | 4       | track.com.article_id |    1 | Using where |
|    3 | SUBQUERY    | users    | ALL    | NULL          | NULL    | NULL    | NULL                 |    4 | Using where |
+------+-------------+----------+--------+---------------+---------+---------+----------------------+------+-------------+

/*
    The result shows that 3 simple queries are involved in the execution
    under the type column, it shows that the query is optimized on at row 2 (eq_ref)
    under the rows column, it shows the number of rows scanned for each table involved

    But two rows are gotten as indicated by the select_type ( SUBQUERY )

    The JOIN query appears to be slightly better because of the absence of the SUBQUERY
*/