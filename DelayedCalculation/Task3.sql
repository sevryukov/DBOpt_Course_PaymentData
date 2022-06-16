USE PaymentData_v2
GO

PRINT (N'Создать таблицу [dbo].[PaymentDelayed]')
GO
IF OBJECT_ID(N'dbo.PaymentDelayed', 'U') IS NULL
CREATE TABLE dbo.PaymentDelayed (
  Oid UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL,
  Amount INT NULL,
  Category UNIQUEIDENTIFIER NULL,
  Project UNIQUEIDENTIFIER NULL,
  Justification NVARCHAR(100) NULL,
  Comment NVARCHAR(100) NULL,
  Date DATETIME NULL,
  Payer UNIQUEIDENTIFIER NULL,
  Payee UNIQUEIDENTIFIER NULL,
  OptimisticLockField INT NULL,
  GCRecord INT NULL,
  CreateDate DATETIME NULL,  
  CheckNumber NVARCHAR(100) NULL,  
  IsAuthorized BIT NULL,
  Number NVARCHAR(100) NULL,  
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
DECLARE @MAX_PAYMENT_DELAYED_SIZE INT = 100;
IF (SELECT COUNT(*)
	FROM PaymentDelayed) >= @MAX_PAYMENT_DELAYED_SIZE
	BEGIN
	INSERT Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
	SELECT Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number
	FROM PaymentDelayed;

	DELETE FROM PaymentDelayed;
	END;

'
GO