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
-- Description: Dieser Trigger überwacht UPDATE-Operationen in der Tabelle Gäste und protokolliert Änderungen in der GastLog-Tabelle, 
-- einschließlich alter und neuer Werte, Zeitstempel und des ausführenden Benutzers.
-- =============================================
CREATE OR ALTER TRIGGER trg_Gast_Update
   ON Gäste
   AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
    -- Log only if any of the relevant fields were updated
    IF (UPDATE(Vorname) OR UPDATE(Nachname) OR UPDATE(Telefon) OR UPDATE(Email) OR UPDATE(StatusID))
    BEGIN
        INSERT INTO GastLog (Mode, EditOn, EditUser, GastID, VornameAlt, NachnameAlt, TelefonAlt, EmailAlt, StatusIDAlt, Vorname, Nachname, Telefon, Email, StatusID)
        SELECT 
            'U', GETDATE(), ORIGINAL_LOGIN(),  -- Mode 'U' for update, current timestamp, and user who made the change
            i.GastID, d.Vorname, d.Nachname, d.Telefon, d.Email, d.StatusID,  -- Old values (before update)
            i.Vorname, i.Nachname, i.Telefon, i.Email, i.StatusID  -- New values (after update)
        FROM inserted i
        JOIN deleted d ON i.GastID = d.GastID
        -- Log only if there is an actual change in the values
        WHERE 
            (d.Vorname <> i.Vorname OR d.Nachname <> i.Nachname OR d.Telefon <> i.Telefon OR 
             d.Email <> i.Email OR d.StatusID <> i.StatusID);
    END
END;
GO