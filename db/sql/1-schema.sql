SET
    NAMES utf8;

SET
    time_zone = '+00:00';

SET
    foreign_key_checks = 0;

SET
    sql_mode = 'NO_AUTO_VALUE_ON_ZERO';


DROP TABLE IF EXISTS `Event`;
CREATE TABLE `Event` (
  `id` varchar(256) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) NOT NULL,
  `date` datetime DEFAULT NULL,
  `name_orga` varchar(256) NOT NULL,
  `mail_orga` varchar(256) NOT NULL,
  `id_place` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_place`) REFERENCES `Place`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `Attendee`;
CREATE TABLE `Attendee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_event` varchar(256) NOT NULL,
  `name_user` varchar(256) NOT NULL,
  `mail_user` varchar(256) DEFAULT NULL,  
  `status` int(2) DEFAULT 0,
  `details` varchar(256),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_event`) REFERENCES `Event`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `Place`;
CREATE TABLE `Place` (
  `id` varchar(256) NOT NULL,
  `name` varchar(128) NOT NULL,
  `adress` varchar(128) NOT NULL,
  `lat` decimal(22,10) NOT NULL,
  `lon` decimal(22,10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Comments`;
CREATE TABLE `Comments` (
  `id` varchar(256) NOT NULL,
  `id_event` varchar(256) NOT NULL,
  `id_attendee` int(11) NOT NULL,
  `text` varchar(256) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_event`) REFERENCES `Event`(`id`),
  FOREIGN KEY (`id_attendee`) REFERENCES `Attendee`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

