CREATE DATABASE `xenon-dev-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `xenon-dev-db`;

CREATE USER 'xenondev'@'localhost' IDENTIFIED BY 'Xenon-Dev64!';
GRANT ALL PRIVILEGES ON `xenon-dev-db`.* TO 'xenondev'@'localhost';

CREATE TABLE `player_profile` (
    `player_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `pot` INT(11) NOT NULL,
    `wins` INT(11) NOT NULL,
    `losses` INT(11) NOT NULL,
    PRIMARY KEY (`player_id`)
)  ENGINE=INNODB AUTO_INCREMENT=100 DEFAULT CHARSET=UTF8MB4;

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `FK_player_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_player_id` (`FK_player_id`),
  CONSTRAINT `FK_player_id` FOREIGN KEY (`FK_player_id`) REFERENCES `player_profile` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8mb4;

TRUNCATE TABLE `xenon-dev-db`.`user`;
INSERT INTO `xenon-dev-db`.`user`
(`id`, `name`, `email`)
VALUES
( 10000, 'Matthew-admin', 'matthew@xenon-dev.com'),
( 10001, 'Matthew-tester', 'mhyndman6464@gmail.com');
SELECT * FROM `xenon-dev-db`.`user`;

/*RELEVANT QUERIES*/
SELECT u.id, u.name, p.player_id, p.pot, p.wins, p.losses FROM `xenon-dev-db`.`user` AS u
JOIN `xenon-dev-db`.`player_profile` AS p ON u.FK_player_id = p.player_id
ORDER BY u.name ASC;

CREATE VIEW LeaderboardDisplay AS
SELECT u.name, p.player_id, p.pot, p.wins, p.losses FROM `xenon-dev-db`.`user` AS u
JOIN `xenon-dev-db`.`player_profile` AS p ON u.FK_player_id = p.player_id
ORDER BY u.name ASC;
