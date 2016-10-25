-- dump command
mysqldump track > track.sql

CREATE DATABASE restored;

-- restore command
mysql restored < track.sql