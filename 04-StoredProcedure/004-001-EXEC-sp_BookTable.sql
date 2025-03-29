

-- Test 1: Erfolgreiche Reservierung → Sollte eine neue Reservierung erstellen
DECLARE @resID INT;
DECLARE @msg NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-15', 
    @reservation_time = '18:00:00', 
    @guest_count = 4, 
    @newReservationID = @resID OUTPUT, 
    @message = @msg OUTPUT;
PRINT 'Test 1 - Erwartet: Reservierung erfolgreich. Buchungsnummer: ' + CAST(@resID AS NVARCHAR(10));
PRINT 'Nachricht: ' + @msg;

-- Test 2:  Fehler → Datum in der Vergangenheit oder heute
DECLARE @resID2 INT;
DECLARE @msg2 NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-05',  
    @reservation_time = '18:00:00', 
    @guest_count = 4, 
    @newReservationID = @resID2 OUTPUT, 
    @message = @msg2 OUTPUT;
PRINT 'Test 2 - Erwartet: Fehler - Reservierungen für vergangene oder heutige Daten sind nicht erlaubt.';
PRINT 'Nachricht: ' + @msg2;

-- Test 3: Fehler → Uhrzeit außerhalb der Geschäftszeiten
DECLARE @resID3 INT;
DECLARE @msg3 NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-07', 
    @reservation_time = '22:01:00', 
    @guest_count = 4, 
    @newReservationID = @resID3 OUTPUT, 
    @message = @msg3 OUTPUT;
PRINT 'Test 3 - Erwartet: Fehler - Reservierungen nur zwischen 17:00 und 22:00 Uhr.';
PRINT 'Nachricht: ' + @msg3;

-- Test 4: Fehler → Kein Tisch für 9 Gäste verfügbar
DECLARE @resID4 INT;
DECLARE @msg4 NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-07', 
    @reservation_time = '18:00:00', 
    @guest_count = 9, 
    @newReservationID = @resID4 OUTPUT, 
    @message = @msg4 OUTPUT;
PRINT 'Test 4 - Erwartet: Fehler - Kein passender Tisch verfügbar.';
PRINT 'Nachricht: ' + @msg4;


-- Tisch Nr. 5 (8): Reservierungen von 19:00 bis 21:00 Uhr ('2025-02-13'): 

-- Test 5:  Fehler → Ist es möglich, für 17:30 - 19:30 Uhr zu buchen? (NEIN) → Keine freien Tische
--Überschneidet sich mit 19:00 - 21:00 → Nicht zulässig.
DECLARE @resID5 INT;
DECLARE @msg5 NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-13', 
    @reservation_time = '17:30:00', 
    @guest_count = 8, 
    @newReservationID = @resID5 OUTPUT, 
    @message = @msg5 OUTPUT;
PRINT 'Test 5 - Erwartet: Fehler - Kein Tisch um 17:30:00 verfügbar.';
PRINT 'Nachricht: ' + @msg5;

-- Test 6:  Fehler → Ist es möglich, für 20:30 - 22:30 zu buchen? (NEIN) → Keine freien Tische
--Überschneidet sich mit 19:00 - 21:00 → Nicht zulässig.
DECLARE @resID5 INT;
DECLARE @msg5 NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-13', 
    @reservation_time = '20:30:00', 
    @guest_count = 8, 
    @newReservationID = @resID5 OUTPUT, 
    @message = @msg5 OUTPUT;
PRINT 'Test 6 - Erwartet: Fehler - Kein Tisch um 20:30:00 verfügbar.';
PRINT 'Nachricht: ' + @msg5;

-- Test 7:  Erfolgreiche Reservierung um 17:00
-- Neue Reservierung endet pünktlich um 19:00 Uhr → Akzeptabel.
DECLARE @resID5 INT;
DECLARE @msg5 NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-13', 
    @reservation_time = '17:00:00', 
    @guest_count = 8, 
    @newReservationID = @resID5 OUTPUT, 
    @message = @msg5 OUTPUT;
PRINT 'Test 7 - Erwartet: Reservierung erfolgreich. Buchungsnummer: ' + CAST(@resID5 AS NVARCHAR(10));
PRINT 'Nachricht: ' + @msg5;

-- Test 8:  Erfolgreiche Reservierung um 21:00
-- Neue Reservierung startet pünktlich um 21:00 Uhr → Akzeptabel.
DECLARE @resID5 INT;
DECLARE @msg5 NVARCHAR(255);
EXEC BookTable 
    @guest_id = 1, 
    @reservation_date = '2025-02-13', 
    @reservation_time = '21:00:00', 
    @guest_count = 8, 
    @newReservationID = @resID5 OUTPUT, 
    @message = @msg5 OUTPUT;
PRINT 'Test 8 - Erwartet: Reservierung erfolgreich. Buchungsnummer: ' + CAST(@resID5 AS NVARCHAR(10));
PRINT 'Nachricht: ' + @msg5;

