USE [GenussRest];
GO


-------------------------------------------------------------------
-- 1. Bestellpositionen: PK__Bestellp__C75911298A26F89C (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Bestellpositionen]
ADD CONSTRAINT [PK__Bestellp__C75911298A26F89C]
    PRIMARY KEY CLUSTERED ( [BestellpositionID] ASC );

-------------------------------------------------------------------
-- 2. Bestellungen: PK__Bestellu__285B074B63C5FD25 (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Bestellungen]
ADD CONSTRAINT [PK__Bestellu__285B074B63C5FD25]
    PRIMARY KEY CLUSTERED ( [BestellungID] ASC );

-------------------------------------------------------------------
-- 3. Bewertungen: PK__Bewertun__FA36210062BD87C1 (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Bewertungen]
ADD CONSTRAINT [PK__Bewertun__FA36210062BD87C1]
    PRIMARY KEY CLUSTERED ( [BewertungID] ASC );

-------------------------------------------------------------------
-- 4. Einheit: PK_Einheit (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Einheit]
ADD CONSTRAINT [PK_Einheit]
    PRIMARY KEY CLUSTERED ( [EinheitID] ASC );

-------------------------------------------------------------------
-- 5. G�ste: PK__G�ste__BFEA2217CD612BFE (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[G�ste]
ADD CONSTRAINT [PK__G�ste__BFEA2217CD612BFE]
    PRIMARY KEY CLUSTERED ( [GastID] ASC );

-------------------------------------------------------------------
-- 6. GastStatus: PK__GastStat__C8EE20437AD3919D (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[GastStatus]
ADD CONSTRAINT [PK__GastStat__C8EE20437AD3919D]
    PRIMARY KEY CLUSTERED ( [StatusID] ASC );

-------------------------------------------------------------------
-- 7. Lagerbestand: PK__Lagerbes__23FED8A9FCA15C73 (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Lagerbestand]
ADD CONSTRAINT [PK__Lagerbes__23FED8A9FCA15C73]
    PRIMARY KEY CLUSTERED ( [LagerID] ASC );

-------------------------------------------------------------------
-- 8. Men�: PK__Men�__41280BF12EAD9D4F (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Men�]
ADD CONSTRAINT [PK__Men�__41280BF12EAD9D4F]
    PRIMARY KEY CLUSTERED ( [GerichtID] ASC );

-------------------------------------------------------------------
-- 9. Men�Kategorie: PK_Men�Kategorie (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Men�Kategorie]
ADD CONSTRAINT [PK_Men�Kategorie]
    PRIMARY KEY CLUSTERED ( [KategorieID] ASC );

-------------------------------------------------------------------
-- 10. Men�Produckte: PK__Men�_Lag__AE57E3D34FDE8676 (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Men�Produckte]
ADD CONSTRAINT [PK__Men�_Lag__AE57E3D34FDE8676]
    PRIMARY KEY CLUSTERED ( [Men�LagerID] ASC );

-------------------------------------------------------------------
-- 11. Personal: PK__Personal__6D10A9B1441F74FB (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Personal]
ADD CONSTRAINT [PK__Personal__6D10A9B1441F74FB]
    PRIMARY KEY CLUSTERED ( [MitarbeiterID] ASC );

-------------------------------------------------------------------
-- 12. ProzStatus: PK_ProzStatus (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[ProzStatus]
ADD CONSTRAINT [PK_ProzStatus]
    PRIMARY KEY CLUSTERED ( [StatusProsID] ASC );

-------------------------------------------------------------------
-- 13. Reservierungen: PK__Reservie__C10B1F5DF410B814 (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Reservierungen]
ADD CONSTRAINT [PK__Reservie__C10B1F5DF410B814]
    PRIMARY KEY CLUSTERED ( [ReservierungID] ASC );

-------------------------------------------------------------------
-- 14. Tische: PK__Tische__60BC005F6EA464FB (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Tische]
ADD CONSTRAINT [PK__Tische__60BC005F6EA464FB]
    PRIMARY KEY CLUSTERED ( [TischID] ASC );

-------------------------------------------------------------------
-- 15. Zahlungen: PK__Zahlunge__5F21E579701C9B8B (CLUSTERED)
-------------------------------------------------------------------
ALTER TABLE [dbo].[Zahlungen]
ADD CONSTRAINT [PK__Zahlunge__5F21E579701C9B8B]
    PRIMARY KEY CLUSTERED ( [ZahlungID] ASC );
GO
