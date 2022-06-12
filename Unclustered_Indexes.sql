--create nonclustered index PPIndex ON dbo.PaymentParticipant (Name) INCLUDE (Oid,Balance);
--create nonclustered index PCIndex ON dbo.PaymentCategory (Name);
--create nonclustered index PIndex ON dbo.Project (Oid) INCLUDE(Name, Balance);

--DROP INDEX dbo.PaymentParticipant.PPIndex;
--DROP INDEX dbo.PaymentCategory.PCIndex;
--DROP INDEX dbo.Project.PIndex;

--CREATE NONCLUSTERED INDEX CatIndex ON dbo.PaymentCategory (Oid);
--CREATE NONCLUSTERED INDEX ProjIndex ON dbo.Project (Oid);
--CREATE NONCLUSTERED INDEX BankIndex ON dbo.Bank (Oid);
--CREATE NONCLUSTERED INDEX SuppIndex ON dbo.Supplier (Oid);

--DROP INDEX dbo.Bank.BankIndex;
--DROP INDEX dbo.PaymentCategory.CatIndex;
--DROP INDEX dbo.Project.ProjIndex;
--DROP INDEX dbo.Supplier.SuppIndex;

Use PaymentData;
GO

BEGIN TRAN tranzac;  
DECLARE @r_payee UNIQUEIDENTIFIER 
DECLARE @r_payer UNIQUEIDENTIFIER 
DECLARE @r_category UNIQUEIDENTIFIER 
DECLARE @r_project UNIQUEIDENTIFIER


SET @r_payee = (SELECT top(1) dbo.PaymentParticipant.Oid FROM dbo.PaymentParticipant with updlock() order by rand());
SET @r_payer = (SELECT top(1) dbo.PaymentParticipant.Oid FROM dbo.PaymentParticipant with updlock() order by rand());
SET @r_category = (SELECT top(1) dbo.PaymentCategory.Oid FROM dbo.PaymentCategory with updlock() order by rand());
SET @r_project = (SELECT top(1) dbo.Project.Oid FROM dbo.Project with updlock() order by rand());


INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 400000,
 @r_category,
 @r_project,
 NULL,
 'Перевели денег поставщику для будущих закупок. Образовался долг банку.',
 '1988-05-21T12:58:46.480',
 @r_payer,
 @r_payee,
 NULL,
 NULL,
 '1988-05-21T12:58:46.480',
 '6542',
 0,
 '3256');

 ROLLBACK TRAN tranzac;