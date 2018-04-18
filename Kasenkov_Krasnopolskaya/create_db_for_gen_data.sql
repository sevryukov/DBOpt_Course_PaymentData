USE master
GO

CREATE DATABASE ForGenerData
GO

USE ForGenerData
GO

PRINT (N'Создать таблицу [dbo].[PersonName]')
GO

CREATE TABLE dbo.PersonName(
	Name NVARCHAR(20),
	CONSTRAINT PK_PersonName PRIMARY KEY CLUSTERED (Name))
ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу PersonName')
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
GO

PRINT (N'Создать таблицу [dbo].[PersonSurname]')
GO

CREATE TABLE dbo.PersonSurname(
	Surname NVARCHAR(20),
	CONSTRAINT PK_PersonSurname PRIMARY KEY CLUSTERED (Surname))
ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу PersonSurname')
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


PRINT (N'Создать таблицу [dbo].[PersonPatronymic]')
GO

CREATE TABLE dbo.PersonPatronymic(
	Patronymic NVARCHAR(20),
	CONSTRAINT PK_PersonPatronymic PRIMARY KEY CLUSTERED (Patronymic))
ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу PersonPatronymic')
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
GO

PRINT (N'Создать таблицу [dbo].[Streets]')
GO

CREATE TABLE dbo.Streets(
	Street NVARCHAR(20),
	CONSTRAINT PK_Streets PRIMARY KEY CLUSTERED (Street))
ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу Streets')
GO

INSERT dbo.Streets(Street) VALUES (N'LENINA ST.')
INSERT dbo.Streets(Street) VALUES (N'MIRA ST.')
INSERT dbo.Streets(Street) VALUES (N'KRASNOARMEISKAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'DRUZBI ST.')
INSERT dbo.Streets(Street) VALUES (N'OKTYABRSKAYA ST.')
INSERT dbo.Streets(Street) VALUES (N'ZUKOVA ST.')
INSERT dbo.Streets(Street) VALUES (N'UNIVERSITETSKAYA ST.')
GO
