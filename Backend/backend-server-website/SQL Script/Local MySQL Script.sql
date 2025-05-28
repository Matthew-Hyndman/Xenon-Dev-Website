CREATE DATABASE `xenon-dev-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

CREATE USER 'xenondev'@'localhost' IDENTIFIED BY 'Xenon-Dev64!';
GRANT ALL PRIVILEGES ON `xenon-dev-db`.* TO 'xenondev'@'localhost';

USE `xenon-dev-db`;

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `email` varchar(225) NOT NULL,
  `FK_player_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `player_id_idx` (`FK_player_id`)
) 
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4;

TRUNCATE TABLE `xenon-dev-db`.`user`;
INSERT INTO `xenon-dev-db`.`user`
(`id`, `name`, `email`)
VALUES
( 10000, 'Matthew-admin', 'matthew@xenon-dev.com'),
( 10001, 'Matthew-tester', 'mhyndman6464@gmail.com');
SELECT * FROM `xenon-dev-db`.`user`;

CREATE TABLE `player_profile` (
  `player_id` bigint(20) NOT NULL DEFAULT 10000,
  `pot` int(11) NOT NULL,
  `wins` int(11) NOT NULL,
  `losses` int(11) NOT NULL,
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/*
///////USER CREATION EXAMPLE//////
  CREATE TABLE `customer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
*/

ALTER TABLE `xenon-dev-db`.`user` 
CHANGE COLUMN `FK_player_id` `FK_player_id` BIGINT(20) NULL ,
ADD INDEX `player_id_idx` (`FK_player_id`);



