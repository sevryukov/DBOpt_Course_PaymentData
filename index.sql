

USE PaymentData;
-- GO
BEGIN TRAN tranzac;
-- Declare Variables
DECLARE @payment_cat_new UNIQUEIDENTIFIER, @proj_new UNIQUEIDENTIFIER, @payer_part_new UNIQUEIDENTIFIER, @payee_part_new UNIQUEIDENTIFIER, @pay_cat_name_new VARCHAR;

-- Set Variables from other tables
SELECT TOP(1) @payment_cat_new = Oid FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @proj_new = Oid FROM dbo.Project WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @payer_part_new = Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @payee_part_new = Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @pay_cat_name_new = Name FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND();

-- Payment Insert Query
INSERT INTO dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
VALUES (
    NEWID(),
    RAND() * 500000,
    @payment_cat_new,
    @proj_new,
    NULL,
    @pay_cat_name_new,
    '1998-05-21T12:58:46.480',
    @payer_part_new,
    @payee_part_new,
    NULL,
    NULL,
    '1998-05-21T12:58:46.480',
    '6543',
    0,
    '1234'
);

-- Rollback Transaction
ROLLBACK TRAN tranzac;

-- Transaction to UPDATE Payment Table
BEGIN TRAN tranzac;

-- Set Variables from other tables
SELECT TOP(1) @payment_cat_new = Oid FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @proj_new = Oid FROM dbo.Project WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @payer_part_new = Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @payee_part_new = Oid FROM dbo.PaymentParticipant WITH (UPDLOCK) ORDER BY RAND();
SELECT TOP(1) @pay_cat_name_new = Name FROM dbo.PaymentCategory WITH (UPDLOCK) ORDER BY RAND();

-- Payment Update Query
UPDATE dbo.Payment
SET Oid = NEWID(),
    Amount = RAND() * 500000,
    Category = @payment_cat_new,
    Justification = NULL,
    Comment = @pay_cat_name_new,
    Date = '1998-05-21T12:58:46.480',
    Payer = @payer_part_new,
    Payee = @payee_part_new,
    OptimisticLockField = NULL,
    GCRecord = NULL,
    CreateDate = '1998-05-21T12:58:46.480',
    CheckNumber = '6543',
    IsAuthorized = 0,
    Number = '1234'
WHERE dbo.Payment.Project = @proj_new;

-- Rollback Transaction
ROLLBACK TRAN tranzac;

-- Create Indexes
CREATE NONCLUSTERED INDEX PCProfByMatInd ON dbo.PaymentCategory (ProfitByMaterial);
CREATE NONCLUSTERED INDEX PCCostByMatInd ON dbo.PaymentCategory (CostByMaterial);
CREATE NONCLUSTERED INDEX PCNPayPartInd ON dbo.PaymentCategory (NotInPaymentParticipantProfit);
CREATE NONCLUSTERED INDEX PCNameInd ON dbo.PaymentCategory (Name);
CREATE NONCLUSTERED INDEX ATNameInd ON dbo.AccountType (Name);
CREATE NONCLUSTERED INDEX SuppProfByMatPayerInd ON dbo.Supplier (ProfitByMaterialAsPayer);
CREATE NONCLUSTERED INDEX SuppProfByMatPayeeInd ON dbo.Supplier (ProfitByMaterialAsPayee);

-- Drop Indexes
DROP INDEX dbo.PaymentCategory.PCProfByMatInd;
DROP INDEX dbo.PaymentCategory.PCCostByMatInd;
DROP INDEX dbo.PaymentCategory.PCNPayPartInd;
DROP INDEX dbo.PaymentCategory.PCNameInd;
DROP INDEX dbo.AccountType.ATNameInd;
DROP INDEX dbo.Supplier.SuppProfByMatPayerInd;
DROP INDEX dbo.Supplier.SuppProfByMatPayeeInd;
