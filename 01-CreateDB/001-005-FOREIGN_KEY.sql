USE [GenussRest];
GO

/* check FOREIGN KEY
SELECT * FROM sys.foreign_keys;*/

-- FK_Reservierungen_G�ste: In der Tabelle Reservierungen wird GastID auf G�ste (GastID) referenziert.
ALTER TABLE [dbo].[Reservierungen]
WITH CHECK
ADD CONSTRAINT [FK_Reservierungen_G�ste]
FOREIGN KEY (GastID)
REFERENCES [dbo].[G�ste] (GastID);
GO

ALTER TABLE [dbo].[Reservierungen]
CHECK CONSTRAINT [FK_Reservierungen_G�ste];
GO

-- FK_Bestellung_Reservierung: In der Tabelle Bestellungen wird ReservierungID auf Reservierungen (ReservierungID) referenziert.
ALTER TABLE [dbo].[Bestellungen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellung_Reservierung]
FOREIGN KEY (ReservierungID)
REFERENCES [dbo].[Reservierungen] (ReservierungID);
GO

ALTER TABLE [dbo].[Bestellungen]
CHECK CONSTRAINT [FK_Bestellung_Reservierung];
GO

-- FK_Reservierungen_ProzStatus: In der Tabelle Reservierungen wird StatusProsID auf ProzStatus (StatusProsID) referenziert.
ALTER TABLE [dbo].[Reservierungen]
WITH CHECK
ADD CONSTRAINT [FK_Reservierungen_ProzStatus]
FOREIGN KEY (StatusProsID)
REFERENCES [dbo].[ProzStatus] (StatusProsID);
GO

ALTER TABLE [dbo].[Reservierungen]
CHECK CONSTRAINT [FK_Reservierungen_ProzStatus];
GO

-- FK_Reservierung_Tisch: In der Tabelle Reservierungen wird TischID auf Tische (TischID) referenziert.
ALTER TABLE [dbo].[Reservierungen]
WITH CHECK
ADD CONSTRAINT [FK_Reservierung_Tisch]
FOREIGN KEY (TischID)
REFERENCES [dbo].[Tische] (TischID);
GO

ALTER TABLE [dbo].[Reservierungen]
CHECK CONSTRAINT [FK_Reservierung_Tisch];
GO

-- FK_Zahlung_Bestellung: In der Tabelle Zahlungen wird BestellungID auf Bestellungen (BestellungID) referenziert.
ALTER TABLE [dbo].[Zahlungen]
WITH CHECK
ADD CONSTRAINT [FK_Zahlung_Bestellung]
FOREIGN KEY (BestellungID)
REFERENCES [dbo].[Bestellungen] (BestellungID);
GO

ALTER TABLE [dbo].[Zahlungen]
CHECK CONSTRAINT [FK_Zahlung_Bestellung];
GO

-- FK_Zahlungen_ProzStatus: In der Tabelle Zahlungen wird StatusProsID auf ProzStatus (StatusProsID) referenziert.
ALTER TABLE [dbo].[Zahlungen]
WITH CHECK
ADD CONSTRAINT [FK_Zahlungen_ProzStatus]
FOREIGN KEY (StatusProsID)
REFERENCES [dbo].[ProzStatus] (StatusProsID);
GO

ALTER TABLE [dbo].[Zahlungen]
CHECK CONSTRAINT [FK_Zahlungen_ProzStatus];
GO

-- FK_Bestellposition_Gericht: In der Tabelle Bestellpositionen wird GerichtID auf Men� (GerichtID) referenziert.
ALTER TABLE [dbo].[Bestellpositionen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellposition_Gericht]
FOREIGN KEY (GerichtID)
REFERENCES [dbo].[Men�] (GerichtID);
GO

ALTER TABLE [dbo].[Bestellpositionen]
CHECK CONSTRAINT [FK_Bestellposition_Gericht];
GO

-- FK_Men�_Men�Kategorie: In der Tabelle Men� wird KategorieID auf Men�Kategorie (KategorieID) referenziert.
ALTER TABLE [dbo].[Men�]
WITH CHECK
ADD CONSTRAINT [FK_Men�_Men�Kategorie]
FOREIGN KEY (KategorieID)
REFERENCES [dbo].[Men�Kategorie] (KategorieID);
GO

ALTER TABLE [dbo].[Men�]
CHECK CONSTRAINT [FK_Men�_Men�Kategorie];
GO

-- FK_Lagerbestand_Einheit: In der Tabelle Lagerbestand wird EinheitID auf Einheit (EinheitID) referenziert.
ALTER TABLE [dbo].[Lagerbestand]
WITH CHECK
ADD CONSTRAINT [FK_Lagerbestand_Einheit]
FOREIGN KEY (EinheitID)
REFERENCES [dbo].[Einheit] (EinheitID);
GO

ALTER TABLE [dbo].[Lagerbestand]
CHECK CONSTRAINT [FK_Lagerbestand_Einheit];
GO

-- FK_Men�Produkte_Lagerbestand: In der Tabelle Men�Produkte (hier: [Men�Produckte]) wird LagerID auf Lagerbestand (LagerID) referenziert.
ALTER TABLE [dbo].[Men�Produckte]
WITH CHECK
ADD CONSTRAINT [FK_Men�Produkte_Lagerbestand]
FOREIGN KEY (LagerID)
REFERENCES [dbo].[Lagerbestand] (LagerID);
GO

ALTER TABLE [dbo].[Men�Produkte]
CHECK CONSTRAINT [FK_Men�Produkte_Lagerbestand];
GO

-- FK_Men�Produkte_Men�: In der Tabelle Men�Produkte wird GerichtID auf Men� (GerichtID) referenziert.
ALTER TABLE [dbo].[Men�Produkte]
WITH CHECK
ADD CONSTRAINT [FK_Men�Produkte_Men�]
FOREIGN KEY (GerichtID)
REFERENCES [dbo].[Men�] (GerichtID);
GO

ALTER TABLE [dbo].[Men�Produkte]
CHECK CONSTRAINT [FK_Men�Produkte_Men�];
GO

-- FK_Bestellposition_Bestellung: In der Tabelle Bestellpositionen wird BestellungID auf Bestellungen (BestellungID) referenziert.
ALTER TABLE [dbo].[Bestellpositionen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellposition_Bestellung]
FOREIGN KEY (BestellungID)
REFERENCES [dbo].[Bestellungen] (BestellungID);
GO

ALTER TABLE [dbo].[Bestellpositionen]
CHECK CONSTRAINT [FK_Bestellposition_Bestellung];
GO

-- FK_Bestellungen_ProzStatus1: In der Tabelle Bestellungen wird StatusProsID auf ProzStatus (StatusProsID) referenziert.
ALTER TABLE [dbo].[Bestellungen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellungen_ProzStatus1]
FOREIGN KEY (StatusProsID)
REFERENCES [dbo].[ProzStatus] (StatusProsID);
GO

ALTER TABLE [dbo].[Bestellungen]
CHECK CONSTRAINT [FK_Bestellungen_ProzStatus1];
GO

-- FK_Bestellung_Gast: In der Tabelle Bestellungen wird GastID auf G�ste (GastID) referenziert.
ALTER TABLE [dbo].[Bestellungen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellung_Gast]
FOREIGN KEY (GastID)
REFERENCES [dbo].[G�ste] (GastID);
GO

ALTER TABLE [dbo].[Bestellungen]
CHECK CONSTRAINT [FK_Bestellung_Gast];
GO

-- FK_Bewertungen_Bestellungen: In der Tabelle Bewertungen wird BestellungID auf Bestellungen (BestellungID) referenziert.
ALTER TABLE [dbo].[Bewertungen]
WITH CHECK
ADD CONSTRAINT [FK_Bewertungen_Bestellungen]
FOREIGN KEY (BestellungID)
REFERENCES [dbo].[Bestellungen] (BestellungID);
GO

ALTER TABLE [dbo].[Bewertungen]
CHECK CONSTRAINT [FK_Bewertungen_Bestellungen];
GO

-- FK_GastStatus: In der Tabelle G�ste wird StatusID auf GastStatus (StatusID) referenziert.
ALTER TABLE [dbo].[G�ste]
WITH CHECK
ADD CONSTRAINT [FK_GastStatus]
FOREIGN KEY (StatusID)
REFERENCES [dbo].[GastStatus] (StatusID);
GO

ALTER TABLE [dbo].[G�ste]
CHECK CONSTRAINT [FK_GastStatus];
GO

-- FK_Bestellungen_Personal: In der Tabelle Bestellungen wird MitarbeiterID auf Personal (MitarbeiterID) referenziert.
ALTER TABLE [dbo].[Bestellungen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellungen_Personal]
FOREIGN KEY (MitarbeiterID)
REFERENCES [dbo].[Personal] (MitarbeiterID);
GO

ALTER TABLE [dbo].[Bestellungen]
CHECK CONSTRAINT [FK_Bestellungen_Personal];
GO
