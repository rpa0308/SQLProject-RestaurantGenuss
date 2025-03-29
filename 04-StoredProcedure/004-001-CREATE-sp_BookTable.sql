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
-- Prüft, ob Tische verfügbar sind (unter Verwendung der Funktion GetAvailableTables).
-- Wenn ein Tisch verfügbar ist, wird eine neue Reservierung in der Tabelle Reservierungen eingefügt.
-- Die Eingangsparameter (Datum, Uhrzeit, Gästeanzahl) werden überprüft.
-- Fehler oder Erfolgsmeldungen werden über einen OUTPUT-Parameter zurückgegeben, 
-- sodass das Frontend die Nachricht direkt anzeigen kann.
-- Bei erfolgreicher Reservierung wird die neu generierte Reservierungsnummer (ReservierungID) ebenfalls über OUTPUT zurückgegeben.
-- =============================================
CREATE OR ALTER PROCEDURE BookTable
    @guest_id INT,
    @reservation_date DATE,
    @reservation_time TIME,
    @guest_count INT,
    @newReservationID INT OUTPUT,  -- OUTPUT für ReservierungID
    @message NVARCHAR(255) OUTPUT  -- OUTPUT für Fehlermeldungen
AS
BEGIN
    -- Check: Datum darf nicht in der Vergangenheit sein
    IF @reservation_date <= CAST(GETDATE() AS DATE)
    BEGIN
        SET @message = 'Reservierungen für vergangene Daten sind nicht erlaubt.';
        SET @newReservationID = NULL;
        RETURN;
    END

    -- Check: Uhrzeit muss zwischen 17:00 und 22:00 liegen
    IF @reservation_time < '17:00:00' OR @reservation_time > '22:00:00'
    BEGIN
        SET @message = 'Reservierungen können nur zwischen 17:00 und 22:00 Uhr vorgenommen werden.';
        SET @newReservationID = NULL;
        RETURN;
    END

    -- Suche nach einem freien Tisch
    DECLARE @available_table INT;
    SELECT TOP 1 @available_table = TischID
    FROM dbo.GetAvailableTables(@reservation_date, @reservation_time, @guest_count);

    -- Kein Tisch verfügbar? Fehler zurückgeben
    IF @available_table IS NULL
    BEGIN
        SET @message = 'Für die gewählte Uhrzeit sind keine Tische verfügbar.';
        SET @newReservationID = NULL;
        RETURN;
    END

    -- Reservierung einfügen
    INSERT INTO Reservierungen (GastID, TischID, Datum, Uhrzeit, Anzahl_Gaeste, StatusProsID)
    VALUES (@guest_id, @available_table, @reservation_date, @reservation_time, @guest_count, 2);

    -- ReservierungID zurückgeben
    SET @newReservationID = SCOPE_IDENTITY();
    SET @message = 'Reservierung erfolgreich! Ihre Buchungsnummer: ' + CAST(@newReservationID AS NVARCHAR(10));
END;
GO
