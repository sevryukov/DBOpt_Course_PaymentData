USE PaymentData;
DECLARE @iter INT = 0
DECLARE @max_iter INT = 5000

DECLARE @r_payee UNIQUEIDENTIFIER
DECLARE @r_payer UNIQUEIDENTIFIER
DECLARE @r_category UNIQUEIDENTIFIER
DECLARE @r_project UNIQUEIDENTIFIER

WHILE @iter < @max_iter
BEGIN
  SET @r_payee = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant ORDER BY RAND())
  SET @r_payer = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant ORDER BY RAND())
  SET @r_category = (SELECT TOP (1) PaymentCategory.Oid FROM dbo.PaymentCategory ORDER BY RAND())
  SET @r_project = (SELECT TOP (1) Project.Oid FROM dbo.Project ORDER BY RAND())

  INSERT dbo.Payment(
    Oid, 
    Amount, 
    Category, 
    Project, 
    Justification, 
    Comment, 
    Date, 
    Payer, 
    Payee, 
    OptimisticLockField, 
    GCRecord, 
    CreateDate, 
    CheckNumber, 
    IsAuthorized, 
    Number
  ) VALUES (
    NEWID(), 
    55, 
    @r_category, 
    @r_project, 
    N'0P0', 
    N'test', 
    '2023-06-02 22:24:19.170', 
    @r_payer, 
    @r_payee, 
    -6673, 
    5412, 
    '2023-06-02 19:58:31.050', 
    N'34565', 
    0, 
    N'34565'
  )

  SET @iter = @iter + 1;
END