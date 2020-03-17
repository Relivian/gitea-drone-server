-- File: setup/create_mysql.sql
USE mysql;
SET default_storage_engine=INNODB;
CREATE DATABASE `gitea` COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON `gitea`.* TO 'gitea'@'%';
FLUSH PRIVILEGES;

