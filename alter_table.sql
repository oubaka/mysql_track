CREATE TABLE testing_table(
    name VARCHAR(20),
    contact_name VARCHAR(20),
    roll_no VARCHAR(20)
);

ALTER TABLE testing_table DROP COLUMN name;

ALTER TABLE testing_table CHANGE COLUMN contact_name username VARCHAR(20);

ALTER TABLE testing_table ADD COLUMN first_name VARCHAR(20);
ALTER TABLE testing_table ADD COLUMN last_name VARCHAR(20);

ALTER TABLE testing_table CHANGE COLUMN roll_no roll_no INT;