USE master
GO

CREATE DATABASE ForGenerData
GO

USE ForGenerData
GO

PRINT (N'Create table [dbo].[PersonName]')
GO

CREATE TABLE dbo.PersonName(
	Name NVARCHAR(20),
	CONSTRAINT PK_PersonName PRIMARY KEY CLUSTERED (Name))
ON [PRIMARY]
GO

PRINT (N'Insert data into dbo.PersonName')
GO

INSERT dbo.PersonName(Name) VALUES (N'ALEXANDR')
INSERT dbo.PersonName(Name) VALUES (N'ALEXEY')
INSERT dbo.PersonName(Name) VALUES (N'SERGEY')
INSERT dbo.PersonName(Name) VALUES (N'ANDREY')
INSERT dbo.PersonName(Name) VALUES (N'DMITRIY')
INSERT dbo.PersonName(Name) VALUES (N'MICHAEL')
INSERT dbo.PersonName(Name) VALUES (N'PAVEL')
INSERT dbo.PersonName(Name) VALUES (N'ILYA')
INSERT dbo.PersonName(Name) VALUES (N'KONSTANTIN')
INSERT dbo.PersonName(Name) VALUES (N'VICTOR')
INSERT dbo.PersonName(Name) VALUES (N'KIRILL')
INSERT dbo.PersonName(Name) VALUES (N'NIKITA')
INSERT dbo.PersonName(Name) VALUES (N'MATVEIY')
INSERT dbo.PersonName(Name) VALUES (N'MAXIM')
INSERT dbo.PersonName(Name) VALUES (N'ARTYM')
INSERT dbo.PersonName(Name) VALUES (N'ROMAN')
INSERT dbo.PersonName(Name) VALUES (N'EGOR')
INSERT dbo.PersonName(Name) VALUES (N'ARSENIY')
INSERT dbo.PersonName(Name) VALUES (N'IVAN')
INSERT dbo.PersonName(Name) VALUES (N'DENIS')
INSERT dbo.PersonName(Name) VALUES (N'EVGENIY')
INSERT dbo.PersonName(Name) VALUES (N'DANIIL')
INSERT dbo.PersonName(Name) VALUES (N'IGOR')
INSERT dbo.PersonName(Name) VALUES (N'VLADIMIR')
INSERT dbo.PersonName(Name) VALUES (N'RUSLAN')
INSERT dbo.PersonName(Name) VALUES (N'MARK')
INSERT dbo.PersonName(Name) VALUES (N'OLEG')
INSERT dbo.PersonName(Name) VALUES (N'NIKOLAY')
INSERT dbo.PersonName(Name) VALUES (N'YURI')
INSERT dbo.PersonName(Name) VALUES (N'VITALIY')




GO

PRINT (N'Create table [dbo].[PersonSurname]')
GO

CREATE TABLE dbo.PersonSurname(
	Surname NVARCHAR(20),
	CONSTRAINT PK_PersonSurname PRIMARY KEY CLUSTERED (Surname))
ON [PRIMARY]
GO

PRINT (N'Insert data into dbo.PersonSurname')
GO

INSERT dbo.PersonSurname(Surname) VALUES (N'IVANOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'SMIRNOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'KUZNETSOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'POPOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'VASILYEV')
INSERT dbo.PersonSurname(Surname) VALUES (N'PETROV')
INSERT dbo.PersonSurname(Surname) VALUES (N'SOKOLOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'NOVIKOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'FEDOROV')
INSERT dbo.PersonSurname(Surname) VALUES (N'MOROZOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'LEBEDEV')
INSERT dbo.PersonSurname(Surname) VALUES (N'SEMENOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'EGOROV')
INSERT dbo.PersonSurname(Surname) VALUES (N'KOZLOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'STEPANOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'NIKOLAEV')
INSERT dbo.PersonSurname(Surname) VALUES (N'ORLOV')               
INSERT dbo.PersonSurname(Surname) VALUES (N'ANDREEV')
INSERT dbo.PersonSurname(Surname) VALUES (N'MAKAROV')
INSERT dbo.PersonSurname(Surname) VALUES (N'NIKITIN')
INSERT dbo.PersonSurname(Surname) VALUES (N'ZAHAROV')
INSERT dbo.PersonSurname(Surname) VALUES (N'SOLOVEV')
INSERT dbo.PersonSurname(Surname) VALUES (N'BORISOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'ROMANOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'GUSEV')
INSERT dbo.PersonSurname(Surname) VALUES (N'MAXIMOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'SOROKIN')
INSERT dbo.PersonSurname(Surname) VALUES (N'BELOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'MEDVEDEV')
INSERT dbo.PersonSurname(Surname) VALUES (N'ANTONOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'TARASOV')
INSERT dbo.PersonSurname(Surname) VALUES (N'KOMAROV')
INSERT dbo.PersonSurname(Surname) VALUES (N'TITOV')



PRINT (N'Create table [dbo].[PersonPatronymic]')
GO

CREATE TABLE dbo.PersonPatronymic(
	Patronymic NVARCHAR(20),
	CONSTRAINT PK_PersonPatronymic PRIMARY KEY CLUSTERED (Patronymic))
ON [PRIMARY]
GO

PRINT (N'Insert data into dbo.PersonPatronymic')
GO

INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'ALEXANDROVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'ALEXEEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'SERGEEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'ANDREEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'DMITRIEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'MICHAELOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'PAVLOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'ILYICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'KONSTANTINOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'VICTOROVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'NIKITICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'KIRILLOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'MATVEEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'MAXIMOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'ARTYMOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'ROMANOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'EGOROVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'ARSENIEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'IVANOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'DENISOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'EVGENIEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'DANIILOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'IGOROVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'VLADIMIROVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'RUSLANOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'MARKOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'OLEGOVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'NIKOLAEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'YURIEVICH')
INSERT dbo.PersonPatronymic(Patronymic) VALUES (N'VITALIEVICH')
GO



PRINT (N'Create table [dbo].[Cities]')
GO

CREATE TABLE dbo.Cities(
	City NVARCHAR(20),
	CONSTRAINT PK_Cities PRIMARY KEY CLUSTERED (City))
ON [PRIMARY]
GO

PRINT (N'Insert data into dbo.Cities')
GO

INSERT dbo.Cities(City) VALUES (N'SAINT-PETERSBURG')
INSERT dbo.Cities(City) VALUES (N'MOSCOW')
INSERT dbo.Cities(City) VALUES (N'NOVOSIBIRSK')
INSERT dbo.Cities(City) VALUES (N'ROSTOV')
INSERT dbo.Cities(City) VALUES (N'EKATERINBURG')
INSERT dbo.Cities(City) VALUES (N'KALININGRAD')
INSERT dbo.Cities(City) VALUES (N'PETROZAVODSK')
INSERT dbo.Cities(City) VALUES (N'ASTRAHAN')
INSERT dbo.Cities(City) VALUES (N'PERM')
INSERT dbo.Cities(City) VALUES (N'TOMSK')
INSERT dbo.Cities(City) VALUES (N'KEMEROVO')
GO



PRINT (N'Create table [dbo].[Streets]')
GO

CREATE TABLE dbo.Streets(
	Street NVARCHAR(20),
	CONSTRAINT PK_Streets PRIMARY KEY CLUSTERED (Street))
ON [PRIMARY]
GO

PRINT (N'Insert data into dbo.Streets')
GO

INSERT dbo.Streets(Street) VALUES (N'LENINA ST.')
INSERT dbo.Streets(Street) VALUES (N'MIRA ST.')
INSERT dbo.Streets(Street) VALUES (N'KRASNOARMEISKAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'DRUZBI ST.')
INSERT dbo.Streets(Street) VALUES (N'OKTYABRSKAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'ZUKOVA ST.')
INSERT dbo.Streets(Street) VALUES (N'UNIVERSITETSKAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'CENTRALNAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'MOLODEZHNAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'SHKOLNAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'LESNAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'SADOVAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'SOVETSKAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'NOVAYS ST.')
INSERT dbo.Streets(Street) VALUES (N'NABEREZHNAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'ZARECHNAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'ZELENAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'KUTUZOVA ST.')
INSERT dbo.Streets(Street) VALUES (N'ENGELSA ST.')
INSERT dbo.Streets(Street) VALUES (N'NIKOLAEVSKAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'MARKSA ST.')
GO

PRINT (N'Create function for generate string')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genRandomString (@oid uniqueidentifier)
RETURNS varchar(40) AS
BEGIN
	DECLARE @result nvarchar(9)
	SET @result = SUBSTRING(CONVERT(varchar(40), @oid),0,9)
	Return(@result)
END'
GO



PRINT (N'Create function for generate integer')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genRandomInteger (@uid uniqueidentifier, @a INT, @b INT)
RETURNS varchar(40) AS
BEGIN
	RETURN (ABS(Checksum(@uid))%(@b-@a) + @a)
END'
GO



PRINT (N'Create function for generate name')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genName (@uid uniqueidentifier)
RETURNS varchar(20) AS
BEGIN
	DECLARE @name NVARCHAR(20)
	DECLARE @rand_name int = ABS(Checksum(@uid)%(select count(*) from PersonName)) + 1
	SET @name = (select name from (select ROW_NUMBER() over(ORDER BY name) as num, name from PersonName) t2 Where num=@rand_name)
	return @name
END'
GO



PRINT (N'Create function for generate surname')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genSurname (@uid uniqueidentifier)
RETURNS varchar(20) AS
BEGIN
	DECLARE @surname NVARCHAR(20)
	DECLARE	@rand_surname int = ABS(Checksum(@uid)%(select count(*) from PersonSurname)) + 1
	SET @surname = (select surname from (select ROW_NUMBER() over(ORDER BY surname) as num, surname from PersonSurname) t2 Where num=@rand_surname)
	return @surname
END'
GO



PRINT (N'Create function for generate patronymic')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genPatronymic (@uid uniqueidentifier)
RETURNS varchar(20) AS
BEGIN
	DECLARE @patronymic NVARCHAR(20)
	DECLARE @rand_patronymic int = ABS(Checksum(@uid)%(select count(*) from PersonPatronymic)) + 1
	SET @patronymic = (select patronymic from (select ROW_NUMBER() over(ORDER BY patronymic) as num, patronymic from PersonPatronymic) t2 Where num=@rand_patronymic)
	return @patronymic
END'
GO



PRINT (N'Create function for generate full name')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genFullName (@uid1 uniqueidentifier,@uid2 uniqueidentifier,@uid3 uniqueidentifier)
RETURNS varchar(60) AS
BEGIN
	return(SELECT CONCAT( dbo.genName(@uid1),'' '',dbo.genSurname(@uid2),'' '',dbo.genPatronymic(@uid3)))
END'
GO




PRINT (N'Create function for generate address')
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




PRINT (N'Create function for generate phone number')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genPhone (@uid uniqueidentifier)
RETURNS varchar(11) AS
BEGIN
	RETURN CONCAT(''89'',ABS(Checksum(@uid)%1000000000))
END'
GO




PRINT (N'Create function for generate balance')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genBalance (@uid uniqueidentifier)
RETURNS int AS
BEGIN
	RETURN Checksum(@uid)%1000000
END'
GO



PRINT (N'Create function for generate binary value')
GO

EXEC sp_executesql N'CREATE OR ALTER Function dbo.genBinValue (@uid uniqueidentifier)
RETURNS int AS
BEGIN
	RETURN ABS(Checksum(@uid)%2)
END'
GO

/*PRINT (N'Create function for get a value from a specific column of a random row')
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
GO*/

PRINT (N'Create function for generate date')
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