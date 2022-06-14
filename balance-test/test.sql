DECLARE @bank_oid UNIQUEIDENTIFIER = 'd978ee0c-7de3-4cb6-87c3-fdb9a0eb47af'
DECLARE @supplier_oid UNIQUEIDENTIFIER = 'e5ad52b6-8013-431a-982a-39d05deb0c44'
DECLARE @client_oid UNIQUEIDENTIFIER = '65b6a029-2826-4a29-b261-9f99fc798ff0'
DECLARE @cashbox_oid UNIQUEIDENTIFIER = 'f35df994-7f47-424f-b08e-8eae1ca950a1'


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


DECLARE @paymentcategory_oid UNIQUEIDENTIFIER = 'ba43961f-6903-4c1f-9f7c-2f9afd9c05a0'
DECLARE @project_oid UNIQUEIDENTIFIER = 'a2f0d890-f490-4433-becb-ff2a1c5158c3'

-- First payment
INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),38086,@paymentcategory_oid,@project_oid,NULL,
 'Subject minute discuss leg. Budget gas until general remember stock. Final certain stop Mr fire.',
 '2021-12-27 15:43:47.000',
 @bank_oid,
 @supplier_oid,
 NULL,
 NULL,
 '2022-06-13 20:56:30.000',
 '20495',
 1,
 '91553');

 DECLARE @paymentcategory1_oid UNIQUEIDENTIFIER = '07ea1363-fd9d-4b15-ac3e-c98407443665'

 -- Second payment

INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 12382,
 @paymentcategory1_oid,
 @project_oid,
 NULL,
 'Those action recent southern. Public beat laugh sit throughout during save',
 '2020-06-02 05:43:16.000',
 @supplier_oid,
 @client_oid,
 NULL,
 NULL,
 '2022-06-13 21:04:07.000',
 '79803',
 0,
 '68148');

 DECLARE @paymentcategory2_oid UNIQUEIDENTIFIER = 'f601cfb6-93ed-4087-822a-6f2fed3eeb0a'

-- Third payment
INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 150000,
 @paymentcategory2_oid,
 @project_oid,
 NULL,
 'Important none management if huge. Early why once enjoy approach officer. Benefit sing dream guy.',
 '2021-09-21 23:11:11.000',
 @client_oid,
 @cashbox_oid,
 NULL,
 NULL,
 '2022-06-13 21:04:15.000',
 '12589',
 1,
 '51168');

 -- Fourth payment
 
DECLARE @paymentcategory3_oid UNIQUEIDENTIFIER = '7249bf2e-4d51-4a97-b62e-632ffeedc961'

INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 100000,
 @paymentcategory3_oid,
 @project_oid,
 NULL,
 'Entire our significant western claim fill. Know from any name exactly her politics.',
 '2021-11-29 00:41:03.000',
 @cashbox_oid,
 @bank_oid,
 NULL,
 NULL,
 '2022-06-13 21:04:09.000',
 '53319',
 0,
 '48880');


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
