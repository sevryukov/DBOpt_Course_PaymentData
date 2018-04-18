use ForGenerData

EXEC sp_executesql N'CREATE OR ALTER Function dbo.randomString (@oid uniqueidentifier)
RETURNS varchar(9) AS
BEGIN
	DECLARE @result nvarchar(9)
	SET @result = CONVERT(varchar(9), @oid)
	Return(@result)
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.getContact (@oid uniqueidentifier)
RETURNS varchar(60) AS
BEGIN
	DECLARE @n NVARCHAR(20)
	DECLARE @m NVARCHAR(20)
	DECLARE @p NVARCHAR(20)
	SET @n = (SELECT TOP 1 Surname FROM dbo.PersonSurname
	ORDER BY NEWID()) 
	SET @m = (SELECT TOP 1 Name FROM dbo.PersonName
	ORDER BY NEWID())
	SET @p = (SELECT TOP 1 Patronymic FROM dbo.PersonPatronymic
	ORDER BY NEWID())
	RETURN(SELECT CONCAT(@n,'' '',@m,'' '',@p))
END'
GO



