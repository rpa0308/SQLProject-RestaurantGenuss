--TEST for @reservation_id =  x!!

--Should change the Reservierungen table.

-- This Reservierungen 5 is in the past cannot be modified => failed Vergangene Reservierungen können nicht storniert werden.

EXEC CancelReservation @reservation_id = 5;

-- There is not such Reservierungen => failed Reservierung nicht gefunden.
EXEC CancelReservation @reservation_id = 17;

-- There is status 3 => failed Reservierung wurde bereits storniert.
EXEC CancelReservation @reservation_id = 4;

--Trying to change a reservation for today => failed Vergangene Reservierungen können nicht storniert werden.
EXEC CancelReservation @reservation_id = 16;

--Should change the Reservierungen.
EXEC CancelReservation @reservation_id = 24;