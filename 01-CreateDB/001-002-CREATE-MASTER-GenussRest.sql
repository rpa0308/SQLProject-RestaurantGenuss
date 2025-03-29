USE [GenussRest]
GO
/****** Object:  User [RestKellner]    Script Date: 05.02.2025 14:00:17 ******/
CREATE USER [RestKellner] FOR LOGIN [RestKellner] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [RestManager]    Script Date: 05.02.2025 14:00:17 ******/
CREATE USER [RestManager] FOR LOGIN [RestManager] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [Kellner]    Script Date: 05.02.2025 14:00:17 ******/
CREATE ROLE [Kellner]
GO
ALTER ROLE [Kellner] ADD MEMBER [RestKellner]
GO
/****** Object:  UserDefinedFunction [dbo].[sf_Gesamtpreis_ProKunde]    Script Date: 05.02.2025 14:00:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE   FUNCTION [dbo].[sf_Gesamtpreis_ProKunde] 
(
	@GastID int
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Gesamtpreis money

	-- Add the T-SQL statements to compute the return value here
	SET @Gesamtpreis = 
	(
		SELECT SUM(Menü.Preis * Bestellpositionen.Menge * (1-CAST(GastStatus.Rabatt AS Decimal(5,2)) / 100))
		FROM dbo.Gäste 
			INNER JOIN Bestellungen ON Gäste.GastID = Bestellungen.GastID
			INNER JOIN Bestellpositionen ON Bestellpositionen.BestellungID = Bestellungen.BestellungID
			INNER JOIN Menü ON Menü.GerichtID = Bestellpositionen.GerichtID
			INNER JOIN GastStatus ON GastStatus.StatusID = Gäste.StatusID
		WHERE Gäste.GastID = @GastID
	
	)

	-- Return the result of the function
	IF @Gesamtpreis IS NULL SET @Gesamtpreis = 0
	RETURN @Gesamtpreis

END
GO
/****** Object:  UserDefinedFunction [dbo].[sf_Gesamtpreis_ProKundeBestellung]    Script Date: 05.02.2025 14:00:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

CREATE     FUNCTION [dbo].[sf_Gesamtpreis_ProKundeBestellung] 
(
	@GastID int, --Die ID des Gasts, für den der Gesamtpreis berechnet wird
	@BestellungID int
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Gesamtpreis money

	-- Add the T-SQL statements to compute the return value here
	SET @Gesamtpreis = 
	(
		SELECT SUM(Menü.Preis * Bestellpositionen.Menge * (1-CAST(GastStatus.Rabatt AS Decimal(5,2)) / 100))
		FROM dbo.Gäste 
			INNER JOIN Bestellungen ON Gäste.GastID = Bestellungen.GastID
			INNER JOIN Bestellpositionen ON Bestellpositionen.BestellungID = Bestellungen.BestellungID
			INNER JOIN Menü ON Menü.GerichtID = Bestellpositionen.GerichtID
			INNER JOIN GastStatus ON GastStatus.StatusID = Gäste.StatusID
		WHERE Gäste.GastID = @GastID and Bestellungen.BestellungID=@BestellungID
	
	)

	-- Return the result of the function
	IF @Gesamtpreis IS NULL SET @Gesamtpreis = 0 -- Falls keine Bestellungen vorhanden sind, return 0
	RETURN @Gesamtpreis

END
GO
/****** Object:  UserDefinedFunction [dbo].[sf_Zeitstempel]    Script Date: 05.02.2025 14:00:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE   FUNCTION [dbo].[sf_Zeitstempel]
(
)
RETURNS char(18)
AS
BEGIN
	RETURN FORMAT(GETDATE(), 'yyyyMMdd-HHmmssfff');
END
GO
/****** Object:  Table [dbo].[Reservierungen]    Script Date: 05.02.2025 14:00:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservierungen](
	[ReservierungID] [int] IDENTITY(1,1) NOT NULL,
	[GastID] [int] NOT NULL,
	[TischID] [int] NOT NULL,
	[Datum] [date] NOT NULL,
	[Uhrzeit] [time](0) NOT NULL,
	[Anzahl_Gaeste] [int] NOT NULL,
	[StatusProsID] [int] NOT NULL,
 CONSTRAINT [PK__Reservie__C10B1F5DF410B814] PRIMARY KEY CLUSTERED 
(
	[ReservierungID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tische]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tische](
	[TischID] [int] IDENTITY(1,1) NOT NULL,
	[Tischnummer] [varchar](10) NOT NULL,
	[Kapazität] [int] NOT NULL,
	[Verfügbar] [bit] NOT NULL,
 CONSTRAINT [PK__Tische__60BC005F6EA464FB] PRIMARY KEY CLUSTERED 
(
	[TischID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetAvailableTables]    Script Date: 05.02.2025 14:00:18 ******/
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
CREATE   FUNCTION [dbo].[GetAvailableTables]
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
/****** Object:  UserDefinedFunction [dbo].[VerfugbarkeitTische]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 01.02.2025
-- Description:
--Die Funktion dbo.VerfugbarkeitTische berechnet für einen bestimmten Tag die Verfügbarkeit der Tische im Restaurant.
--Sie aggregiert Buchungsdaten und ermittelt für jeden Tisch die reservierten Zeiträume sowie die verfügbaren Zeitintervalle.
--Dabei werden stornierte Reservierungen ausgeschlossen und die Öffnungszeiten (von 17:00 bis 00:00) berücksichtigt.
--Das Ergebnis liefert eine übersichtliche Darstellung, welche Tische zu welchen Zeiten belegt oder frei sind, 
--sodass das Personal stets den aktuellen Stand einsehen kann.
-- =============================================
CREATE   FUNCTION [dbo].[VerfugbarkeitTische] (@selected_date DATE)
RETURNS TABLE
AS
RETURN
(
   WITH ResCTE AS (
         SELECT 
             T.TischID,
             T.Tischnummer,
             T.Kapazität,
             R.ReservierungID,
             -- Convert TIME to DATETIME using the provided date:
             DATEADD(SECOND, DATEDIFF(SECOND, 0, R.Uhrzeit), CAST(@selected_date AS DATETIME)) AS StartTime,
             DATEADD(HOUR, 2, DATEADD(SECOND, DATEDIFF(SECOND, 0, R.Uhrzeit), CAST(@selected_date AS DATETIME))) AS EndTime,
             R.Anzahl_Gaeste,
             R.GastID
         FROM Reservierungen R
         JOIN Tische T ON T.TischID = R.TischID
         WHERE R.Datum = @selected_date
           AND R.StatusProsID <> 3  -- exclude canceled reservations
   ),
   Booked AS (
         SELECT
             @selected_date AS Datum,
             Tischnummer,
             Kapazität,
             ReservierungID,
             CONVERT(TIME(0), StartTime) AS Reservierungsbeginn,
             CONVERT(TIME(0), EndTime)   AS Reservierungsende,
             'Gebucht' AS Status,
             NULL AS VerfuegbarVon,
             NULL AS VerfuegbarBis,
             Anzahl_Gaeste,
             GastID
         FROM ResCTE
   ),
   AvailableBefore AS (
         SELECT
             @selected_date AS Datum,
             T.Tischnummer,
             T.Kapazität,
             NULL AS ReservierungID,
             NULL AS Reservierungsbeginn,
             NULL AS Reservierungsende,
             'Verfügbar' AS Status,
             CAST('17:00:00' AS TIME(0)) AS VerfuegbarVon,
             CONVERT(TIME(0), MIN(r.StartTime)) AS VerfuegbarBis,
             NULL AS Anzahl_Gaeste,
             NULL AS GastID
         FROM Tische T
         JOIN ResCTE r ON T.TischID = r.TischID
         GROUP BY T.TischID, T.Tischnummer, T.Kapazität
         HAVING MIN(r.StartTime) > DATEADD(HOUR, 17, CAST(@selected_date AS DATETIME))
   ),
   AvailableBetween AS (
         SELECT
             Datum,
             Tischnummer,
             Kapazität,
             ReservierungID,
             Reservierungsbeginn,
             Reservierungsende,
             Status,
             VerfuegbarVon,
             VerfuegbarBis,
             Anzahl_Gaeste,
             GastID
         FROM (
             SELECT
                 @selected_date AS Datum,
                 t.Tischnummer,
                 t.Kapazität,
                 NULL AS ReservierungID,
                 NULL AS Reservierungsbeginn,
                 NULL AS Reservierungsende,
                 'Verfügbar' AS Status,
                 CONVERT(TIME(0), r.EndTime) AS VerfuegbarVon,
                 CONVERT(TIME(0), LEAD(r.StartTime) OVER (PARTITION BY r.TischID ORDER BY r.StartTime)) AS VerfuegbarBis,
                 r.EndTime AS CurrentEndTime,
                 LEAD(r.StartTime) OVER (PARTITION BY r.TischID ORDER BY r.StartTime) AS NextStartTime,
                 NULL AS Anzahl_Gaeste,
                 NULL AS GastID
             FROM ResCTE r
             JOIN Tische t ON r.TischID = t.TischID
         ) AS sub
         WHERE NextStartTime IS NOT NULL
           AND CurrentEndTime < NextStartTime
   ),
   AvailableAfter AS (
         SELECT
             @selected_date AS Datum,
             T.Tischnummer,
             T.Kapazität,
             NULL AS ReservierungID,
             NULL AS Reservierungsbeginn,
             NULL AS Reservierungsende,
             'Verfügbar' AS Status,
             CONVERT(TIME(0), MAX(r.EndTime)) AS VerfuegbarVon,
             CAST('00:00:00' AS TIME(0)) AS VerfuegbarBis,
             NULL AS Anzahl_Gaeste,
             NULL AS GastID
         FROM Tische T
         JOIN ResCTE r ON T.TischID = r.TischID
         GROUP BY T.TischID, T.Tischnummer, T.Kapazität
         HAVING MAX(r.EndTime) < DATEADD(HOUR, 24, CAST(@selected_date AS DATETIME))
   ),
   NoReservations AS (
         SELECT
             @selected_date AS Datum,
             T.Tischnummer,
             T.Kapazität,
             NULL AS ReservierungID,
             NULL AS Reservierungsbeginn,
             NULL AS Reservierungsende,
             'Verfügbar' AS Status,
             CAST('17:00:00' AS TIME(0)) AS VerfuegbarVon,
             CAST('00:00:00' AS TIME(0)) AS VerfuegbarBis,
             NULL AS Anzahl_Gaeste,
             NULL AS GastID
         FROM Tische T
         WHERE NOT EXISTS (
             SELECT 1 
             FROM Reservierungen R 
             WHERE R.TischID = T.TischID 
               AND R.Datum = @selected_date
               AND R.StatusProsID <> 3
         )
   ),
   Combined AS (
         SELECT * FROM Booked
         UNION ALL
         SELECT * FROM AvailableBefore
         UNION ALL
         SELECT * FROM AvailableBetween
         UNION ALL
         SELECT * FROM AvailableAfter
         UNION ALL
         SELECT * FROM NoReservations
   )
   SELECT 
         CONVERT(VARCHAR(10), Datum, 104) AS Datum,
         Tischnummer,
         Kapazität,
         ReservierungID,
         Reservierungsbeginn,
         Reservierungsende,
         Status,
         VerfuegbarVon,
         VerfuegbarBis,
         Anzahl_Gaeste,
         GastID
   FROM Combined
);
GO
/****** Object:  Table [dbo].[Bestellpositionen]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bestellpositionen](
	[BestellpositionID] [int] IDENTITY(1,1) NOT NULL,
	[BestellungID] [int] NOT NULL,
	[GerichtID] [int] NOT NULL,
	[Menge] [int] NOT NULL,
 CONSTRAINT [PK__Bestellp__C75911298A26F89C] PRIMARY KEY CLUSTERED 
(
	[BestellpositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menü]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menü](
	[GerichtID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Beschreibung] [ntext] NULL,
	[Preis] [money] NOT NULL,
	[KategorieID] [int] NOT NULL,
 CONSTRAINT [PK__Menü__41280BF12EAD9D4F] PRIMARY KEY CLUSTERED 
(
	[GerichtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bestellungen]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bestellungen](
	[BestellungID] [int] IDENTITY(1,1) NOT NULL,
	[ReservierungID] [int] NULL,
	[GastID] [int] NOT NULL,
	[MitarbeiterID] [int] NOT NULL,
	[Datum] [date] NOT NULL,
	[Uhrzeit] [time](0) NOT NULL,
	[StatusProsID] [int] NOT NULL,
 CONSTRAINT [PK__Bestellu__285B074B63C5FD25] PRIMARY KEY CLUSTERED 
(
	[BestellungID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gäste]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gäste](
	[GastID] [int] IDENTITY(1,1) NOT NULL,
	[Vorname] [nvarchar](50) NOT NULL,
	[Nachname] [nvarchar](50) NOT NULL,
	[Telefon] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[StatusID] [int] NOT NULL,
 CONSTRAINT [PK__Gäste__BFEA2217CD612BFE] PRIMARY KEY CLUSTERED 
(
	[GastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bewertungen]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bewertungen](
	[BewertungID] [int] IDENTITY(1,1) NOT NULL,
	[BestellungID] [int] NOT NULL,
	[Sterne] [int] NOT NULL,
	[Kommentar] [ntext] NULL,
	[Datum] [date] NOT NULL,
 CONSTRAINT [PK__Bewertun__FA36210062BD87C1] PRIMARY KEY CLUSTERED 
(
	[BewertungID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[tf_GetBewertungDetails]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   FUNCTION [dbo].[tf_GetBewertungDetails] 
(
	@BewertungID int
)
RETURNS TABLE 
AS RETURN
(
	SELECT Bewertungen.BewertungID,
		   Bewertungen.Sterne,
		   Bewertungen.Kommentar,
		   Bewertungen.Datum, 
		   Gäste.Vorname AS GastVorname, Gäste.Nachname AS GastNachname,
		   COALESCE(Menü.Name, 'Keine Bestellungen') AS GerichtName
	FROM Bewertungen
		LEFT JOIN Bestellungen ON Bewertungen.BestellungID = Bestellungen.BestellungID
		LEFT JOIN Gäste ON Bestellungen.GastID = Gäste.GastID
		LEFT JOIN Bestellpositionen ON Bestellungen.BestellungID = Bestellpositionen.BestellungID
		LEFT JOIN Menü ON Bestellpositionen.GerichtID = Menü.GerichtID
	WHERE Bewertungen.BewertungID = @BewertungID

)

GO
/****** Object:  Table [dbo].[GastStatus]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GastStatus](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [nvarchar](50) NOT NULL,
	[Rabatt] [int] NOT NULL,
 CONSTRAINT [PK__GastStat__C8EE20437AD3919D] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_AnzahlBestellungenStatus]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_AnzahlBestellungenStatus]
AS
SELECT 
    s.StatusName,
    s.Rabatt,
    g.Vorname,
    g.Nachname,
    g.GastID,
	COUNT(b.BestellungID) AS AnzahlBestellungen,
    dbo.sf_Gesamtpreis_ProKunde(g.GastID) AS Gesamtumsatz
FROM Gäste g
LEFT OUTER JOIN Bestellungen b ON g.GastID = b.GastID
LEFT OUTER JOIN GastStatus s ON g.StatusID = s.StatusID
GROUP BY g.GastID, g.Vorname, g.Nachname, s.StatusName, s.Rabatt;
GO
/****** Object:  Table [dbo].[MenüKategorie]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenüKategorie](
	[KategorieID] [int] IDENTITY(1,1) NOT NULL,
	[Kategorie] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_MenüKategorie] PRIMARY KEY CLUSTERED 
(
	[KategorieID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lagerbestand]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lagerbestand](
	[LagerID] [int] IDENTITY(1,1) NOT NULL,
	[Produktname] [nvarchar](100) NOT NULL,
	[Menge] [decimal](5, 2) NOT NULL,
	[EinheitID] [int] NOT NULL,
	[MindestensHaltbarBis] [date] NULL,
 CONSTRAINT [PK__Lagerbes__23FED8A9FCA15C73] PRIMARY KEY CLUSTERED 
(
	[LagerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenüProduckte]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenüProduckte](
	[MenüLagerID] [int] IDENTITY(1,1) NOT NULL,
	[GerichtID] [int] NOT NULL,
	[LagerID] [int] NOT NULL,
	[Menge] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK__Menü_Lag__AE57E3D34FDE8676] PRIMARY KEY CLUSTERED 
(
	[MenüLagerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_MenüProdukte]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[View_MenüProdukte]
AS
SELECT        TOP (100) PERCENT dbo.MenüKategorie.Kategorie, dbo.Menü.Name, dbo.Menü.Beschreibung, dbo.Menü.Preis, dbo.Lagerbestand.Produktname, dbo.Lagerbestand.EinheitID, dbo.Lagerbestand.LagerID, dbo.Menü.GerichtID, 
                         dbo.MenüProduckte.Menge
FROM            dbo.Menü INNER JOIN
                         dbo.MenüKategorie ON dbo.Menü.KategorieID = dbo.MenüKategorie.KategorieID INNER JOIN
                         dbo.MenüProduckte ON dbo.Menü.GerichtID = dbo.MenüProduckte.GerichtID INNER JOIN
                         dbo.Lagerbestand ON dbo.MenüProduckte.LagerID = dbo.Lagerbestand.LagerID
ORDER BY dbo.MenüKategorie.Kategorie, dbo.Menü.Name, dbo.Lagerbestand.Produktname
GO
/****** Object:  View [dbo].[View_BeliebteGerichte]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[View_BeliebteGerichte]
AS
SELECT        TOP (100) PERCENT dbo.MenüKategorie.Kategorie, dbo.Menü.Name, COUNT(dbo.Bestellpositionen.BestellungID) AS AnzahlBestellungen, SUM(dbo.Bestellpositionen.Menge) AS GesamtMenge
FROM            dbo.MenüKategorie INNER JOIN
                         dbo.Menü ON dbo.MenüKategorie.KategorieID = dbo.Menü.KategorieID INNER JOIN
                         dbo.Bestellpositionen ON dbo.Menü.GerichtID = dbo.Bestellpositionen.GerichtID
GROUP BY dbo.MenüKategorie.Kategorie, dbo.Menü.Name
HAVING        (SUM(dbo.Bestellpositionen.Menge) >= 3)
ORDER BY dbo.MenüKategorie.Kategorie
GO
/****** Object:  View [dbo].[View_TopBewertung]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[View_TopBewertung]
AS
SELECT        TOP (100) PERCENT dbo.Bewertungen.BewertungID, dbo.Bewertungen.Sterne, dbo.Bewertungen.Kommentar, dbo.Gäste.Nachname, dbo.Gäste.Vorname, dbo.Menü.Name
FROM            dbo.Bewertungen INNER JOIN
                         dbo.Bestellungen ON dbo.Bewertungen.BestellungID = dbo.Bestellungen.BestellungID INNER JOIN
                         dbo.Gäste ON dbo.Bestellungen.GastID = dbo.Gäste.GastID INNER JOIN
                         dbo.Bestellpositionen ON dbo.Bestellungen.BestellungID = dbo.Bestellpositionen.BestellungID INNER JOIN
                         dbo.Menü ON dbo.Bestellpositionen.GerichtID = dbo.Menü.GerichtID
WHERE        (dbo.Bewertungen.Sterne >= 4)
ORDER BY dbo.Bewertungen.Sterne
GO
/****** Object:  Table [dbo].[Einheit]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Einheit](
	[EinheitID] [int] IDENTITY(1,1) NOT NULL,
	[Einheit] [nvarchar](10) NULL,
 CONSTRAINT [PK_Einheit] PRIMARY KEY CLUSTERED 
(
	[EinheitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GastLog]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GastLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Mode] [char](1) NOT NULL,
	[EditOn] [datetime] NOT NULL,
	[EditUser] [nvarchar](100) NOT NULL,
	[GastID] [int] NOT NULL,
	[VornameAlt] [nvarchar](50) NULL,
	[Vorname] [nvarchar](50) NULL,
	[NachnameAlt] [nvarchar](50) NULL,
	[Nachname] [nvarchar](50) NULL,
	[TelefonAlt] [nvarchar](50) NULL,
	[Telefon] [nvarchar](50) NULL,
	[EmailAlt] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[StatusIDAlt] [int] NULL,
	[StatusID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personal]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personal](
	[MitarbeiterID] [int] IDENTITY(1,1) NOT NULL,
	[Vorname] [nvarchar](50) NOT NULL,
	[Nachname] [nvarchar](50) NOT NULL,
	[Position] [nvarchar](50) NOT NULL,
	[Telefon] [varchar](20) NULL,
	[Gehalt] [money] NOT NULL,
 CONSTRAINT [PK__Personal__6D10A9B1441F74FB] PRIMARY KEY CLUSTERED 
(
	[MitarbeiterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProzStatus]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProzStatus](
	[StatusProsID] [int] IDENTITY(1,1) NOT NULL,
	[StatusPros] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_ProzStatus] PRIMARY KEY CLUSTERED 
(
	[StatusProsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Zahlungen]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Zahlungen](
	[ZahlungID] [int] IDENTITY(1,1) NOT NULL,
	[BestellungID] [int] NOT NULL,
	[Betrag] [money] NOT NULL,
	[Datum] [date] NOT NULL,
	[Zahlungsart] [varchar](50) NOT NULL,
	[StatusProsID] [int] NOT NULL,
 CONSTRAINT [PK__Zahlunge__5F21E579701C9B8B] PRIMARY KEY CLUSTERED 
(
	[ZahlungID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bestellpositionen] ON 
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (1, 1, 1, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (2, 1, 4, 2)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (3, 2, 2, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (4, 2, 4, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (5, 3, 3, 2)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (6, 3, 6, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (7, 5, 1, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (8, 5, 3, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (9, 6, 2, 2)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (10, 6, 6, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (11, 7, 1, 2)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (12, 7, 4, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (13, 8, 3, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (14, 8, 1, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (15, 9, 9, 2)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (16, 9, 4, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (17, 10, 6, 2)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (18, 11, 2, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (19, 12, 7, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (20, 12, 10, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (21, 11, 10, 2)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (22, 11, 10, 1)
GO
INSERT [dbo].[Bestellpositionen] ([BestellpositionID], [BestellungID], [GerichtID], [Menge]) VALUES (23, 11, 10, 2)
GO
SET IDENTITY_INSERT [dbo].[Bestellpositionen] OFF
GO
SET IDENTITY_INSERT [dbo].[Bestellungen] ON 
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (1, 1, 1, 1, CAST(N'2023-08-01' AS Date), CAST(N'18:15:00' AS Time), 1)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (2, 2, 2, 4, CAST(N'2023-08-02' AS Date), CAST(N'20:00:00' AS Time), 2)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (3, 3, 3, 1, CAST(N'2023-08-03' AS Date), CAST(N'20:30:00' AS Time), 2)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (4, 4, 4, 2, CAST(N'2023-08-04' AS Date), CAST(N'17:45:00' AS Time), 3)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (5, 5, 5, 1, CAST(N'2023-08-05' AS Date), CAST(N'21:15:00' AS Time), 1)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (6, 6, 6, 1, CAST(N'2023-08-06' AS Date), CAST(N'18:45:00' AS Time), 2)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (7, NULL, 7, 1, CAST(N'2023-08-07' AS Date), CAST(N'19:30:00' AS Time), 2)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (8, 8, 8, 6, CAST(N'2023-08-10' AS Date), CAST(N'17:15:00' AS Time), 1)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (9, 9, 10, 7, CAST(N'2023-08-11' AS Date), CAST(N'19:40:00' AS Time), 1)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (10, 10, 12, 8, CAST(N'2023-08-12' AS Date), CAST(N'20:10:00' AS Time), 1)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (11, 2, 9, 6, CAST(N'2023-08-11' AS Date), CAST(N'18:00:00' AS Time), 2)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (12, NULL, 11, 7, CAST(N'2023-08-13' AS Date), CAST(N'21:00:00' AS Time), 2)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (15, NULL, 14, 8, CAST(N'2025-02-01' AS Date), CAST(N'19:30:30' AS Time), 1)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (17, NULL, 5, 3, CAST(N'2025-02-03' AS Date), CAST(N'17:00:00' AS Time), 1)
GO
INSERT [dbo].[Bestellungen] ([BestellungID], [ReservierungID], [GastID], [MitarbeiterID], [Datum], [Uhrzeit], [StatusProsID]) VALUES (20, NULL, 1, 2, CAST(N'2025-02-03' AS Date), CAST(N'17:00:00' AS Time), 2)
GO
SET IDENTITY_INSERT [dbo].[Bestellungen] OFF
GO
SET IDENTITY_INSERT [dbo].[Bewertungen] ON 
GO
INSERT [dbo].[Bewertungen] ([BewertungID], [BestellungID], [Sterne], [Kommentar], [Datum]) VALUES (1, 1, 5, N'Super Service, danke!', CAST(N'2023-08-02' AS Date))
GO
INSERT [dbo].[Bewertungen] ([BewertungID], [BestellungID], [Sterne], [Kommentar], [Datum]) VALUES (2, 5, 4, N'Alles war lecker', CAST(N'2023-08-06' AS Date))
GO
INSERT [dbo].[Bewertungen] ([BewertungID], [BestellungID], [Sterne], [Kommentar], [Datum]) VALUES (3, 3, 3, N'Ganz okay', CAST(N'2023-08-04' AS Date))
GO
INSERT [dbo].[Bewertungen] ([BewertungID], [BestellungID], [Sterne], [Kommentar], [Datum]) VALUES (4, 4, 1, N'Reservierung ausgefallen', CAST(N'2023-08-05' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Bewertungen] OFF
GO
SET IDENTITY_INSERT [dbo].[Einheit] ON 
GO
INSERT [dbo].[Einheit] ([EinheitID], [Einheit]) VALUES (1, N'kg')
GO
INSERT [dbo].[Einheit] ([EinheitID], [Einheit]) VALUES (2, N'Liter')
GO
INSERT [dbo].[Einheit] ([EinheitID], [Einheit]) VALUES (3, N'Stück')
GO
SET IDENTITY_INSERT [dbo].[Einheit] OFF
GO
SET IDENTITY_INSERT [dbo].[Gäste] ON 
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (1, N'Max', N'Mustermann', N'+49 160 1234567', N'max.mustermann@dmx.de', 1)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (2, N'Julia', N'Schmidt', N'+49 170 9876543', N'julia.schmidt@gmail.com', 2)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (3, N'Thomas', N'Klein', N'+49 152 5551234', N'thomas.klein@dmx.de', 3)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (4, N'Maria', N'Hofer', N'+49 171 2223344', N'maria.hofer@dmx.de', 2)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (5, N'Anne', N'Wagner', N'+49 152 9998887', N'anne.wagner@dmx.de', 1)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (6, N'Lukas', N'Fischer', N'+49 151 4422331', N'lukas.fischer@dmx.de', 4)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (7, N'Sara', N'Lehmann', N'+49 172 5566778', N'sara.lehmann@dmx.de', 5)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (8, N'Anna', N'Vogel', N'+49 152 9876512', N'[email protected]', 3)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (9, N'David', N'Blum', N'+49 159 3332224', N'[email protected]', 1)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (10, N'Johanna', N'Kraus', N'+49 172 3451236', N'[email protected]', 2)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (11, N'Kevin', N'Roth', N'+49 177 9981122', N'[email protected]', 4)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (12, N'Linda', N'Bach', N'+49 171 5566772', N'[email protected]', 5)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (14, N'Walk-in', N'Anonyme Gäst', NULL, NULL, 1)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (17, N'Sarah ', N'Knull', N'+49 172 5563244', N'sarah.knull@gmx.de', 1)
GO
INSERT [dbo].[Gäste] ([GastID], [Vorname], [Nachname], [Telefon], [Email], [StatusID]) VALUES (19, N'Laura', N'DeVries', N'+49 159 3332233', N'laura.devries@gmx.de', 1)
GO
SET IDENTITY_INSERT [dbo].[Gäste] OFF
GO
SET IDENTITY_INSERT [dbo].[GastLog] ON 
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (1, N'I', CAST(N'2025-02-03T22:23:07.640' AS DateTime), N'Tim-PC\Polina', 19, NULL, N'Laura', NULL, N'DeVries', NULL, N'+49 159 3332233', NULL, N'laura.devries@gmx.de', NULL, 1)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (2, N'I', CAST(N'2025-02-03T22:27:25.903' AS DateTime), N'Tim-PC\Polina', 20, NULL, N'Test-Trigger-Name', NULL, N'Test-Trigger-Vorname', NULL, N'Test-Mobile', NULL, N'Test-email', NULL, 1)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (3, N'D', CAST(N'2025-02-03T22:36:33.870' AS DateTime), N'Tim-PC\Polina', 20, N'Test-Trigger-Name', NULL, N'Test-Trigger-Vorname', NULL, N'Test-Mobile', NULL, N'Test-email', NULL, 1, NULL)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (10, N'U', CAST(N'2025-02-03T23:09:06.700' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'Muhuis', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.devries@gmx.de', 1, 1)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (11, N'U', CAST(N'2025-02-03T23:09:09.090' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'Muhuis', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.devries@gmx.de', 1, 1)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (12, N'U', CAST(N'2025-02-03T23:09:11.117' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.muhuis@gmx.de', 1, 1)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (13, N'U', CAST(N'2025-02-03T23:09:12.947' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.muhuis@gmx.de', N'laura.devries@gmx.de', 1, 1)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (14, N'U', CAST(N'2025-02-03T23:09:14.950' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.devries@gmx.de', 1, 2)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (15, N'U', CAST(N'2025-02-03T23:10:33.287' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'Muhuis', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.devries@gmx.de', 2, 2)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (16, N'U', CAST(N'2025-02-03T23:10:34.593' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'Muhuis', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.devries@gmx.de', 2, 2)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (17, N'U', CAST(N'2025-02-03T23:10:35.577' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.muhuis@gmx.de', 2, 2)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (18, N'U', CAST(N'2025-02-03T23:10:36.890' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.muhuis@gmx.de', N'laura.devries@gmx.de', 2, 2)
GO
INSERT [dbo].[GastLog] ([ID], [Mode], [EditOn], [EditUser], [GastID], [VornameAlt], [Vorname], [NachnameAlt], [Nachname], [TelefonAlt], [Telefon], [EmailAlt], [Email], [StatusIDAlt], [StatusID]) VALUES (19, N'U', CAST(N'2025-02-03T23:13:06.883' AS DateTime), N'Tim-PC\Polina', 19, N'Laura', N'Laura', N'DeVries', N'DeVries', N'+49 159 3332233', N'+49 159 3332233', N'laura.devries@gmx.de', N'laura.devries@gmx.de', 2, 1)
GO
SET IDENTITY_INSERT [dbo].[GastLog] OFF
GO
SET IDENTITY_INSERT [dbo].[GastStatus] ON 
GO
INSERT [dbo].[GastStatus] ([StatusID], [StatusName], [Rabatt]) VALUES (1, N'Basic', 0)
GO
INSERT [dbo].[GastStatus] ([StatusID], [StatusName], [Rabatt]) VALUES (2, N'Bronze', 5)
GO
INSERT [dbo].[GastStatus] ([StatusID], [StatusName], [Rabatt]) VALUES (3, N'Silber', 10)
GO
INSERT [dbo].[GastStatus] ([StatusID], [StatusName], [Rabatt]) VALUES (4, N'Gold', 15)
GO
INSERT [dbo].[GastStatus] ([StatusID], [StatusName], [Rabatt]) VALUES (5, N'Platin', 20)
GO
SET IDENTITY_INSERT [dbo].[GastStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[Lagerbestand] ON 
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (1, N'Tomatensauce', CAST(10.00 AS Decimal(5, 2)), 2, CAST(N'2023-09-15' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (2, N'Mozzarella', CAST(5.00 AS Decimal(5, 2)), 1, CAST(N'2023-08-20' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (3, N'Nudeln', CAST(20.00 AS Decimal(5, 2)), 1, CAST(N'2024-01-01' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (4, N'Hackfleisch', CAST(2.00 AS Decimal(5, 2)), 1, CAST(N'2023-08-10' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (5, N'Salat', CAST(3.00 AS Decimal(5, 2)), 1, CAST(N'2023-08-08' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (6, N'Lachs', CAST(4.60 AS Decimal(5, 2)), 1, CAST(N'2023-08-12' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (7, N'Mehl', CAST(25.00 AS Decimal(5, 2)), 1, CAST(N'2023-11-30' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (8, N'Olivenöl', CAST(3.00 AS Decimal(5, 2)), 2, CAST(N'2023-10-05' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (9, N'Käse', CAST(0.50 AS Decimal(5, 2)), 1, CAST(N'2023-09-15' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (10, N'Eier', CAST(-3.00 AS Decimal(5, 2)), 3, CAST(N'2023-08-15' AS Date))
GO
INSERT [dbo].[Lagerbestand] ([LagerID], [Produktname], [Menge], [EinheitID], [MindestensHaltbarBis]) VALUES (11, N'Cola', CAST(25.50 AS Decimal(5, 2)), 2, CAST(N'2025-02-03' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Lagerbestand] OFF
GO
SET IDENTITY_INSERT [dbo].[Menü] ON 
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (1, N'Pizza Margherita', N'Tomaten, Mozzarella, Basilikum', 8.5000, 3)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (2, N'Spaghetti Bolognese', N'Nudeln, Hackfleischsoße', 9.9000, 3)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (3, N'Caesar Salad', N'Römersalat, Dressing, Huhn', 7.0000, 4)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (4, N'Tiramisu', N'Klassische Süßspeise aus Italien', 4.5000, 1)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (5, N'Minestrone', N'Italienische Gemüsesuppe', 6.0000, 4)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (6, N'Lachsfilet', N'Gegrillt, mit Zitronensoße', 12.9000, 3)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (7, N'Apfelsaft', N'Fruchtiger Saft', 3.0000, 2)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (8, N'Cola', N'Erfrischungsgetränk', 2.5000, 2)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (9, N'Steak', N'Rindfleisch gegrillt', 14.9000, 3)
GO
INSERT [dbo].[Menü] ([GerichtID], [Name], [Beschreibung], [Preis], [KategorieID]) VALUES (10, N'Käsespätzle', N'Nudeln mit Käse', 8.9000, 3)
GO
SET IDENTITY_INSERT [dbo].[Menü] OFF
GO
SET IDENTITY_INSERT [dbo].[MenüKategorie] ON 
GO
INSERT [dbo].[MenüKategorie] ([KategorieID], [Kategorie]) VALUES (1, N'Dessert')
GO
INSERT [dbo].[MenüKategorie] ([KategorieID], [Kategorie]) VALUES (2, N'Getränk')
GO
INSERT [dbo].[MenüKategorie] ([KategorieID], [Kategorie]) VALUES (3, N'Hauptgericht')
GO
INSERT [dbo].[MenüKategorie] ([KategorieID], [Kategorie]) VALUES (4, N'Vorspeise')
GO
SET IDENTITY_INSERT [dbo].[MenüKategorie] OFF
GO
SET IDENTITY_INSERT [dbo].[MenüProduckte] ON 
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (1, 1, 1, CAST(0.10 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (2, 1, 2, CAST(0.20 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (3, 1, 7, CAST(0.10 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (4, 2, 3, CAST(0.15 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (5, 2, 4, CAST(0.15 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (6, 2, 1, CAST(0.05 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (7, 3, 5, CAST(0.20 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (8, 4, 7, CAST(0.05 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (9, 5, 1, CAST(0.20 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (10, 5, 5, CAST(0.15 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (11, 6, 6, CAST(0.20 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (12, 9, 8, CAST(0.05 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (13, 10, 9, CAST(0.30 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (14, 10, 10, CAST(3.00 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (15, 1, 9, CAST(0.50 AS Decimal(5, 2)))
GO
INSERT [dbo].[MenüProduckte] ([MenüLagerID], [GerichtID], [LagerID], [Menge]) VALUES (16, 8, 11, CAST(0.50 AS Decimal(5, 2)))
GO
SET IDENTITY_INSERT [dbo].[MenüProduckte] OFF
GO
SET IDENTITY_INSERT [dbo].[Personal] ON 
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (1, N'Hans', N'Müller', N'Kellner', N'+49 162 2233445', 2000.0000)
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (2, N'Anna', N'Schulz', N'Köchin', N'+49 162 8877665', 2500.0000)
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (3, N'Peter', N'Weber', N'Manager', N'+49 163 4455667', 3000.0000)
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (4, N'Elena', N'Bauer', N'Kellnerin', N'+49 172 2233445', 2100.0000)
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (5, N'Felix', N'Neumann', N'Koch', N'+49 175 6677889', 2600.0000)
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (6, N'Martin', N'König', N'Kellner', N'+49 162 3344556', 2200.0000)
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (7, N'Sofie', N'Lange', N'Köchin', N'+49 174 9988776', 2550.0000)
GO
INSERT [dbo].[Personal] ([MitarbeiterID], [Vorname], [Nachname], [Position], [Telefon], [Gehalt]) VALUES (8, N'Jonas', N'Beck', N'Manager', N'+49 173 1122334', 3050.0000)
GO
SET IDENTITY_INSERT [dbo].[Personal] OFF
GO
SET IDENTITY_INSERT [dbo].[ProzStatus] ON 
GO
INSERT [dbo].[ProzStatus] ([StatusProsID], [StatusPros]) VALUES (1, N'Abgeschlossen')
GO
INSERT [dbo].[ProzStatus] ([StatusProsID], [StatusPros]) VALUES (2, N'Offen')
GO
INSERT [dbo].[ProzStatus] ([StatusProsID], [StatusPros]) VALUES (3, N'Storniert')
GO
SET IDENTITY_INSERT [dbo].[ProzStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[Reservierungen] ON 
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (1, 1, 1, CAST(N'2023-08-01' AS Date), CAST(N'18:00:00' AS Time), 2, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (2, 2, 2, CAST(N'2023-08-02' AS Date), CAST(N'19:30:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (3, 3, 3, CAST(N'2023-08-03' AS Date), CAST(N'20:00:00' AS Time), 3, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (4, 4, 3, CAST(N'2023-08-04' AS Date), CAST(N'17:30:00' AS Time), 2, 3)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (5, 5, 6, CAST(N'2023-08-05' AS Date), CAST(N'19:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (6, 6, 4, CAST(N'2023-08-06' AS Date), CAST(N'18:30:00' AS Time), 5, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (7, 7, 5, CAST(N'2023-08-07' AS Date), CAST(N'19:00:00' AS Time), 6, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (8, 8, 6, CAST(N'2023-08-10' AS Date), CAST(N'17:00:00' AS Time), 2, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (9, 10, 7, CAST(N'2023-08-11' AS Date), CAST(N'19:30:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (10, 12, 8, CAST(N'2023-08-12' AS Date), CAST(N'20:00:00' AS Time), 2, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (13, 2, 5, CAST(N'2025-02-07' AS Date), CAST(N'22:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (16, 5, 7, CAST(N'2025-02-01' AS Date), CAST(N'17:00:00' AS Time), 8, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (20, 5, 8, CAST(N'2025-02-07' AS Date), CAST(N'17:00:00' AS Time), 1, 3)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (23, 12, 5, CAST(N'2025-02-07' AS Date), CAST(N'17:00:00' AS Time), 7, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (24, 1, 1, CAST(N'2025-02-09' AS Date), CAST(N'21:45:00' AS Time), 2, 3)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (27, 2, 3, CAST(N'2025-02-10' AS Date), CAST(N'18:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (29, 3, 4, CAST(N'2025-02-10' AS Date), CAST(N'18:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (30, 4, 5, CAST(N'2025-02-10' AS Date), CAST(N'18:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (31, 1, 1, CAST(N'2025-02-10' AS Date), CAST(N'17:30:00' AS Time), 2, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (33, 6, 2, CAST(N'2025-02-07' AS Date), CAST(N'18:00:00' AS Time), 3, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (36, 3, 3, CAST(N'2025-02-07' AS Date), CAST(N'19:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (38, 3, 7, CAST(N'2025-02-07' AS Date), CAST(N'19:00:00' AS Time), 7, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (39, 4, 4, CAST(N'2025-02-07' AS Date), CAST(N'17:30:00' AS Time), 5, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (40, 7, 6, CAST(N'2025-02-07' AS Date), CAST(N'20:00:00' AS Time), 2, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (41, 1, 2, CAST(N'2025-02-11' AS Date), CAST(N'18:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (42, 1, 2, CAST(N'2025-02-12' AS Date), CAST(N'18:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (43, 1, 2, CAST(N'2025-02-13' AS Date), CAST(N'18:00:00' AS Time), 4, 3)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (44, 1, 7, CAST(N'2025-02-07' AS Date), CAST(N'18:00:00' AS Time), 7, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (45, 1, 2, CAST(N'2025-02-07' AS Date), CAST(N'17:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (47, 1, 6, CAST(N'2025-02-07' AS Date), CAST(N'18:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (48, 2, 5, CAST(N'2025-02-13' AS Date), CAST(N'19:00:00' AS Time), 8, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (49, 2, 7, CAST(N'2025-02-13' AS Date), CAST(N'18:00:00' AS Time), 8, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (58, 2, 7, CAST(N'2025-02-13' AS Date), CAST(N'20:00:00' AS Time), 8, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (60, 2, 7, CAST(N'2025-02-13' AS Date), CAST(N'22:00:00' AS Time), 8, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (61, 1, 2, CAST(N'2025-02-15' AS Date), CAST(N'18:00:00' AS Time), 4, 2)
GO
INSERT [dbo].[Reservierungen] ([ReservierungID], [GastID], [TischID], [Datum], [Uhrzeit], [Anzahl_Gaeste], [StatusProsID]) VALUES (63, 1, 5, CAST(N'2025-02-07' AS Date), CAST(N'20:30:00' AS Time), 8, 2)
GO
SET IDENTITY_INSERT [dbo].[Reservierungen] OFF
GO
SET IDENTITY_INSERT [dbo].[Tische] ON 
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (1, N'T1', 2, 1)
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (2, N'T2', 4, 1)
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (3, N'T3', 4, 1)
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (4, N'T4', 6, 1)
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (5, N'T5', 8, 1)
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (6, N'T6', 4, 1)
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (7, N'T7', 8, 1)
GO
INSERT [dbo].[Tische] ([TischID], [Tischnummer], [Kapazität], [Verfügbar]) VALUES (8, N'T8', 2, 1)
GO
SET IDENTITY_INSERT [dbo].[Tische] OFF
GO
SET IDENTITY_INSERT [dbo].[Zahlungen] ON 
GO
INSERT [dbo].[Zahlungen] ([ZahlungID], [BestellungID], [Betrag], [Datum], [Zahlungsart], [StatusProsID]) VALUES (1, 1, 25.5000, CAST(N'2023-08-01' AS Date), N'Karte', 1)
GO
INSERT [dbo].[Zahlungen] ([ZahlungID], [BestellungID], [Betrag], [Datum], [Zahlungsart], [StatusProsID]) VALUES (2, 5, 15.0000, CAST(N'2023-08-05' AS Date), N'Bar', 1)
GO
INSERT [dbo].[Zahlungen] ([ZahlungID], [BestellungID], [Betrag], [Datum], [Zahlungsart], [StatusProsID]) VALUES (3, 9, 48.5000, CAST(N'2023-08-11' AS Date), N'Karte', 1)
GO
INSERT [dbo].[Zahlungen] ([ZahlungID], [BestellungID], [Betrag], [Datum], [Zahlungsart], [StatusProsID]) VALUES (4, 8, 35.0000, CAST(N'2023-08-10' AS Date), N'Bar', 1)
GO
INSERT [dbo].[Zahlungen] ([ZahlungID], [BestellungID], [Betrag], [Datum], [Zahlungsart], [StatusProsID]) VALUES (5, 10, 22.0000, CAST(N'2023-08-12' AS Date), N'Karte', 1)
GO
INSERT [dbo].[Zahlungen] ([ZahlungID], [BestellungID], [Betrag], [Datum], [Zahlungsart], [StatusProsID]) VALUES (6, 11, 17.5000, CAST(N'2025-02-07' AS Date), N'Bar', 2)
GO
SET IDENTITY_INSERT [dbo].[Zahlungen] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__GastStat__05E7698A33579491]    Script Date: 05.02.2025 14:00:18 ******/
ALTER TABLE [dbo].[GastStatus] ADD  CONSTRAINT [UQ__GastStat__05E7698A33579491] UNIQUE NONCLUSTERED 
(
	[StatusName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Tische__244AE5FE553002C0]    Script Date: 05.02.2025 14:00:18 ******/
ALTER TABLE [dbo].[Tische] ADD  CONSTRAINT [UQ__Tische__244AE5FE553002C0] UNIQUE NONCLUSTERED 
(
	[Tischnummer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bestellungen] ADD  CONSTRAINT [DF__Bestellun__Statu__571DF1D5]  DEFAULT ((2)) FOR [StatusProsID]
GO
ALTER TABLE [dbo].[GastLog] ADD  DEFAULT (getdate()) FOR [EditOn]
GO
ALTER TABLE [dbo].[GastLog] ADD  DEFAULT (original_login()) FOR [EditUser]
GO
ALTER TABLE [dbo].[GastStatus] ADD  CONSTRAINT [DF__GastStatu__Rabat__5DCAEF64]  DEFAULT ((0.00)) FOR [Rabatt]
GO
ALTER TABLE [dbo].[Reservierungen] ADD  CONSTRAINT [DF__Reservier__Statu__5EBF139D]  DEFAULT ((2)) FOR [StatusProsID]
GO
ALTER TABLE [dbo].[Tische] ADD  CONSTRAINT [DF__Tische__Verfügba__5FB337D6]  DEFAULT ((1)) FOR [Verfügbar]
GO
ALTER TABLE [dbo].[Zahlungen] ADD  CONSTRAINT [DF__Zahlungen__Statu__60A75C0F]  DEFAULT ((2)) FOR [StatusProsID]
GO
ALTER TABLE [dbo].[Bestellpositionen]  WITH CHECK ADD  CONSTRAINT [FK_Bestellposition_Bestellung] FOREIGN KEY([BestellungID])
REFERENCES [dbo].[Bestellungen] ([BestellungID])
GO
ALTER TABLE [dbo].[Bestellpositionen] CHECK CONSTRAINT [FK_Bestellposition_Bestellung]
GO
ALTER TABLE [dbo].[Bestellpositionen]  WITH CHECK ADD  CONSTRAINT [FK_Bestellposition_Gericht] FOREIGN KEY([GerichtID])
REFERENCES [dbo].[Menü] ([GerichtID])
GO
ALTER TABLE [dbo].[Bestellpositionen] CHECK CONSTRAINT [FK_Bestellposition_Gericht]
GO
ALTER TABLE [dbo].[Bestellungen]  WITH CHECK ADD  CONSTRAINT [FK_Bestellung_Gast] FOREIGN KEY([GastID])
REFERENCES [dbo].[Gäste] ([GastID])
GO
ALTER TABLE [dbo].[Bestellungen] CHECK CONSTRAINT [FK_Bestellung_Gast]
GO
ALTER TABLE [dbo].[Bestellungen]  WITH CHECK ADD  CONSTRAINT [FK_Bestellung_Reservierung] FOREIGN KEY([ReservierungID])
REFERENCES [dbo].[Reservierungen] ([ReservierungID])
GO
ALTER TABLE [dbo].[Bestellungen] CHECK CONSTRAINT [FK_Bestellung_Reservierung]
GO
ALTER TABLE [dbo].[Bestellungen]  WITH CHECK ADD  CONSTRAINT [FK_Bestellungen_Personal] FOREIGN KEY([MitarbeiterID])
REFERENCES [dbo].[Personal] ([MitarbeiterID])
GO
ALTER TABLE [dbo].[Bestellungen] CHECK CONSTRAINT [FK_Bestellungen_Personal]
GO
ALTER TABLE [dbo].[Bestellungen]  WITH CHECK ADD  CONSTRAINT [FK_Bestellungen_ProzStatus1] FOREIGN KEY([StatusProsID])
REFERENCES [dbo].[ProzStatus] ([StatusProsID])
GO
ALTER TABLE [dbo].[Bestellungen] CHECK CONSTRAINT [FK_Bestellungen_ProzStatus1]
GO
ALTER TABLE [dbo].[Bewertungen]  WITH CHECK ADD  CONSTRAINT [FK_Bewertungen_Bestellungen] FOREIGN KEY([BestellungID])
REFERENCES [dbo].[Bestellungen] ([BestellungID])
GO
ALTER TABLE [dbo].[Bewertungen] CHECK CONSTRAINT [FK_Bewertungen_Bestellungen]
GO
ALTER TABLE [dbo].[Gäste]  WITH CHECK ADD  CONSTRAINT [FK_GastStatus] FOREIGN KEY([StatusID])
REFERENCES [dbo].[GastStatus] ([StatusID])
GO
ALTER TABLE [dbo].[Gäste] CHECK CONSTRAINT [FK_GastStatus]
GO
ALTER TABLE [dbo].[Lagerbestand]  WITH CHECK ADD  CONSTRAINT [FK_Lagerbestand_Einheit] FOREIGN KEY([EinheitID])
REFERENCES [dbo].[Einheit] ([EinheitID])
GO
ALTER TABLE [dbo].[Lagerbestand] CHECK CONSTRAINT [FK_Lagerbestand_Einheit]
GO
ALTER TABLE [dbo].[Menü]  WITH CHECK ADD  CONSTRAINT [FK_Menü_MenüKategorie] FOREIGN KEY([KategorieID])
REFERENCES [dbo].[MenüKategorie] ([KategorieID])
GO
ALTER TABLE [dbo].[Menü] CHECK CONSTRAINT [FK_Menü_MenüKategorie]
GO
ALTER TABLE [dbo].[MenüProduckte]  WITH CHECK ADD  CONSTRAINT [FK_MenüProduckte_Lagerbestand] FOREIGN KEY([LagerID])
REFERENCES [dbo].[Lagerbestand] ([LagerID])
GO
ALTER TABLE [dbo].[MenüProduckte] CHECK CONSTRAINT [FK_MenüProduckte_Lagerbestand]
GO
ALTER TABLE [dbo].[MenüProduckte]  WITH CHECK ADD  CONSTRAINT [FK_MenüProduckte_Menü] FOREIGN KEY([GerichtID])
REFERENCES [dbo].[Menü] ([GerichtID])
GO
ALTER TABLE [dbo].[MenüProduckte] CHECK CONSTRAINT [FK_MenüProduckte_Menü]
GO
ALTER TABLE [dbo].[Reservierungen]  WITH CHECK ADD  CONSTRAINT [FK_Reservierung_Tisch] FOREIGN KEY([TischID])
REFERENCES [dbo].[Tische] ([TischID])
GO
ALTER TABLE [dbo].[Reservierungen] CHECK CONSTRAINT [FK_Reservierung_Tisch]
GO
ALTER TABLE [dbo].[Reservierungen]  WITH CHECK ADD  CONSTRAINT [FK_Reservierungen_Gäste] FOREIGN KEY([GastID])
REFERENCES [dbo].[Gäste] ([GastID])
GO
ALTER TABLE [dbo].[Reservierungen] CHECK CONSTRAINT [FK_Reservierungen_Gäste]
GO
ALTER TABLE [dbo].[Reservierungen]  WITH CHECK ADD  CONSTRAINT [FK_Reservierungen_ProzStatus] FOREIGN KEY([StatusProsID])
REFERENCES [dbo].[ProzStatus] ([StatusProsID])
GO
ALTER TABLE [dbo].[Reservierungen] CHECK CONSTRAINT [FK_Reservierungen_ProzStatus]
GO
ALTER TABLE [dbo].[Zahlungen]  WITH CHECK ADD  CONSTRAINT [FK_Zahlung_Bestellung] FOREIGN KEY([BestellungID])
REFERENCES [dbo].[Bestellungen] ([BestellungID])
GO
ALTER TABLE [dbo].[Zahlungen] CHECK CONSTRAINT [FK_Zahlung_Bestellung]
GO
ALTER TABLE [dbo].[Zahlungen]  WITH CHECK ADD  CONSTRAINT [FK_Zahlungen_ProzStatus] FOREIGN KEY([StatusProsID])
REFERENCES [dbo].[ProzStatus] ([StatusProsID])
GO
ALTER TABLE [dbo].[Zahlungen] CHECK CONSTRAINT [FK_Zahlungen_ProzStatus]
GO
ALTER TABLE [dbo].[Bestellpositionen]  WITH CHECK ADD  CONSTRAINT [CK__Bestellpo__Menge__6E01572D] CHECK  (([Menge]>(0)))
GO
ALTER TABLE [dbo].[Bestellpositionen] CHECK CONSTRAINT [CK__Bestellpo__Menge__6E01572D]
GO
ALTER TABLE [dbo].[Bewertungen]  WITH CHECK ADD  CONSTRAINT [CK__Bewertung__Stern__6FE99F9F] CHECK  (([Sterne]>=(1) AND [Sterne]<=(5)))
GO
ALTER TABLE [dbo].[Bewertungen] CHECK CONSTRAINT [CK__Bewertung__Stern__6FE99F9F]
GO
ALTER TABLE [dbo].[GastStatus]  WITH CHECK ADD  CONSTRAINT [CK__GastStatu__Rabat__70DDC3D8] CHECK  (([Rabatt]>=(0) AND [Rabatt]<=(100)))
GO
ALTER TABLE [dbo].[GastStatus] CHECK CONSTRAINT [CK__GastStatu__Rabat__70DDC3D8]
GO
ALTER TABLE [dbo].[MenüProduckte]  WITH CHECK ADD  CONSTRAINT [CK__Menü_Lage__Menge__60A75C0F] CHECK  (([Menge]>(0)))
GO
ALTER TABLE [dbo].[MenüProduckte] CHECK CONSTRAINT [CK__Menü_Lage__Menge__60A75C0F]
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD  CONSTRAINT [CK__Personal__Gehalt__74AE54BC] CHECK  (([Gehalt]>(0)))
GO
ALTER TABLE [dbo].[Personal] CHECK CONSTRAINT [CK__Personal__Gehalt__74AE54BC]
GO
ALTER TABLE [dbo].[Reservierungen]  WITH CHECK ADD  CONSTRAINT [CK__Reservier__Anzah__75A278F5] CHECK  (([Anzahl_Gaeste]>(0)))
GO
ALTER TABLE [dbo].[Reservierungen] CHECK CONSTRAINT [CK__Reservier__Anzah__75A278F5]
GO
ALTER TABLE [dbo].[Reservierungen]  WITH CHECK ADD  CONSTRAINT [CK_Reservier_Status] CHECK  (([StatusProsID]=(3) OR [StatusProsID]=(2)))
GO
ALTER TABLE [dbo].[Reservierungen] CHECK CONSTRAINT [CK_Reservier_Status]
GO
ALTER TABLE [dbo].[Reservierungen]  WITH CHECK ADD  CONSTRAINT [CK_Reservier_Uhrzeit] CHECK  (([Uhrzeit]>='17:00:00' AND [Uhrzeit]<='22:00:00'))
GO
ALTER TABLE [dbo].[Reservierungen] CHECK CONSTRAINT [CK_Reservier_Uhrzeit]
GO
ALTER TABLE [dbo].[Tische]  WITH CHECK ADD  CONSTRAINT [CK__Tische__Kapazitä__76969D2E] CHECK  (([Kapazität]>(0)))
GO
ALTER TABLE [dbo].[Tische] CHECK CONSTRAINT [CK__Tische__Kapazitä__76969D2E]
GO
ALTER TABLE [dbo].[Zahlungen]  WITH CHECK ADD  CONSTRAINT [CK__Zahlungen__Betra__778AC167] CHECK  (([Betrag]>(0)))
GO
ALTER TABLE [dbo].[Zahlungen] CHECK CONSTRAINT [CK__Zahlungen__Betra__778AC167]
GO
/****** Object:  StoredProcedure [dbo].[BookTable]    Script Date: 05.02.2025 14:00:18 ******/
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
CREATE   PROCEDURE [dbo].[BookTable]
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
/****** Object:  StoredProcedure [dbo].[CancelReservation]    Script Date: 05.02.2025 14:00:18 ******/
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
CREATE   PROCEDURE [dbo].[CancelReservation]
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
/****** Object:  StoredProcedure [dbo].[ModifyReservation]    Script Date: 05.02.2025 14:00:18 ******/
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
CREATE   PROCEDURE [dbo].[ModifyReservation]
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




GO
/****** Object:  StoredProcedure [dbo].[sp_BackupGenussRest]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_BackupGenussRest] 
	 @path nvarchar(256),  -- path for backup files
	 ------------------
	 @Erfolg bit OUTPUT, -- geklappt oder nicht
	 @Feedback NVARCHAR(MAX) OUTPUT -- Fehlermeldungen etc.
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @dbname NVARCHAR(MAX); -- database name 
	DECLARE @BackupFileName NVARCHAR(MAX); -- backup file name
	DECLARE @fullDBBackupName NVARCHAR(MAX); -- full backup file name with path
	DECLARE @msg NVARCHAR(100); -- Fehlermeldung etc
	----------------------------
	BEGIN TRY	
		---- prüfen, ob @path existiert, wenn nicht - Ordner erstellen -----
		DECLARE @tb_fileexist TABLE (FileExists bit, FileIsDir bit, ParentDirExists bit);
		INSERT INTO @tb_fileexist EXEC master.dbo.xp_fileexist @path;

		IF (SELECT FileExists FROM @tb_fileexist) = 1 -- Das ist eine Datei
		BEGIN 
			THROW 50100, 'Pfad ist eine Datei', 1; -- TODO Fehlermeldung verbessern
		END
    -- Insert statements for procedure here
		ELSE IF ((SELECT FileIsDir FROM @tb_fileexist) = 0)  -- Ordner existiert nicht
		AND ((SELECT FileExists FROM @tb_fileexist) = 0)  -- ist keine Datei 
		BEGIN -- Ordner existiert nicht, ist keine Datei
			-- @path testen. Die ersten 3 Positionen sollen so aussehen: C:\
			IF (@path NOT LIKE '[A-Z]:\%')
				THROW 50101, 'Pfad falsch', 1; -- TODO Meldung verbessern
				
			ELSE --  testen ob die Festplatte existiert, wenn nicht -  Fehler, Abbruch
			BEGIN 				
				DECLARE @driveTable TABLE (DRIVE char, MBfrei int);
				INSERT INTO @driveTable EXEC master.sys.xp_fixeddrives; -- nur die Festplatten, ohne USB
				-- Die erste Position aus @path
				DECLARE @Drive char = LEFT(@path, 1);
				-- PRINT 'Festplatte ' + @Drive;
				-- Es geht auch mit SUBSTRING
				--DECLARE @Drive char =  SUBSTRING(@path, 1, 1);
				IF @Drive NOT IN (SELECT DRIVE FROM @driveTable)
				BEGIN
					SET @msg =  'Festplate '  + @Drive + ' existiert nicht';
					THROW 50102,  @msg, 1;
				END
				
				ELSE -- Festplate existiert, Ordner erstellen
				BEGIN				
					-- create subdir from sql with xp_create_subdir procedure
					EXEC master.sys.xp_create_subdir @path;
				END -- Festplate existiert, Ordner erstellen
			END -- testen ob die Festplatte existiert, wenn nicht -  Fehler, Abbruch
		END -- Ordner existiert nicht, ist keine Datei
		---- ENDE prüfen, ob @path existiert, wenn nicht - Ordner erstellen --------
		SET @fullDBBackupName = @path 
					+ 'GenussRest-' 
					+ [dbo].[sf_Zeitstempel]()  
					+ '.bak';

		BACKUP DATABASE [GenussRest] TO DISK = @fullDBBackupName;
		SET @Feedback = 'Alles OK!';
	END TRY
	BEGIN CATCH
		-- TODO: prüfen, ob CURSOR noch existiert, und vernichten
		SET @Erfolg = 0; -- nicht geklappt--
		SET @Feedback = 
			ERROR_MESSAGE() + ' Fehler Nr. ' + CONVERT(varchar, ERROR_NUMBER())
							+ ' Prozedur: '  + ERROR_PROCEDURE()
							+ ' Zeile Nr.: ' + CONVERT(varchar,  ERROR_LINE());
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Lagerbestandprüfung]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE       PROCEDURE [dbo].[sp_Lagerbestandprüfung]
@GerichtID int,
@Kolout int,
@Msg nvarchar(MAX) OUTPUT -- Textzeile, die  uns  genug oder nicht sagen wird

AS

BEGIN

SET NOCOUNT ON;	
	
	DECLARE @Menge decimal(5,2), @LagerPosotion int,@Bestand decimal(5,2),@Result bit, @GerichtName nvarchar(100);	
	SELECT @RESULT=1
		
	SELECT @GerichtName=Name FROM Menü WHERE GerichtID=@GerichtID  -- Name des Gericht für @msg
	SET @msg = 'Bestellung ist  möglich!!!! Für das Gericht *** '+ @GerichtName+'***  haben Sie  genug Zutaten!!!!';  --zunächst immer genug

DECLARE Lager CURSOR 
	FOR
	SELECT  [LagerID],Menge
      FROM [dbo].[View_MenüProdukte]
       WHERE  [GerichtID]=@GerichtID; --Für alle Zutaten , dass wir für diese Gericht brauchen

OPEN Lager; 
	FETCH NEXT FROM Lager INTO @LagerPosotion,@Menge
	WHILE @@FETCH_STATUS = 0  
		
	BEGIN	
								
			SELECT @Bestand=Menge FROM Lagerbestand WHERE LagerID=@LagerPosotion --Menge im Lager für iene Zutat
		
			IF @Bestand <@Menge*@Kolout -- when nicht genug dann @RESULT wechseln
			SELECT @RESULT=0
		
		  		FETCH NEXT FROM Lager INTO @LagerPosotion,@Menge;  
	END 
CLOSE Lager;
DEALLOCATE Lager; 

if @RESULT=0 -- when  0 then etwas nicht genug 
			
		SET @msg = 'Bestellung ist nicht möglich!!!! Für das Gericht ***'+ @GerichtName+'*** haben Sie nicht genug Zutaten!!!!'; -- neu @msg
		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Lagerbestandreduzierung]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     PROCEDURE [dbo].[sp_Lagerbestandreduzierung]
@GerichtID int,
@Kolout int,
@PlusMinus int
AS

BEGIN

SET NOCOUNT ON;	
	
	DECLARE @Menge decimal(5,2), @LagerPosotion int;	

DECLARE Lager CURSOR 
	FOR
	SELECT  [LagerID],Menge
      FROM [dbo].[View_MenüProdukte]
       WHERE  [GerichtID]=@GerichtID; --Für alle Zutaten , dass wir für diese Gericht brauchen

OPEN Lager; 
	FETCH NEXT FROM Lager INTO @LagerPosotion,@Menge
	WHILE @@FETCH_STATUS = 0  
		
	BEGIN	
								
			
		UPDATE Lagerbestand SET Menge=Menge+@Menge*@Kolout*@PlusMinus --ändern wir die Menge
		       WHERE LagerID=@LagerPosotion

		FETCH NEXT FROM Lager INTO @LagerPosotion,@Menge;  
	END 
CLOSE Lager;
DEALLOCATE Lager; 
END
GO
/****** Object:  Trigger [dbo].[tr_BestellpositionenINSERT]    Script Date: 05.02.2025 14:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     TRIGGER [dbo].[tr_BestellpositionenINSERT] 
   ON  [dbo].[Bestellpositionen]
   AFTER  INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @GerichtID int , @Menge int

	
	SELECT @GerichtID =GerichtID , @Menge =Menge FROM inserted -- wir bereiten die Parameterr für die Procedure vor

	EXEC	[dbo].[sp_Lagerbestandreduzierung] @GerichtID,@Menge,-1 --Reduziueren den Lagerbestand
   

END
GO
ALTER TABLE [dbo].[Bestellpositionen] ENABLE TRIGGER [tr_BestellpositionenINSERT]
GO
/****** Object:  Trigger [dbo].[tr_BestellpositionenUPDATE]    Script Date: 05.02.2025 14:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
CREATE     TRIGGER [dbo].[tr_BestellpositionenUPDATE] 
   ON  [dbo].[Bestellpositionen]
   FOR  UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @GerichtID int , @MengeAlt int, @MengeNeu int,@Menge int
	IF UPDATE ([Menge]) AND NOT UPDATE ([GerichtID])  --ändern  nur Menge
	BEGIN
	
			SELECT @GerichtID =GerichtID , @MengeNeu=Menge FROM inserted -- wir bereiten die Parameterr für die Procedure vor
			SELECT  @MengeAlt =Menge FROM deleted
			SELECT @Menge=@MengeAlt-@MengeNeu
			EXEC	[dbo].[sp_Lagerbestandreduzierung] @GerichtID,@Menge,1 --Korrigieren auf Unterschied
   END


   IF UPDATE  (GerichtID) --Ändern  Gerict
	BEGIN
	
			SELECT @GerichtID =GerichtID , @MengeAlt =Menge FROM deleted -- wir bereiten die Parameterr für die Procedure vor
			EXEC	[dbo].[sp_Lagerbestandreduzierung] @GerichtID,@MengeAlt,1 --zunächst vergrössern alle Bestände für alt Gericht
	
			SELECT @GerichtID =GerichtID , @MengeNeu =Menge FROM inserted 
			EXEC	[dbo].[sp_Lagerbestandreduzierung] @GerichtID,@MengeNeu,-1 --reduzieren wieder
   END
END
GO
ALTER TABLE [dbo].[Bestellpositionen] ENABLE TRIGGER [tr_BestellpositionenUPDATE]
GO
/****** Object:  Trigger [dbo].[trg_Gast_Delete]    Script Date: 05.02.2025 14:00:19 ******/
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
CREATE   TRIGGER [dbo].[trg_Gast_Delete]
	ON [dbo].[Gäste]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
    INSERT INTO GastLog (Mode, GastID, VornameAlt, NachnameAlt, TelefonAlt, EmailAlt, StatusIDAlt)
    SELECT 'D', d.GastID, d.Vorname, d.Nachname, d.Telefon, d.Email, d.StatusID
    FROM deleted d;
END;
GO
ALTER TABLE [dbo].[Gäste] ENABLE TRIGGER [trg_Gast_Delete]
GO
/****** Object:  Trigger [dbo].[trg_Gast_Insert]    Script Date: 05.02.2025 14:00:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gruppe G
-- Create date: 03.02.2025
-- Description: Dieser Trigger überwacht INSERT-Operationen in der Tabelle Gäste und protokolliert Änderungen in der GastLog-Tabelle, 
-- einschließlich alter und neuer Werte, Zeitstempel und des ausführenden Benutzers.
-- =============================================

CREATE   TRIGGER [dbo].[trg_Gast_Insert]
	ON [dbo].[Gäste]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO GastLog (Mode, GastID, Vorname, Nachname, Telefon, Email, StatusID)
    SELECT 'I', i.GastID, i.Vorname, i.Nachname, i.Telefon, i.Email, i.StatusID
    FROM inserted i;
END;
GO
ALTER TABLE [dbo].[Gäste] ENABLE TRIGGER [trg_Gast_Insert]
GO
/****** Object:  Trigger [dbo].[trg_Gast_Update]    Script Date: 05.02.2025 14:00:20 ******/
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
CREATE   TRIGGER [dbo].[trg_Gast_Update]
   ON [dbo].[Gäste]
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
ALTER TABLE [dbo].[Gäste] ENABLE TRIGGER [trg_Gast_Update]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Restaurant opened from 17:00-00:00. reservations can only start between 17:00 and 22:00' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Reservierungen', @level2type=N'CONSTRAINT',@level2name=N'CK_Reservier_Uhrzeit'
GO
