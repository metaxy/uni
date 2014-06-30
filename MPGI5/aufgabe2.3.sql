UPDATE `Angestellter` SET `Wohnort`="Berlin" WHERE `PersonalNr` = '4';
UPDATE `Angestellter` SET `Gehalt`=`Gehalt` * 1.07 WHERE 1;
UPDATE `Angestellter` AS a1,`Abteilung` AS a2 SET a1.AbteilungsNr = a2.AbteilungsNr
WHERE a2.name = "Test" AND a1.name = "Warmwinter";


