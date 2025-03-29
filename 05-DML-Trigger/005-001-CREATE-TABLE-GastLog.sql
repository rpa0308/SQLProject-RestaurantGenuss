USE GenussRest;
GO

-- Falls die Log-Tabelle bereits existiert, l�schen wir sie zuerst
DROP TABLE IF EXISTS GastLog;
GO

-- Erstellung der Log-Tabelle f�r G�ste
CREATE TABLE GastLog 
(
  ID          INT           NOT NULL IDENTITY PRIMARY KEY,
  Mode        CHAR(1)       NOT NULL, -- 'I' f�r INSERT, 'D' f�r DELETE, 'U' f�r UPDATE
  EditOn      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Zeitstempel der �nderung
  EditUser    NVARCHAR(100) NOT NULL DEFAULT ORIGINAL_LOGIN(),   -- Benutzer, der die �nderung durchgef�hrt hat
  ---------------------------------------------------------
  GastID      INT           NOT NULL,  -- G�ste-ID (Prim�rschl�ssel der Tabelle G�ste)
  VornameAlt  NVARCHAR(50)  NULL,      -- Alt und Neu - nur f�r UPDATE
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