USE [GenussRest]
GO

/* CHECK Constraints
SELECT name, definition, parent_object_id, OBJECT_NAME(parent_object_id) AS TableName
FROM sys.check_constraints;*/

/*delete Constraints
ALTER TABLE Bestellpositionen 
DROP CONSTRAINT CK_BestellMenge;*/


USE GenussRest;
GO

-- 1. Stellt sicher, dass die Bestellmenge immer größer als 0 ist
ALTER TABLE Bestellpositionen
ADD CONSTRAINT CK_Bestellpositionen_Menge CHECK ([Menge] > 0);
GO

-- 2. Stellt sicher, dass eine Reservierung mindestens 1 Gast hat
ALTER TABLE Reservierungen
ADD CONSTRAINT CK_Reservierungen_AnzahlGaeste CHECK ([Anzahl_Gaeste] > 0);
GO

-- 3. Stellt sicher, dass Tische eine positive Kapazität haben
ALTER TABLE Tische
ADD CONSTRAINT CK_Tische_Kapazitaet CHECK ([Kapazität] > 0);
GO

-- 4. Stellt sicher, dass die Zahlungssumme immer positiv ist
ALTER TABLE Zahlungen
ADD CONSTRAINT CK_Zahlungen_Betrag CHECK ([Betrag] > 0);
GO

-- 5. Stellt sicher, dass die Menge der Menüprodukte positiv ist
ALTER TABLE MenüProduckte
ADD CONSTRAINT CK_MenüProduckte_Menge CHECK ([Menge] > 0);
GO

-- 6. Beschränkt Reservierungen auf die Öffnungszeiten zwischen 17:00 und 22:00 Uhr
ALTER TABLE Reservierungen
ADD CONSTRAINT CK_Reservierungen_Uhrzeit CHECK ([Uhrzeit] >= '17:00:00' AND [Uhrzeit] <= '22:00:00');
GO

-- 7. Stellt sicher, dass Reservierungen nur den Status 2 (Bestätigt) oder 3 (Storniert) haben können
ALTER TABLE Reservierungen
ADD CONSTRAINT CK_Reservierungen_Status CHECK ([StatusProsID] IN (2, 3));
GO

-- 8. Stellt sicher, dass Bewertungen nur zwischen 1 und 5 Sternen liegen
ALTER TABLE Bewertungen
ADD CONSTRAINT CK_Bewertungen_Sterne CHECK ([Sterne] BETWEEN 1 AND 5);
GO

-- 9. Stellt sicher, dass Rabatte nur zwischen 0% und 100% liegen
ALTER TABLE GastStatus
ADD CONSTRAINT CK_GastStatus_Rabatt CHECK ([Rabatt] BETWEEN 0 AND 100);
GO

-- 10. Stellt sicher, dass Gehälter von Mitarbeitern positiv sind
ALTER TABLE Personal
ADD CONSTRAINT CK_Personal_Gehalt CHECK ([Gehalt] > 0);
GO






