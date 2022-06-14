USE PaymentData;
GO

BEGIN TRAN tranzac;
-- Declare Variables that we take from other tables
DECLARE @payment_cat UNIQUEIDENTIFIER
SET @payment_cat = (SELECT TOP(1) Oid FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND());
DECLARE @proj UNIQUEIDENTIFIER
SET @proj = (SELECT TOP(1) Oid FROM dbo.Project WITH (UPDLOCK) ORDER BY RAND());
DECLARE @payer_part UNIQUEIDENTIFIER
SET @payer_part = (SELECT TOP(1) Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND());
DECLARE @payee_part UNIQUEIDENTIFIER
SET @payee_part = (SELECT TOP(1) Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND());
DECLARE @pay_cat_name VARCHAR
SET @pay_cat_name = (SELECT TOP(1) Name FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND());
-- Payment Insert Query
INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 RAND()*500000,
 @payment_cat,
 @proj,
 NULL,
 @pay_cat_name,
 '1988-05-21T12:58:46.480',
 @payer_part,
 @payee_part,
 NULL,
 NULL,
 '1988-05-21T12:58:46.480',
 '6542',
 0,
 '1234'
 );
ROLLBACK TRAN tranzac;




--Transaction to UPDATE Payment Table
USE PaymentData;
GO

BEGIN TRAN tranzac;
-- Declare Variables that we take from other tables
DECLARE @payment_cat UNIQUEIDENTIFIER
SET @payment_cat = (SELECT TOP(1) Oid FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND());
DECLARE @proj UNIQUEIDENTIFIER
SET @proj = (SELECT TOP(1) Oid FROM dbo.Project WITH (UPDLOCK) ORDER BY RAND());
DECLARE @payer_part UNIQUEIDENTIFIER
SET @payer_part = (SELECT TOP(1) Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND());
DECLARE @payee_part UNIQUEIDENTIFIER
SET @payee_part = (SELECT TOP(1) Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND());
DECLARE @pay_cat_name VARCHAR
SET @pay_cat_name = (SELECT TOP(1) Name FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND());
 --Payment Update Query
 UPDATE dbo.Payment 
 SET Oid = NEWID(), 
	 Amount = RAND()*500000, 
	 Category = @payment_cat, 
	 Justification = NULL, 
	 Comment = @pay_cat_name, 
	 Date = '1988-05-21T12:58:46.480', 
	 Payer = @payer_part, 
	 Payee = @payee_part, 
	 OptimisticLockField = NULL,
	 GCRecord = NULL,
	 CreateDate = '1988-05-21T12:58:46.480',
	 CheckNumber = '6542',
	 IsAuthorized =  0,
	 Number = '1234' WHERE dbo.Payment.Project=@proj;

ROLLBACK TRAN tranzac;



--Create Indexes
CREATE NONCLUSTERED INDEX PCProfByMatInd ON dbo.PaymentCategory (ProfitByMaterial)
CREATE NONCLUSTERED INDEX PCCostByMatInd ON dbo.PaymentCategory (CostByMaterial)
CREATE NONCLUSTERED INDEX PCNPayPartInd ON dbo.PaymentCategory (NotInPaymentParticipantProfit)
CREATE NONCLUSTERED INDEX PCNameInd ON dbo.PaymentCategory (Name)
CREATE NONCLUSTERED INDEX ATNameInd ON dbo.AccountType (Name)
CREATE NONCLUSTERED INDEX SuppProfByMatPayerInd ON dbo.Supplier (ProfitByMaterialAsPayer)
CREATE NONCLUSTERED INDEX SuppProfByMatPayeeInd ON dbo.Supplier (ProfitByMaterialAsPayee)

--Drop Indexes
DROP INDEX dbo.PaymentCategory.PCProfByMatInd;
DROP INDEX dbo.PaymentCategory.PCCostByMatInd;
DROP INDEX dbo.PaymentCategory.PCNPayPartInd;
DROP INDEX dbo.PaymentCategory.PCNameInd;
DROP INDEX dbo.AccountType.ATNameInd;
DROP INDEX dbo.Supplier.SuppProfByMatPayerInd;
DROP INDEX dbo.Supplier.SuppProfByMatPayeeInd;