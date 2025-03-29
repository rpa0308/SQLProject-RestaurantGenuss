USE GenussRest;
GO

-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 03.02.2025
-- Description: Dieser Trigger �berwacht DELETE-Operationen in der Tabelle G�ste und protokolliert �nderungen in der GastLog-Tabelle, 
-- einschlie�lich alter und neuer Werte, Zeitstempel und des ausf�hrenden Benutzers.
-- =============================================
CREATE OR ALTER TRIGGER trg_Gast_Delete
	ON G�ste
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
    INSERT INTO GastLog (Mode, GastID, VornameAlt, NachnameAlt, TelefonAlt, EmailAlt, StatusIDAlt)
    SELECT 'D', d.GastID, d.Vorname, d.Nachname, d.Telefon, d.Email, d.StatusID
    FROM deleted d;
END;
GO