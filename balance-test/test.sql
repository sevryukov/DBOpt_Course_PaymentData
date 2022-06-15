
DECLARE @bank_oid UNIQUEIDENTIFIER = 'D978EE0C-7DE3-4CB6-87C3-FDB9A0EB47AF'
DECLARE @supplier_oid UNIQUEIDENTIFIER = 'E5AD52B6-8013-431A-982A-39D05DEB0C44'
DECLARE @client_oid UNIQUEIDENTIFIER = '65B6A029-2826-4A29-B261-9F99FC798FF0'
DECLARE @cashbox_oid UNIQUEIDENTIFIER = 'F35DF994-7F47-424F-B08E-8EAE1CA950A1'


DECLARE @bank_init_balance INT
SET @bank_init_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @bank_oid);
PRINT 'Bank initial balance:'
PRINT @bank_init_balance;

DECLARE @cashbox_init_balance INT
SET @cashbox_init_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @cashbox_oid);
PRINT 'Cashbox initial balance:'
PRINT @cashbox_init_balance;

DECLARE @client_init_balance INT
SET @client_init_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @client_oid);
PRINT 'Client initial balance:'
PRINT @client_init_balance;

DECLARE @supplier_init_balance INT
SET @supplier_init_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @supplier_oid);
PRINT 'Supplier initial balance:'
PRINT @supplier_init_balance;




DECLARE @paymentcategory_oid UNIQUEIDENTIFIER = '0D0E2C4B-3BEE-405A-A6B3-78DC4D4ABB2C'
DECLARE @project_oid UNIQUEIDENTIFIER = '3BA9949C-484A-4734-AB98-84D480B3EDD2'

-- First payment
INSERT [PaymentData].[dbo].[Payment] 
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),33855,@paymentcategory_oid,@project_oid,NULL,
 'Energy one word state month.',
 '2019-12-11 07:56:10.000',
 @bank_oid,
 @supplier_oid,
 NULL,
 NULL,
 '2022-06-14 14:12:04.000',
 '66508',
 1,
 '31022');

 DECLARE @paymentcategory1_oid UNIQUEIDENTIFIER = '536199BF-9119-4659-A22B-783D05D4C715'

 -- Second payment

INSERT [PaymentData].[dbo].[Payment] 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 19281,
 @paymentcategory1_oid,
 @project_oid,
 NULL,
 'Note ground language drive company fill. Officer beat peace expect election.',
 '2021-03-08 15:43:06.000',
 @supplier_oid,
 @client_oid,
 NULL,
 NULL,
 '2022-06-14 14:12:06.000',
 '20704',
 1,
 '34148');

 DECLARE @paymentcategory2_oid UNIQUEIDENTIFIER = 'BA43961F-6903-4C1F-9F7C-2F9AFD9C05A0'

-- Third payment
INSERT [PaymentData].[dbo].[Payment] 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 42667,
 @paymentcategory2_oid,
 @project_oid,
 NULL,
 'Same help arm deal.',
 '2021-01-24 14:02:35.000',
 @client_oid,
 @cashbox_oid,
 NULL,
 NULL,
 '2022-06-14 14:12:06.000',
 '16669',
 0,
 '10754');

 -- Fourth payment
 
DECLARE @paymentcategory3_oid UNIQUEIDENTIFIER = 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0'

INSERT [PaymentData].[dbo].[Payment] 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 66600,
 @paymentcategory3_oid,
 @project_oid,
 NULL,
 'Guess measure trade indeed wait military. Personal care majority step how break ago professor.',
 '2022-06-14 14:12:05.000',
 @cashbox_oid,
 @bank_oid,
 NULL,
 NULL,
 '2022-06-14 14:12:05.000',
 '98248',
 0,
 '87362');


DECLARE @bank_final_balance INT
SET @bank_final_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @bank_oid);
PRINT 'Bank final balance:'
PRINT @bank_final_balance;

DECLARE @cashbox_final_balance INT
SET @cashbox_final_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @cashbox_oid);
PRINT 'Cashbox final balance:'
PRINT @cashbox_final_balance;

DECLARE @client_final_balance INT
SET @client_final_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @client_oid);
PRINT 'Client final balance:'
PRINT @client_final_balance;

DECLARE @supplier_final_balance INT
SET @supplier_final_balance = (SELECT Balance FROM [PaymentData].[dbo].[PaymentParticipant] WHERE Oid = @supplier_oid);
PRINT 'Supplier final balance:'
PRINT @supplier_final_balance;
