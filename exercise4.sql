-- dump command
mysqldump -u root -p track > track.sql

CREATE DATABASE restored;

-- restore command
mysql -u root -p restored < track.sql