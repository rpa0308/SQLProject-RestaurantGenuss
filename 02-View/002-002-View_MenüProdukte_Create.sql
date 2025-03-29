USE [GenussRest]
GO


CREATE OR ALTER VIEW [dbo].[View_MenüProdukte]
AS
SELECT        TOP (100) PERCENT dbo.MenüKategorie.Kategorie, dbo.Menü.Name, dbo.Menü.Beschreibung, dbo.Menü.Preis, dbo.Lagerbestand.Produktname, dbo.Einheit.Einheit, dbo.MenüProduckte.Menge, dbo.Lagerbestand.EinheitID, 
                         dbo.Lagerbestand.LagerID, dbo.Menü.GerichtID
FROM            dbo.Menü INNER JOIN
                         dbo.MenüKategorie ON dbo.Menü.KategorieID = dbo.MenüKategorie.KategorieID INNER JOIN
                         dbo.MenüProduckte ON dbo.Menü.GerichtID = dbo.MenüProduckte.GerichtID INNER JOIN
                         dbo.Lagerbestand ON dbo.MenüProduckte.LagerID = dbo.Lagerbestand.LagerID INNER JOIN
                         dbo.Einheit ON dbo.Lagerbestand.EinheitID = dbo.Einheit.EinheitID
ORDER BY dbo.MenüKategorie.Kategorie, dbo.Menü.Name, dbo.Lagerbestand.Produktname
GO


