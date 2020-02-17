-- File: setup/create_mysql.sql
USE mysql;
-- make sure the following password matches dbrootpw in .env
SET password = password('db-change-me');
SET default_storage_engine=INNODB;
CREATE DATABASE `gitea` COLLATE utf8mb4_general_ci;
-- make sure the following password matches gitea_secret in .env
CREATE USER 'gitea'@'%' IDENTIFIED BY 'gitea-change-me';
GRANT ALL PRIVILEGES ON `gitea`.* TO 'gitea'@'%';
FLUSH PRIVILEGES;

