USE [PaymentDataTemp]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Payment](
	id int IDENTITY(1,1) PRIMARY KEY,
	Oid uniqueidentifier NOT NULL,
	Amount int NULL,
	Category uniqueidentifier NULL,
	Project uniqueidentifier NULL,
	Justification nvarchar(100) NULL,
	Comment nvarchar(100) NULL,
	Date datetime NULL,
	Payer uniqueidentifier NULL,
	Payee uniqueidentifier NULL,
	OptimisticLockField int NULL,
	GCRecord int NULL,
	CreateDate datetime NULL,
	CheckNumber nvarchar(100) NULL,
	IsAuthorized bit NULL,
	Number nvarchar(100) NULL,
)

GO


