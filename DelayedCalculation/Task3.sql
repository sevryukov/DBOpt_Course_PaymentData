USE PaymentData
GO

PRINT (N'Создать таблицу [dbo].[PaymentDelayed]')
GO
IF OBJECT_ID(N'dbo.PaymentDelayed', 'U') IS NULL
CREATE TABLE dbo.PaymentDelayed (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
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
  CONSTRAINT PK_PaymentDelayed PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать триггер [T_PaymentDelayed_AI] на таблицу [dbo].[PaymentDelayed]
-- Триггер, срабатывающий после вставки или изменения платежа 
--
GO
PRINT (N'Создать триггер [T_PaymentDelayed_AI] на таблицу [dbo].[PaymentDelayed]')
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'dbo.T_PaymentDelayed_AI'))
DROP TRIGGER [dbo].[T_PaymentDelayed_AI];
GO


EXEC sp_executesql N'CREATE OR ALTER TRIGGER T_PaymentDelayed_AI
ON dbo.PaymentDelayed
AFTER INSERT, UPDATE 
AS

IF (SELECT COUNT(*)
	FROM PaymentDelayed) > 100
	BEGIN
	INSERT Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
	SELECT Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number
	FROM PaymentDelayed;

	DELETE FROM PaymentDelayed;
	END;

'
GO