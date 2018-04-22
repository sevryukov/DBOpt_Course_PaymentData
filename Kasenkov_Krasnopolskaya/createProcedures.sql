use ForGenerData

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genRandomString (@oid uniqueidentifier)
RETURNS varchar(40) AS
BEGIN
	DECLARE @result nvarchar(9)
	SET @result = SUBSTRING(CONVERT(varchar(40), @oid),0,9)
	Return(@result)
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genFullName (@uid1 uniqueidentifier,@uid2 uniqueidentifier,@uid3 uniqueidentifier)
RETURNS varchar(60) AS
BEGIN
	DECLARE @name NVARCHAR(20)
	DECLARE @surname NVARCHAR(20)
	DECLARE @patronymic NVARCHAR(20)
	DECLARE @rand_name int = ABS(Checksum(@uid1)%(select count(*) from PersonName)) + 1
	DECLARE	@rand_surname int = ABS(Checksum(@uid2)%(select count(*) from PersonSurname)) + 1
	DECLARE @rand_patronymic int = ABS(Checksum(@uid3)%(select count(*) from PersonPatronymic)) + 1

	SET @surname = (select surname from (select ROW_NUMBER() over(ORDER BY surname) as num, surname from PersonSurname) t2 Where num=@rand_surname)
	SET @name = (select name from (select ROW_NUMBER() over(ORDER BY name) as num, name from PersonName) t2 Where num=@rand_name)
	SET @patronymic = (select patronymic from (select ROW_NUMBER() over(ORDER BY patronymic) as num, patronymic from PersonPatronymic) t2 Where num=@rand_patronymic)
	return(SELECT CONCAT(@surname,'' '',@name,'' '',@patronymic))
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genAddress (@uid1 uniqueidentifier,@uid2 uniqueidentifier,@uid3 uniqueidentifier)
RETURNS varchar(60) AS
BEGIN
	DECLARE @city NVARCHAR(20)
	DECLARE @street NVARCHAR(20)

	DECLARE @rand_city int = ABS(Checksum(@uid1)%(select count(*) from Cities)) + 1
	DECLARE	@rand_street int = ABS(Checksum(@uid2)%(select count(*) from Streets)) + 1
	DECLARE @rand_building int = ABS(Checksum(@uid3)%256) + 1

	SET @city = (select city from (select ROW_NUMBER() over(ORDER BY city) as num, city from Cities) t2 where num=@rand_city)
	SET @street = (select street from (select ROW_NUMBER() over(ORDER BY street) as num, street from Streets) t2 where num=@rand_street)
	RETURN (SELECT CONCAT(@city,'' '',@street,'' '',@rand_building))
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genPhone (@uid uniqueidentifier)
RETURNS varchar(11) AS
BEGIN
	RETURN CONCAT(''89'',ABS(Checksum(@uid)%1000000000))
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genBalance (@uid uniqueidentifier)
RETURNS int AS
BEGIN
	RETURN Checksum(@uid)%1000000
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genBinValue (@uid uniqueidentifier)
RETURNS int AS
BEGIN
	RETURN ABS(Checksum(@uid)%2)
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.getRandomValueFromColumn (@uid uniqueidentifier,  @nameDB nvarchar(40), @nameTable nvarchar(40), @nameColumn nvarchar(40))
RETURNS varchar(500) AS
BEGIN
	DECLARE @result NVARCHAR(200)
	DECLARE @sql nvarchar(2000) = ''use '' + @nameDB +'' DECLARE @rand_name int = ABS(Checksum(''''''+ cast(@uid as varchar(36)) +'''''')%(select count(*) from [''+ @nameTable + ''])) + 1 '' +
								 ''SET @retvalOUT = (select ''+ @nameColumn +'' from (select ROW_NUMBER() over(ORDER BY ''+@nameColumn+'') as num, ''+@nameColumn+'' from ''+@nameTable+'') t2 Where num=@rand_name)''
	DECLARE @ParmDefinition nvarchar(500) = N''@retvalOUT NVARCHAR(200) OUTPUT''
	exec sp_executesql @sql, @ParmDefinition, @retvalOUT=@result OUTPUT
	RETURN (@result)
END'
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genDate (@uid uniqueidentifier)
RETURNS DATETIME2(0)
BEGIN
	DECLARE @FromDate DATETIME2(0) = ''1999-01-01 08:22:13'' 
	DECLARE @ToDate DATETIME2(0) = ''2018-01-01 19:00:00''
	DECLARE @Seconds INT = DATEDIFF(SECOND, @FromDate, @ToDate)
	DECLARE @Random INT = ABS(Checksum(@uid)%@Seconds)
	RETURN (DATEADD(SECOND, @Random, @FromDate))
END'
GO

