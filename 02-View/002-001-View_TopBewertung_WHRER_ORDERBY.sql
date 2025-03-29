USE [GenussRest]
GO

/****** Object:  View [dbo].[View_TopBewertung]    Script Date: 03.02.2025 11:03:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [dbo].[View_TopBewertung]
AS
SELECT        TOP (100) PERCENT dbo.Bewertungen.BewertungID, dbo.Bewertungen.Sterne, dbo.Bewertungen.Kommentar, dbo.Gäste.Nachname, dbo.Gäste.Vorname, dbo.Menü.Name
FROM            dbo.Bewertungen INNER JOIN
                         dbo.Bestellungen ON dbo.Bewertungen.BestellungID = dbo.Bestellungen.BestellungID INNER JOIN
                         dbo.Gäste ON dbo.Bestellungen.GastID = dbo.Gäste.GastID INNER JOIN
                         dbo.Bestellpositionen ON dbo.Bestellungen.BestellungID = dbo.Bestellpositionen.BestellungID INNER JOIN
                         dbo.Menü ON dbo.Bestellpositionen.GerichtID = dbo.Menü.GerichtID
WHERE        (dbo.Bewertungen.Sterne >= 4)
ORDER BY dbo.Bewertungen.Sterne
GO

