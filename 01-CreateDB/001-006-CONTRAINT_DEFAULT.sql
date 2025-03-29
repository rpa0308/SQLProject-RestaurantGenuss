USE [GenussRest]
GO

-- check CONTRAINT DEFAULT
/* SELECT * FROM sys.default_constraints;*/

-- Create CONTRAINT DEFAULT

-- F�r die Tabelle Reservierungen: Standardwert f�r StatusProsID = 2
ALTER TABLE [dbo].[Reservierungen]
ADD CONSTRAINT [DF__Reservier__Statu__5EBF139D]
DEFAULT ((2)) FOR [StatusProsID];
GO

-- F�r die Tabelle Tische: Standardwert f�r Verf�gbar = 1
ALTER TABLE [dbo].[Tische]
ADD CONSTRAINT [DF__Tische__Verf�gba__5FB337D6]
DEFAULT ((1)) FOR [Verf�gbar];
GO

-- F�r die Tabelle Zahlungen: Standardwert f�r StatusProsID = 2
ALTER TABLE [dbo].[Zahlungen]
ADD CONSTRAINT [DF__Zahlungen__Statu__60A75C0F]
DEFAULT ((2)) FOR [StatusProsID];
GO

-- F�r die Tabelle Bestellungen: Standardwert f�r StatusProsID = 2
ALTER TABLE [dbo].[Bestellungen]
ADD CONSTRAINT [DF__Bestellun__Statu__571DF1D5]
DEFAULT ((2)) FOR [StatusProsID];
GO

-- F�r die Tabelle GastStatus: Standardwert f�r Rabatt = 0.00
ALTER TABLE [dbo].[GastStatus]
ADD CONSTRAINT [DF__GastStatu__Rabat__5DCAEF64]
DEFAULT ((0.00)) FOR [Rabatt];
GO
