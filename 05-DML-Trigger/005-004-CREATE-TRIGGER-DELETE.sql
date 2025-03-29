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
-- Description: Dieser Trigger überwacht DELETE-Operationen in der Tabelle Gäste und protokolliert Änderungen in der GastLog-Tabelle, 
-- einschließlich alter und neuer Werte, Zeitstempel und des ausführenden Benutzers.
-- =============================================
CREATE OR ALTER TRIGGER trg_Gast_Delete
	ON Gäste
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
    INSERT INTO GastLog (Mode, GastID, VornameAlt, NachnameAlt, TelefonAlt, EmailAlt, StatusIDAlt)
    SELECT 'D', d.GastID, d.Vorname, d.Nachname, d.Telefon, d.Email, d.StatusID
    FROM deleted d;
END;
GO