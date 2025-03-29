USE [GenussRest]
GO


CREATE OR ALTER VIEW [dbo].[View_Men�Produkte]
AS
SELECT        TOP (100) PERCENT dbo.Men�Kategorie.Kategorie, dbo.Men�.Name, dbo.Men�.Beschreibung, dbo.Men�.Preis, dbo.Lagerbestand.Produktname, dbo.Einheit.Einheit, dbo.Men�Produckte.Menge, dbo.Lagerbestand.EinheitID, 
                         dbo.Lagerbestand.LagerID, dbo.Men�.GerichtID
FROM            dbo.Men� INNER JOIN
                         dbo.Men�Kategorie ON dbo.Men�.KategorieID = dbo.Men�Kategorie.KategorieID INNER JOIN
                         dbo.Men�Produckte ON dbo.Men�.GerichtID = dbo.Men�Produckte.GerichtID INNER JOIN
                         dbo.Lagerbestand ON dbo.Men�Produckte.LagerID = dbo.Lagerbestand.LagerID INNER JOIN
                         dbo.Einheit ON dbo.Lagerbestand.EinheitID = dbo.Einheit.EinheitID
ORDER BY dbo.Men�Kategorie.Kategorie, dbo.Men�.Name, dbo.Lagerbestand.Produktname
GO


