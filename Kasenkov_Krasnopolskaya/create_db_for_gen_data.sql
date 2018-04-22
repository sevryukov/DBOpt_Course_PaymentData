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



PRINT (N'Создать таблицу [dbo].[Cities]')
GO

CREATE TABLE dbo.Cities(
	City NVARCHAR(20),
	CONSTRAINT PK_Cities PRIMARY KEY CLUSTERED (City))
ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу Cities')
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
