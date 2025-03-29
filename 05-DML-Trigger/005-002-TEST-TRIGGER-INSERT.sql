USE GenussRest;
GO
---------------------------------------------
INSERT INTO [dbo].[Gäste]
           ([Vorname],
           [Nachname],
           [Telefon],
           [Email],
		   [StatusID])
     VALUES
           (
		   'Laura',
           'DeVries',
           '+49 159 3332233',
           'laura.devries@gmx.de',
		   '1');

INSERT INTO [dbo].[Gäste]
           ([Vorname],
           [Nachname],
           [Telefon],
           [Email],
		   [StatusID])
	VALUES
           (
		   'Test-Trigger-Name',
           'Test-Trigger-Vorname',
           'Test-Mobile',
           'Test-email',
		   '1');
---------------------------------------------