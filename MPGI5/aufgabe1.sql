CREATE TABLE IF NOT EXISTS `Abteilung` (
  `AbteilungsNr` int(11) NOT NULL,
  `Name` text NOT NULL,
  `Ort` text NOT NULL,
  PRIMARY KEY (`AbteilungsNr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Abteilung` (`AbteilungsNr`, `Name`, `Ort`) VALUES
(1, 'Test', 'Berlin'),
(2, 'Entwicklung', 'Berlin'),
(3, 'Anforderungsanagement', 'Köln'),
(4, 'Marketing', 'München'),
(5, 'Analyse', 'Hamburg'),
(6, 'Controlling', 'Berlin'),
(7, 'Beratung', 'Hamburg');

CREATE TABLE IF NOT EXISTS `Angestellter` (
  `PersonalNr` int(11) NOT NULL,
  `Name` text NOT NULL UNIQUE,
  `Vorname` text NOT NULL,
  `Gehalt` int(11) NOT NULL,
  `Wohnort` text NOT NULL,
  `AbteilungsNr` int(11) NOT NULL,
  PRIMARY KEY (`PersonalNr`),
  KEY `AbteilungsNr` (`AbteilungsNr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Angestellter` (`PersonalNr`, `Name`, `Vorname`, `Gehalt`, `Wohnort`, `AbteilungsNr`) VALUES
(1, 'Winter', 'Carolin', 45000, 'Berlin', 2),
(2, 'Sommer', 'Anna', 35000, 'Hamburg', 4),
(3, 'Frühling', 'Leonie', 60000, 'Berlin', 3),
(4, 'Kühlsommer', 'Peter', 45000, 'München', 2),
(5, 'Spätfrühling', 'Max', 55000, 'Köln', 6),
(6, 'Spätsommer', 'Marion', 56000, 'München', 1),
(7, 'Frischherbst', 'Frank', 42000, 'Stuttgart', 7),
(8, 'Warmwinter', 'Paul', 43000, 'Potsdam', 5);

CREATE TABLE IF NOT EXISTS `ArbeitetMit` (
  `PersonalNr` int(11) NOT NULL,
  `ProjektNr` int(11) NOT NULL,
  PRIMARY KEY (`PersonalNr`,`ProjektNr`),
  KEY `ArbeitetMit_ibfk_2` (`ProjektNr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `ArbeitetMit` (`PersonalNr`, `ProjektNr`) VALUES
(8, 3),
(7, 5),
(4, 21),
(6, 21),
(2, 29),
(1, 31),
(5, 31),
(8, 31);

CREATE TABLE IF NOT EXISTS `Projekt` (
  `ProjektNr` int(11) NOT NULL,
  `ProjektName` text NOT NULL,
  `ProjektOrt` text NOT NULL,
  `istTeilprojektVon` int(11) DEFAULT NULL,
  `Leiter` int(11) NOT NULL,
  PRIMARY KEY (`ProjektNr`),
  KEY `istTeilprojektVon` (`istTeilprojektVon`,`Leiter`),
  KEY `Leiter` (`Leiter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Projekt` (`ProjektNr`, `ProjektName`, `ProjektOrt`, `istTeilprojektVon`, `Leiter`) VALUES
(3, 'Implementierung', 'Köln', 23, 4),
(5, 'Logischer Entwurf', 'München', 3, 2),
(21, 'Benchmark', 'Stuttgart', 23, 6),
(23, 'VOIP', 'Hamburg', NULL, 3),
(25, 'ER-Entwurf', 'Berlin', 23, 2),
(29, 'Anforderungsanalyse', 'Berlin', 25, 7),
(31, 'Anforderungserhebung', 'Berlin', 25, 3);

ALTER TABLE `Angestellter`
  ADD CONSTRAINT `Angestellter_ibfk_1` FOREIGN KEY (`AbteilungsNr`) REFERENCES `Abteilung` (`AbteilungsNr`) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE `ArbeitetMit`
  ADD CONSTRAINT `ArbeitetMit_ibfk_2` FOREIGN KEY (`ProjektNr`) REFERENCES `Projekt` (`ProjektNr`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ArbeitetMit_ibfk_1` FOREIGN KEY (`PersonalNr`) REFERENCES `Angestellter` (`PersonalNr`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Projekt`
  ADD CONSTRAINT `Projekt_ibfk_1` FOREIGN KEY (`istTeilprojektVon`) REFERENCES `Projekt` (`ProjektNr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Projekt_ibfk_2` FOREIGN KEY (`Leiter`) REFERENCES `Angestellter` (`PersonalNr`) ON DELETE NO ACTION ON UPDATE NO ACTION;
