USE GenussRest;
GO

SELECT * FROM dbo.Gäste
WHERE GastID = 19; -- Laura	DeVries
GO
SELECT * FROM dbo.GastLog;
GO
---------------------------------------------
UPDATE dbo.Gäste
SET Nachname = 'Muhuis'
WHERE GastID = 19; -- Laura	DeVries

UPDATE dbo.Gäste
SET Nachname = 'DeVries'
WHERE GastID = 19; -- Laura	DeVries
-----
-- Änderungen in Spalte PLZ werder nicht protokoliert
UPDATE dbo.Gäste
SET Email = 'laura.muhuis@gmx.de'
WHERE GastID = 19; -- Laura	DeVries

UPDATE dbo.Gäste
SET Email = 'laura.devries@gmx.de'
WHERE GastID = 19; -- Laura	DeVries

UPDATE dbo.Gäste
SET StatusID = 2
WHERE GastID = 19; -- Laura	DeVries

---------------------------------------------
SELECT * FROM dbo.Gäste
WHERE GastID = 19; -- Laura	DeVries
GO
SELECT * FROM dbo.GastLog;
GO
