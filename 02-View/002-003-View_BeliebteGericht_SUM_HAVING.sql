USE [GenussRest]
GO

/****** Object:  View [dbo].[View_BeliebteGerichte]    Script Date: 03.02.2025 12:29:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [dbo].[View_BeliebteGerichte]
AS
SELECT      TOP (100) PERCENT dbo.Men�Kategorie.Kategorie,
			dbo.Men�.Name, 
			COUNT(dbo.Bestellpositionen.BestellungID) AS AnzahlBestellungen, 
			SUM(dbo.Bestellpositionen.Menge) AS GesamtMenge
FROM        dbo.Men�Kategorie INNER JOIN
            dbo.Men� ON dbo.Men�Kategorie.KategorieID = dbo.Men�.KategorieID INNER JOIN
            dbo.Bestellpositionen ON dbo.Men�.GerichtID = dbo.Bestellpositionen.GerichtID
GROUP BY dbo.Men�Kategorie.Kategorie, dbo.Men�.Name
HAVING   (SUM(dbo.Bestellpositionen.Menge) >= 3)
ORDER BY dbo.Men�Kategorie.Kategorie
GO

