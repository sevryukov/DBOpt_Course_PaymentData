USE PaymentData;
DECLARE @iter INT = 0
DECLARE @max_iter INT = 2000

DECLARE @r_payee UNIQUEIDENTIFIER
DECLARE @r_payer UNIQUEIDENTIFIER
DECLARE @r_category UNIQUEIDENTIFIER
DECLARE @r_project UNIQUEIDENTIFIER
DECLARE @r_payment UNIQUEIDENTIFIER

WHILE @iter < @max_iter
BEGIN
  SET @r_payee = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant ORDER BY RAND())
  SET @r_payer = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant ORDER BY RAND())
  SET @r_category = (SELECT TOP (1) PaymentCategory.Oid FROM dbo.PaymentCategory ORDER BY RAND())
  SET @r_project = (SELECT TOP (1) Project.Oid FROM dbo.Project ORDER BY RAND())
  SET @r_payment = (SELECT TOP (1) Project.Oid FROM dbo.Project ORDER BY RAND())

  UPDATE dbo.Payment 
  SET Amount = 12321,
  Category = @r_category,
  Project = @r_project,
  Comment = 'test',
  Payer = @r_payer,
  Payee = @r_payee,
  GCRecord = NULL
  WHERE Oid = @r_payment

  SET @iter = @iter + 1;
END