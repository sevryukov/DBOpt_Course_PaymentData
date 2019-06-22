-- Oid list:
-- Bank			61B9CB60-344E-7294-F363-8A7BA31D9960
-- Supplier		31364645-14ED-27FC-D711-56E108B1C222
-- Client		394B238C-2EF4-4298-5333-57D1D013A38F
-- Cashbox		21D97F61-513D-59DC-ABB3-CAD96B318FC3
DECLARE @bank_oid UNIQUEIDENTIFIER = '61B9CB60-344E-7294-F363-8A7BA31D9960'
DECLARE @supplier_oid UNIQUEIDENTIFIER = '31364645-14ED-27FC-D711-56E108B1C222'
DECLARE @client_oid UNIQUEIDENTIFIER = '394B238C-2EF4-4298-5333-57D1D013A38F'
DECLARE @cashbox_oid UNIQUEIDENTIFIER = '21D97F61-513D-59DC-ABB3-CAD96B318FC3'

DECLARE @bank_init_balance INT
SET @bank_init_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_oid);
PRINT 'Bank initial balance:'
PRINT @bank_init_balance;

DECLARE @cashbox_init_balance INT
SET @cashbox_init_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_oid);
PRINT 'Cashbox initial balance:'
PRINT @cashbox_init_balance;

DECLARE @client_init_balance INT
SET @client_init_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_oid);
PRINT 'Client initial balance:'
PRINT @client_init_balance;

DECLARE @supplier_init_balance INT
SET @supplier_init_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_oid);
PRINT 'Supplier initial balance:'
PRINT @supplier_init_balance;

DECLARE @project_oid UNIQUEIDENTIFIER = '28E0E5DC-6EF2-2562-F22C-20ADA5F246EB'
DECLARE @prepayment UNIQUEIDENTIFIER = '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2'

-- First payment
INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 400000,
 @prepayment,
 @project_oid,
 NULL,
 'Перевели денег поставщику для будущих закупок. Образовался долг банку',
 '2009-02-10 00:00:00.000',
 @bank_oid,
 @supplier_oid,
 NULL,
 NULL,
 '2009-02-10 00:00:00.000',
 '4815',
 0,
 '1623');


-- Second payment
DECLARE @materials_purchase UNIQUEIDENTIFIER = '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0'

INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 100000,
 @materials_purchase,
 @project_oid,
 NULL,
 'Для клиента приобрели материал. Поставщик нам должен меньше, а клиент должен за материалы',
 '2009-02-10 00:00:00.000',
 @supplier_oid,
 @client_oid,
 NULL,
 NULL,
 '2009-02-10 00:00:00.000',
 '4815',
 0,
 '1623');

-- Third payment
INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 150000,
 @materials_purchase,
 @project_oid,
 NULL,
 'Клиент передал наличные для закупки материалов',
 '2009-02-10 00:00:00.000',
 @client_oid,
 @cashbox_oid,
 NULL,
 NULL,
 '2009-02-10 00:00:00.000',
 '4815',
 0,
 '1623');


-- Fourth payment
DECLARE @credit_repayment UNIQUEIDENTIFIER = 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0'

INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 100000,
 @credit_repayment,
 @project_oid,
 NULL,
 'Частично гасим кредит',
 '2009-02-10 00:00:00.000',
 @cashbox_oid,
 @bank_oid,
 NULL,
 NULL,
 '2009-02-10 00:00:00.000',
 '4815',
 0,
 '1623');

DECLARE @bank_final_balance INT
SET @bank_final_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_oid);
PRINT 'Bank final balance:'
PRINT @bank_final_balance;

DECLARE @cashbox_final_balance INT
SET @cashbox_final_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_oid);
PRINT 'Cashbox final balance:'
PRINT @cashbox_final_balance;

DECLARE @client_final_balance INT
SET @client_final_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_oid);
PRINT 'Client final balance:'
PRINT @client_final_balance;

DECLARE @supplier_final_balance INT
SET @supplier_final_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_oid);
PRINT 'Supplier final balance:'
PRINT @supplier_final_balance;
