USE GenussRest;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Die View zeigt alle Kunden inklusive jener, die noch keine Bestellungen aufgegeben haben. 
Sie kombiniert Kundeninformationen, Bestellstatistiken und den Kundenstatus mithilfe von LEFT OUTER JOIN 
und der Funktion sf_Gesamtpreis_ProKunde(GastID), um den Gesamtumsatz unter Berücksichtigung von Rabatten zu berechnen.*/

CREATE VIEW [dbo].[View_AnzahlBestellungenStatus]
AS
SELECT 
    s.StatusName,
    s.Rabatt,
    g.Vorname,
    g.Nachname,
    g.GastID,
	COUNT(b.BestellungID) AS AnzahlBestellungen,
    dbo.sf_Gesamtpreis_ProKunde(g.GastID) AS Gesamtumsatz
FROM Gäste g
LEFT OUTER JOIN Bestellungen b ON g.GastID = b.GastID
LEFT OUTER JOIN GastStatus s ON g.StatusID = s.StatusID
GROUP BY g.GastID, g.Vorname, g.Nachname, s.StatusName, s.Rabatt;
GO

-- Verwenden einer sortierten Ansicht
-- SELECT * FROM View_AnzahlBestellungenStatus 
-- ORDER BY Rabatt DESC, Gesamtumsatz DESC;
