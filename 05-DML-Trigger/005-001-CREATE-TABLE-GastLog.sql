USE GenussRest;
GO

-- Falls die Log-Tabelle bereits existiert, löschen wir sie zuerst
DROP TABLE IF EXISTS GastLog;
GO

-- Erstellung der Log-Tabelle für Gäste
CREATE TABLE GastLog 
(
  ID          INT           NOT NULL IDENTITY PRIMARY KEY,
  Mode        CHAR(1)       NOT NULL, -- 'I' für INSERT, 'D' für DELETE, 'U' für UPDATE
  EditOn      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Zeitstempel der Änderung
  EditUser    NVARCHAR(100) NOT NULL DEFAULT ORIGINAL_LOGIN(),   -- Benutzer, der die Änderung durchgeführt hat
  ---------------------------------------------------------
  GastID      INT           NOT NULL,  -- Gäste-ID (Primärschlüssel der Tabelle Gäste)
  VornameAlt  NVARCHAR(50)  NULL,      -- Alt und Neu - nur für UPDATE
  Vorname  NVARCHAR(50)  NULL,     
  NachnameAlt NVARCHAR(50)  NULL,
  Nachname NVARCHAR(50)  NULL,
  TelefonAlt  NVARCHAR(50)  NULL,
  Telefon  NVARCHAR(50)  NULL,
  EmailAlt    NVARCHAR(100) NULL,
  Email    NVARCHAR(100) NULL,
  StatusIDAlt INT           NULL,      
  StatusID INT           NULL       
);
GO