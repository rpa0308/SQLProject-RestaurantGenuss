USE [GenussRest]
GO

/* ON DELETE CASCADE	When the parent record is deleted (e.g., a guest), all related records in the child table (e.g., orders) are also deleted.
ON DELETE SET NULL	When the parent record is deleted, the foreign key in the child table is set to NULL (e.g., if a guest is deleted, GastID in Bestellungen becomes NULL).
ON DELETE NO ACTION (default)	The database does not allow deleting the parent record if there are dependent records in the child table.
ON DELETE RESTRICT	Similar to NO ACTION, but immediately throws an error when attempting to delete a parent record with dependencies.*/

-- ON DELETE NO ACTION (default) ist Okay:

-- Optional: 
-- If a guest is removed, the order remains, but the GastID becomes NULL.
ALTER TABLE Bestellungen 
DROP CONSTRAINT FK_Bestellung_Gast;

ALTER TABLE Bestellungen 
ADD CONSTRAINT FK_Bestellung_Gast 
FOREIGN KEY (GastID) 
REFERENCES Gäste (GastID) 
ON DELETE SET NULL;

-- If a guest is removed, the reservation remains, but the GastID becomes NULL.
ALTER TABLE Reservierungen 
DROP CONSTRAINT FK_Reservierungen_Gäste;

ALTER TABLE Reservierungen 
ADD CONSTRAINT FK_Reservierungen_Gäste 
FOREIGN KEY (GastID) 
REFERENCES Gäste (GastID) 
ON DELETE SET NULL;

-- If a Tisch is removed, the reservation remains, but the TischID becomes NULL.
ALTER TABLE Reservierungen 
DROP CONSTRAINT FK_Reservierung_Tisch;

ALTER TABLE Reservierungen 
ADD CONSTRAINT FK_Reservierung_Tisch 
FOREIGN KEY (TischID) 
REFERENCES Tische (TischID) 
ON DELETE SET NULL;

-- If a dish is deleted, its composition (Menu Produckte) is also not needed.
ALTER TABLE MenüProduckte 
DROP CONSTRAINT FK_MenüProduckte_Menü;

ALTER TABLE MenüProduckte 
ADD CONSTRAINT FK_MenüProduckte_Menü 
FOREIGN KEY (GerichtID) 
REFERENCES Menü (GerichtID) 
ON DELETE CASCADE;

--If an order is deleted, its items should also be deleted.
ALTER TABLE Bestellpositionen 
DROP CONSTRAINT FK_Bestellposition_Bestellung;

ALTER TABLE Bestellpositionen 
ADD CONSTRAINT FK_Bestellposition_Bestellung 
FOREIGN KEY (BestellungID) 
REFERENCES Bestellungen (BestellungID) 
ON DELETE CASCADE;
