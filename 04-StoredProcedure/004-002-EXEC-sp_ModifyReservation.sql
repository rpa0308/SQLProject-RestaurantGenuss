--TEST for @reservation_id =  x!!

--Should change the Reservierungen table.

-- This Reservierungen 5 is in the past cannot be modified 
EXEC ModifyReservation @reservation_id = 5, @new_date = '2025-02-10', @new_time = '19:00:00', @new_guest_count = 4;

-- There is not such Reservierungen
EXEC ModifyReservation @reservation_id = 17, @new_date = '2025-02-15', @new_time = '18:00:00', @new_guest_count = 2;

-- There is status 3 => failed
EXEC ModifyReservation @reservation_id = 20, @new_date = '2025-02-15', @new_time = '18:00:00', @new_guest_count = 2;


--Trying to change a reservation for today (should be rejected) => Reservierungen können nur für zukünftige Daten geändert werden.
EXEC ModifyReservation @reservation_id = 16, @new_date = '2025-02-01', @new_time = '19:00:00', @new_guest_count = 4;

--Attempt to change to a time outside of 17-22 (should fail) => Reservierungen können nur zwischen 17:00 und 22:00 Uhr geändert werden.
EXEC ModifyReservation @reservation_id = 24, @new_date = '2025-02-10', @new_time = '16:00:00', @new_guest_count = 4;

--Failed no table.
EXEC ModifyReservation @reservation_id = 24, @new_date = '2025-02-10', @new_time = '18:00:00', @new_guest_count = 10;

--Should change the Reservierungen.
EXEC ModifyReservation @reservation_id = 24, @new_date = '2025-02-09', @new_time = '21:45:00', @new_guest_count = 2;




