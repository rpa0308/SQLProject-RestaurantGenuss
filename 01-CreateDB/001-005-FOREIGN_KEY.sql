USE [GenussRest];
GO

/* check FOREIGN KEY
SELECT * FROM sys.foreign_keys;*/

-- FK_Reservierungen_Gäste: In der Tabelle Reservierungen wird GastID auf Gäste (GastID) referenziert.
ALTER TABLE [dbo].[Reservierungen]
WITH CHECK
ADD CONSTRAINT [FK_Reservierungen_Gäste]
FOREIGN KEY (GastID)
REFERENCES [dbo].[Gäste] (GastID);
GO

ALTER TABLE [dbo].[Reservierungen]
CHECK CONSTRAINT [FK_Reservierungen_Gäste];
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

-- FK_Bestellposition_Gericht: In der Tabelle Bestellpositionen wird GerichtID auf Menü (GerichtID) referenziert.
ALTER TABLE [dbo].[Bestellpositionen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellposition_Gericht]
FOREIGN KEY (GerichtID)
REFERENCES [dbo].[Menü] (GerichtID);
GO

ALTER TABLE [dbo].[Bestellpositionen]
CHECK CONSTRAINT [FK_Bestellposition_Gericht];
GO

-- FK_Menü_MenüKategorie: In der Tabelle Menü wird KategorieID auf MenüKategorie (KategorieID) referenziert.
ALTER TABLE [dbo].[Menü]
WITH CHECK
ADD CONSTRAINT [FK_Menü_MenüKategorie]
FOREIGN KEY (KategorieID)
REFERENCES [dbo].[MenüKategorie] (KategorieID);
GO

ALTER TABLE [dbo].[Menü]
CHECK CONSTRAINT [FK_Menü_MenüKategorie];
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

-- FK_MenüProdukte_Lagerbestand: In der Tabelle MenüProdukte (hier: [MenüProduckte]) wird LagerID auf Lagerbestand (LagerID) referenziert.
ALTER TABLE [dbo].[MenüProduckte]
WITH CHECK
ADD CONSTRAINT [FK_MenüProdukte_Lagerbestand]
FOREIGN KEY (LagerID)
REFERENCES [dbo].[Lagerbestand] (LagerID);
GO

ALTER TABLE [dbo].[MenüProdukte]
CHECK CONSTRAINT [FK_MenüProdukte_Lagerbestand];
GO

-- FK_MenüProdukte_Menü: In der Tabelle MenüProdukte wird GerichtID auf Menü (GerichtID) referenziert.
ALTER TABLE [dbo].[MenüProdukte]
WITH CHECK
ADD CONSTRAINT [FK_MenüProdukte_Menü]
FOREIGN KEY (GerichtID)
REFERENCES [dbo].[Menü] (GerichtID);
GO

ALTER TABLE [dbo].[MenüProdukte]
CHECK CONSTRAINT [FK_MenüProdukte_Menü];
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

-- FK_Bestellung_Gast: In der Tabelle Bestellungen wird GastID auf Gäste (GastID) referenziert.
ALTER TABLE [dbo].[Bestellungen]
WITH CHECK
ADD CONSTRAINT [FK_Bestellung_Gast]
FOREIGN KEY (GastID)
REFERENCES [dbo].[Gäste] (GastID);
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

-- FK_GastStatus: In der Tabelle Gäste wird StatusID auf GastStatus (StatusID) referenziert.
ALTER TABLE [dbo].[Gäste]
WITH CHECK
ADD CONSTRAINT [FK_GastStatus]
FOREIGN KEY (StatusID)
REFERENCES [dbo].[GastStatus] (StatusID);
GO

ALTER TABLE [dbo].[Gäste]
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
