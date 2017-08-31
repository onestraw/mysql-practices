DROP TABLE IF EXISTS `Manufacturers`;
CREATE TABLE `Manufacturers` (
  `Code` int(11) NOT NULL DEFAULT '0',
  `Name` varchar(255) NOT NULL,
  PRIMARY KEY (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `Products`;
CREATE TABLE `Products` (
  `Code` int(11) NOT NULL DEFAULT '0',
  `Name` varchar(255) NOT NULL,
  `Price` decimal(10,0) NOT NULL,
  `Manufacturer` int(11) NOT NULL,
  PRIMARY KEY (`Code`),
  KEY `Manufacturer` (`Manufacturer`),
  CONSTRAINT `Products_ibfk_1` FOREIGN KEY (`Manufacturer`) REFERENCES `Manufacturers` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

