USE GenussRest;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 01.02.2025
-- Description: 
-- Diese Funktion gibt eine Liste aller verfügbaren Tische für ein bestimmtes Datum, 
-- eine bestimmte Uhrzeit und eine bestimmte Gästeanzahl zurück.
-- =============================================
CREATE OR ALTER FUNCTION GetAvailableTables
(
    @selected_date DATE,
    @selected_time TIME,
    @guest_count INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT T.TischID, T.Tischnummer, T.Kapazität
    FROM Tische T
    WHERE T.Kapazität >= @guest_count
    AND NOT EXISTS (
        SELECT 1 FROM Reservierungen R
        WHERE R.TischID = T.TischID
        AND R.Datum = @selected_date
        AND R.StatusProsID <> 3 -- Ignore cancelled reservations

		-- Check if new reservation would overlap with the restricted 2-hour buffer
        AND (@selected_time < DATEADD(HOUR, 2, R.Uhrzeit)  -- New start time is before the end of the blocked range
        AND DATEADD(HOUR, 2, @selected_time) > R.Uhrzeit) -- New end time is after the start of the blocked range

    )
);
GO
