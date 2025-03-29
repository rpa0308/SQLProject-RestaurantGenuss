USE [GenussRest]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 01.02.2025
-- Description: 
-- - Ermöglicht die Änderung einer bestehenden Reservierung, sofern sie nicht storniert wurde.
-- - Überprüft, ob die Reservierung existiert.
-- - Prüft, ob die Reservierung nicht bereits storniert wurde (StatusProsID ≠ 3).
-- - Stellt sicher, dass das neue Datum in der Zukunft liegt (nicht heute oder in der Vergangenheit).
-- - Prüft, ob die neue Uhrzeit innerhalb der Öffnungszeiten (17:00 - 22:00 Uhr) liegt.
-- - Überprüft, ob für die neue Gästeanzahl ein geeigneter Tisch verfügbar ist (verwendet GetAvailableTables).
-- - Falls erfolgreich, wird die Reservierung aktualisiert
-- =============================================
CREATE OR ALTER PROCEDURE ModifyReservation
    @reservation_id INT,
    @new_date DATE,
    @new_time TIME,
    @new_guest_count INT
AS
BEGIN
    -- Checking that the reservation exists
    IF NOT EXISTS (SELECT 1 FROM Reservierungen WHERE ReservierungID = @reservation_id)
    BEGIN
        PRINT 'Reservierung nicht gefunden.';
        RETURN;
    END

    -- Checking that the booking has not been cancelled (StatusProsID = 3)
    IF EXISTS (SELECT 1 FROM Reservierungen WHERE ReservierungID = @reservation_id AND StatusProsID = 3)
    BEGIN
        PRINT 'Reservierung wurde bereits storniert und kann nicht geändert werden.';
        RETURN;
    END

    -- Checking that the reservation is not in the past
    IF EXISTS (SELECT 1 FROM Reservierungen WHERE ReservierungID = @reservation_id AND Datum <= CAST(GETDATE() AS DATE))
    BEGIN
        PRINT 'Vergangene Reservierungen können nicht geändert werden.';
        RETURN;
    END

    -- We prohibit changes to today or to the past
    IF @new_date <= CAST(GETDATE() AS DATE)
    BEGIN
        PRINT 'Reservierungen können nur für zukünftige Daten geändert werden.';
        RETURN;
    END

    -- We check that the time is within 17:00 - 22:00
    IF @new_time < '17:00:00' OR @new_time > '22:00:00'
    BEGIN
        PRINT 'Reservierungen können nur zwischen 17:00 und 22:00 Uhr geändert werden.';
        RETURN;
    END

    -- Now call the function to get available tables
    DECLARE @available_table INT;
    SELECT TOP 1 @available_table = TischID
    FROM dbo.GetAvailableTables(@new_date, @new_time, @new_guest_count);

    -- If no table is available, return an error message
    IF @available_table IS NULL
    BEGIN
        PRINT 'Kein passender Tisch für die neue Reservierung verfügbar.';
        RETURN;
    END

    -- Otherwise, update reservation
    UPDATE Reservierungen
    SET Datum = @new_date,
        Uhrzeit = @new_time,
        Anzahl_Gaeste = @new_guest_count,
        TischID = @available_table
    WHERE ReservierungID = @reservation_id;

    -- We can make log
/*    INSERT INTO ReservationLog (ReservierungID, Aktion, Änderungsdatum)
    VALUES (@reservation_id, 'Modified', GETDATE()); */

    PRINT 'Reservierung erfolgreich geändert!';
END




