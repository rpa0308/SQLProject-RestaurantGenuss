USE GenussRest;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 03.02.2025
-- Description:	Diese Funktion gibt die Informationen zu Bewertungen im Restaurantsystem zur�ck, 
-- auch wenn keine zugeh�rigen Bestellungen oder Men�elemente vorhanden sind. 
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
		   G�ste.Vorname AS GastVorname, G�ste.Nachname AS GastNachname,
		   COALESCE(Men�.Name, 'Keine Bestellungen') AS GerichtName -- Wenn keine Gericht von Men� zugeordnet ist, wird 'keine Bestellungen' zur�ckgegeben
	FROM Bewertungen
		LEFT JOIN Bestellungen ON Bewertungen.BestellungID = Bestellungen.BestellungID
		LEFT JOIN G�ste ON Bestellungen.GastID = G�ste.GastID
		LEFT JOIN Bestellpositionen ON Bestellungen.BestellungID = Bestellpositionen.BestellungID
		LEFT JOIN Men� ON Bestellpositionen.GerichtID = Men�.GerichtID
	WHERE Bewertungen.BewertungID = @BewertungID

)

GO