USE [GenussRest]
GO

-- check CONTRAINT DEFAULT
/* SELECT * FROM sys.default_constraints;*/

-- Create CONTRAINT DEFAULT

-- Für die Tabelle Reservierungen: Standardwert für StatusProsID = 2
ALTER TABLE [dbo].[Reservierungen]
ADD CONSTRAINT [DF__Reservier__Statu__5EBF139D]
DEFAULT ((2)) FOR [StatusProsID];
GO

-- Für die Tabelle Tische: Standardwert für Verfügbar = 1
ALTER TABLE [dbo].[Tische]
ADD CONSTRAINT [DF__Tische__Verfügba__5FB337D6]
DEFAULT ((1)) FOR [Verfügbar];
GO

-- Für die Tabelle Zahlungen: Standardwert für StatusProsID = 2
ALTER TABLE [dbo].[Zahlungen]
ADD CONSTRAINT [DF__Zahlungen__Statu__60A75C0F]
DEFAULT ((2)) FOR [StatusProsID];
GO

-- Für die Tabelle Bestellungen: Standardwert für StatusProsID = 2
ALTER TABLE [dbo].[Bestellungen]
ADD CONSTRAINT [DF__Bestellun__Statu__571DF1D5]
DEFAULT ((2)) FOR [StatusProsID];
GO

-- Für die Tabelle GastStatus: Standardwert für Rabatt = 0.00
ALTER TABLE [dbo].[GastStatus]
ADD CONSTRAINT [DF__GastStatu__Rabat__5DCAEF64]
DEFAULT ((0.00)) FOR [Rabatt];
GO
