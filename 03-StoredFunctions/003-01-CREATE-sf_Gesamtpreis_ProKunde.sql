USE GenussRest
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 03.02.2025
-- Description:	Diese Funktion berechnet den Gesamtpreis aller Bestellungen eines Gasts unter Ber�cksichtigung von
-- 1. Den bestellten Gerichten und deren Mengen
-- 2. Dem Rabatt des Gasts basierend auf seinem 'GastStatus'
-- =============================================
CREATE OR ALTER FUNCTION sf_Gesamtpreis_ProKunde 
(
	@GastID int --Die ID des Gasts, f�r den der Gesamtpreis berechnet wird
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Gesamtpreis money

	-- Add the T-SQL statements to compute the return value here
	SET @Gesamtpreis = 
	(
		SELECT SUM(Men�.Preis * Bestellpositionen.Menge * (1-CAST(GastStatus.Rabatt AS Decimal(5,2)) / 100))
		FROM dbo.G�ste 
			INNER JOIN Bestellungen ON G�ste.GastID = Bestellungen.GastID
			INNER JOIN Bestellpositionen ON Bestellpositionen.BestellungID = Bestellungen.BestellungID
			INNER JOIN Men� ON Men�.GerichtID = Bestellpositionen.GerichtID
			INNER JOIN GastStatus ON GastStatus.StatusID = G�ste.StatusID
		WHERE G�ste.GastID = @GastID
	
	)

	-- Return the result of the function
	IF @Gesamtpreis IS NULL SET @Gesamtpreis = 0 -- Falls keine Bestellungen vorhanden sind, return 0
	RETURN @Gesamtpreis

END
GO

