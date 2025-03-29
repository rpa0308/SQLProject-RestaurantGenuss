USE GenussRest;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 03.02.2025
-- Description:	Diese Funktion gibt die Informationen zu Bewertungen im Restaurantsystem zurück, 
-- auch wenn keine zugehörigen Bestellungen oder Menüelemente vorhanden sind. 
-- =============================================
CREATE OR ALTER FUNCTION tf_GetBewertungDetails 
(
	@BewertungID int
)
RETURNS TABLE 
AS RETURN
(
	SELECT Bewertungen.BewertungID,
		   Bewertungen.Sterne,
		   Bewertungen.Kommentar,
		   Bewertungen.Datum, 
		   Gäste.Vorname AS GastVorname, Gäste.Nachname AS GastNachname,
		   COALESCE(Menü.Name, 'Keine Bestellungen') AS GerichtName -- Wenn keine Gericht von Menü zugeordnet ist, wird 'keine Bestellungen' zurückgegeben
	FROM Bewertungen
		LEFT JOIN Bestellungen ON Bewertungen.BestellungID = Bestellungen.BestellungID
		LEFT JOIN Gäste ON Bestellungen.GastID = Gäste.GastID
		LEFT JOIN Bestellpositionen ON Bestellungen.BestellungID = Bestellpositionen.BestellungID
		LEFT JOIN Menü ON Bestellpositionen.GerichtID = Menü.GerichtID
	WHERE Bewertungen.BewertungID = @BewertungID

)

GO