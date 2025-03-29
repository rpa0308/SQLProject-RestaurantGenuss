USE GenussRest;
GO
-- ================================================
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 03.02.2025
-- Description: Dieser Trigger �berwacht INSERT-Operationen in der Tabelle G�ste und protokolliert �nderungen in der GastLog-Tabelle, 
-- einschlie�lich alter und neuer Werte, Zeitstempel und des ausf�hrenden Benutzers.
-- =============================================

CREATE OR ALTER TRIGGER trg_Gast_Insert
	ON G�ste
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO GastLog (Mode, GastID, Vorname, Nachname, Telefon, Email, StatusID)
    SELECT 'I', i.GastID, i.Vorname, i.Nachname, i.Telefon, i.Email, i.StatusID
    FROM inserted i;
END;
GO