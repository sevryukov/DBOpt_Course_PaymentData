SET LANGUAGE 'Russian'
SET DATEFORMAT ymd
SET ARITHABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS, XACT_ABORT OFF
GO

--ObjectType--
-- 0 - Bank
-- 1 - CashBox
-- 2 - Client
-- 4 - Supplier

--ClientOid = 5aa02579-73ed-23cd-314d-4c0f86f26090
--BankOid = 6c4c1f9b-1644-2620-5976-66508ad02725
--SupplierOid = 1259a17c-69e8-7a1c-da4b-16e575b61049
--CashBoxOid = 2f1172a9-1b5d-6fc4-777e-3e3b283cabde

--PaymentCategory--
-- Авансовый платеж - 700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2
-- Закупка материалов - 951FAEE9-8883-4AEF-8CB2-11AAC0A245E0
-- Возврат долга - B994305A-4E7D-4309-BAAE-2DB3DA972BED

-- Check Balances of all participants in test
Declare @n int
PRINT 'Start values';
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '5aa02579-73ed-23cd-314d-4c0f86f26090');
PRINT 'Клиент:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '6c4c1f9b-1644-2620-5976-66508ad02725');
PRINT 'Банк:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1259a17c-69e8-7a1c-da4b-16e575b61049');
PRINT 'Поставщик:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '2f1172a9-1b5d-6fc4-777e-3e3b283cabde');
PRINT 'Касса:';
PRINT @n;
PRINT '------------------------------------------';

PRINT 'First Step - От банка поставщику 13';
INSERT dbo.Payment
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, 
OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
VALUES (
NEWID(),
 13,
 '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2',
 '5126a884-72e7-76eb-3909-69a9b1bfbc32',
  NULL,
  N'First Step',
  '1980-07-08 13:21:53.660', 
  '6c4c1f9b-1644-2620-5976-66508ad02725',
  '1259a17c-69e8-7a1c-da4b-16e575b61049',
  NULL,
  NULL,
  '1998-08-24 21:20:35.000',
  N'31862',
  0,
  N'82341'
);

-- Check Balances of all participants in test
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '5aa02579-73ed-23cd-314d-4c0f86f26090');
PRINT 'Клиент:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '6c4c1f9b-1644-2620-5976-66508ad02725');
PRINT 'Банк:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1259a17c-69e8-7a1c-da4b-16e575b61049');
PRINT 'Поставщик:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '2f1172a9-1b5d-6fc4-777e-3e3b283cabde');
PRINT 'Касса:';
PRINT @n;
PRINT '------------------------------------------';

PRINT 'Second Step - От поставщика клиенту 7';
INSERT dbo.Payment
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, 
OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
VALUES (
NEWID(),
 7,
 '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0',
 '5126a884-72e7-76eb-3909-69a9b1bfbc32',
  NULL,
  N'Second Step',
  '1980-07-08 13:21:53.660', 
  '1259a17c-69e8-7a1c-da4b-16e575b61049',
  '5aa02579-73ed-23cd-314d-4c0f86f26090',
  NULL,
  NULL,
  '1998-08-24 21:20:35.000',
  N'31862',
  0,
  N'82341'
);

-- Check Balances of all participants in test
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '5aa02579-73ed-23cd-314d-4c0f86f26090');
PRINT 'Клиент:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '6c4c1f9b-1644-2620-5976-66508ad02725');
PRINT 'Банк:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1259a17c-69e8-7a1c-da4b-16e575b61049');
PRINT 'Поставщик:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '2f1172a9-1b5d-6fc4-777e-3e3b283cabde');
PRINT 'Касса:';
PRINT @n;
PRINT '------------------------------------------';

PRINT 'Third Step - От клиента кассе 2';
INSERT dbo.Payment
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, 
OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
VALUES (
NEWID(),
 2,
 '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0',
 '5126a884-72e7-76eb-3909-69a9b1bfbc32',
  NULL,
  N'Third Step',
  '1980-07-08 13:21:53.660', 
  '5aa02579-73ed-23cd-314d-4c0f86f26090',
  '2f1172a9-1b5d-6fc4-777e-3e3b283cabde',
  NULL,
  NULL,
  '1998-08-24 21:20:35.000',
  N'31862',
  0,
  N'82341'
);

-- Check Balances of all participants in test
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '5aa02579-73ed-23cd-314d-4c0f86f26090');
PRINT 'Клиент:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '6c4c1f9b-1644-2620-5976-66508ad02725');
PRINT 'Банк:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1259a17c-69e8-7a1c-da4b-16e575b61049');
PRINT 'Поставщик:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '2f1172a9-1b5d-6fc4-777e-3e3b283cabde');
PRINT 'Касса:';
PRINT @n;

PRINT '------------------------------------------';

PRINT 'Fourth Step - От кассы банку 2';
INSERT dbo.Payment
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, 
OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
VALUES (
NEWID(),
 2,
 'B994305A-4E7D-4309-BAAE-2DB3DA972BED',
 '5126a884-72e7-76eb-3909-69a9b1bfbc32',
  NULL,
  N'Fourth Step',
  '1980-07-08 13:21:53.660', 
  '2f1172a9-1b5d-6fc4-777e-3e3b283cabde',
  '6c4c1f9b-1644-2620-5976-66508ad02725',
  NULL,
  NULL,
  '1998-08-24 21:20:35.000',
  N'31862',
  0,
  N'82341'
);

-- Check Balances of all participants in test
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '5aa02579-73ed-23cd-314d-4c0f86f26090');
PRINT 'Клиент:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '6c4c1f9b-1644-2620-5976-66508ad02725');
PRINT 'Банк:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1259a17c-69e8-7a1c-da4b-16e575b61049');
PRINT 'Поставщик:';
PRINT @n;
set @n = (SELECT Balance FROM PaymentParticipant WHERE Oid = '2f1172a9-1b5d-6fc4-777e-3e3b283cabde');
PRINT 'Касса:';
PRINT @n;

PRINT '------------------------------------------';


