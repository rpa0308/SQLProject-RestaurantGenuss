USE GenussRest
GO

-- Test sf_Gesamtpreis_ProKunde --
-- FROM Gäste
-- WHERE GastID = 1

SELECT dbo.sf_Gesamtpreis_ProKunde(1) -- Max Mustermann, 17.5 

SELECT dbo.sf_Gesamtpreis_ProKunde(2) -- Julia Schmidt, 13.68

SELECT dbo.sf_Gesamtpreis_ProKunde(4) -- Maria Hofer, 0, Storniert, keine Bestellungen

SELECT GastID, Vorname, Nachname,
	   dbo.sf_Gesamtpreis_ProKunde(GastID) AS 'Gesamtpreis(Mit Rabatt)'
FROM Gäste
