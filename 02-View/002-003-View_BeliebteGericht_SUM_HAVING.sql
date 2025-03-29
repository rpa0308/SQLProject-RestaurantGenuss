USE [GenussRest]
GO

/****** Object:  View [dbo].[View_BeliebteGerichte]    Script Date: 03.02.2025 12:29:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [dbo].[View_BeliebteGerichte]
AS
SELECT      TOP (100) PERCENT dbo.MenüKategorie.Kategorie,
			dbo.Menü.Name, 
			COUNT(dbo.Bestellpositionen.BestellungID) AS AnzahlBestellungen, 
			SUM(dbo.Bestellpositionen.Menge) AS GesamtMenge
FROM        dbo.MenüKategorie INNER JOIN
            dbo.Menü ON dbo.MenüKategorie.KategorieID = dbo.Menü.KategorieID INNER JOIN
            dbo.Bestellpositionen ON dbo.Menü.GerichtID = dbo.Bestellpositionen.GerichtID
GROUP BY dbo.MenüKategorie.Kategorie, dbo.Menü.Name
HAVING   (SUM(dbo.Bestellpositionen.Menge) >= 3)
ORDER BY dbo.MenüKategorie.Kategorie
GO

