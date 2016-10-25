CREATE DATABASE vtapp;

CREATE USER 'vtapp_user'@'localhost';

GRANT ALL PRIVILEGES ON vtapp . * TO 'vtapp_user'@'localhost';

FLUSH PRIVILEGES;