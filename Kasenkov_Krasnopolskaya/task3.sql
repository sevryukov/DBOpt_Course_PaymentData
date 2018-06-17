IF OBJECT_ID(N'dbo.TempPayment', 'U') IS NULL
CREATE TABLE dbo.TempPayment (
  id int IDENTITY(1,1),
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
  CONSTRAINT PK_TempPayment PRIMARY KEY (id)
)
GO

DROP TRIGGER checkCountRowAndInsert
GO

CREATE TRIGGER checkCountRowAndInsert
ON dbo.TempPayment
AFTER INSERT, UPDATE, DELETE   
AS  
	DECLARE @count_for_transfer int = 500
	DECLARE @count_row int
	set @count_row = (SELECT count(*) from TempPayment)
	IF @count_row >= @count_for_transfer
		BEGIN
			BEGIN TRAN T;
			BEGIN TRY  
				DECLARE @tempTable TABLE(Oid uniqueidentifier NOT NULL,
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
										 Number nvarchar(100) NULL)
				INSERT INTO @tempTable(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) SELECT TOP (@count_for_transfer) Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number from TempPayment
				
				INSERT INTO PaymentData.dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) SELECT * FROM @tempTable

				DELETE FROM dbo.TempPayment WHERE Oid IN (SELECT Oid FROM @tempTable) 
				DELETE @tempTable
				COMMIT TRAN T;
			END TRY  
			BEGIN CATCH  
				ROLLBACK TRAN T;
			END CATCH  
		END
	print @count_row 
GO  