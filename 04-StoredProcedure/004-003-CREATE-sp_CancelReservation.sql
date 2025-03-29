USE [GenussRest]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Gruppe G
-- Create date: 01.02.2025
-- Description:
-- - Ermöglicht das Stornieren einer bestehenden Reservierung.
-- - Überprüft, ob die Reservierung existiert.
-- - Prüft, ob die Reservierung nicht bereits storniert wurde (StatusProsID ≠ 3).
-- - Stellt sicher, dass das Reservierungsdatum in der Zukunft liegt (nicht heute oder in der Vergangenheit).
-- - Falls erfolgreich, wird der Status auf "3" (storniert) gesetzt.
-- - Optional: Eine Stornierungsnotiz oder ein Logeintrag kann hinzugefügt werden.
-- =============================================
CREATE OR ALTER PROCEDURE CancelReservation
    @reservation_id INT
AS
BEGIN
    -- Checking that the reservation exists
    IF NOT EXISTS (SELECT 1 FROM Reservierungen WHERE ReservierungID = @reservation_id)
    BEGIN
        PRINT 'Reservierung nicht gefunden.';
        RETURN;
    END

    -- Checking that the booking has not been cancelled already (StatusProsID = 3)
    IF EXISTS (SELECT 1 FROM Reservierungen WHERE ReservierungID = @reservation_id AND StatusProsID = 3)
    BEGIN
        PRINT 'Reservierung wurde bereits storniert.';
        RETURN;
    END

    -- Checking that the reservation is not in the past
    IF EXISTS (SELECT 1 FROM Reservierungen WHERE ReservierungID = @reservation_id AND Datum <= CAST(GETDATE() AS DATE))
    BEGIN
        PRINT 'Vergangene Reservierungen können nicht storniert werden.';
        RETURN;
    END

    -- Mark reservation as cancelled
    UPDATE Reservierungen
    SET StatusProsID = 3
    WHERE ReservierungID = @reservation_id;

    -- Optional: Logging the cancellation
/*    INSERT INTO ReservationLog (ReservierungID, Aktion, Änderungsdatum)
    VALUES (@reservation_id, 'Cancelled', GETDATE()); */

    PRINT 'Reservierung erfolgreich storniert!';
END
GO
