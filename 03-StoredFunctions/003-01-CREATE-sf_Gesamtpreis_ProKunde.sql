USE GenussRest
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 03.02.2025
-- Description:	Diese Funktion berechnet den Gesamtpreis aller Bestellungen eines Gasts unter Berücksichtigung von
-- 1. Den bestellten Gerichten und deren Mengen
-- 2. Dem Rabatt des Gasts basierend auf seinem 'GastStatus'
-- =============================================
CREATE OR ALTER FUNCTION sf_Gesamtpreis_ProKunde 
(
	@GastID int --Die ID des Gasts, für den der Gesamtpreis berechnet wird
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Gesamtpreis money

	-- Add the T-SQL statements to compute the return value here
	SET @Gesamtpreis = 
	(
		SELECT SUM(Menü.Preis * Bestellpositionen.Menge * (1-CAST(GastStatus.Rabatt AS Decimal(5,2)) / 100))
		FROM dbo.Gäste 
			INNER JOIN Bestellungen ON Gäste.GastID = Bestellungen.GastID
			INNER JOIN Bestellpositionen ON Bestellpositionen.BestellungID = Bestellungen.BestellungID
			INNER JOIN Menü ON Menü.GerichtID = Bestellpositionen.GerichtID
			INNER JOIN GastStatus ON GastStatus.StatusID = Gäste.StatusID
		WHERE Gäste.GastID = @GastID
	
	)

	-- Return the result of the function
	IF @Gesamtpreis IS NULL SET @Gesamtpreis = 0 -- Falls keine Bestellungen vorhanden sind, return 0
	RETURN @Gesamtpreis

END
GO

