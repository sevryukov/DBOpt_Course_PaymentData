--BankOid = 1484AF9B-1B63-50DE-014C-16E575B61049
--CashboxOid (kassa) = 1A65B8E8-1761-57B3-144C-16E575B61049 with tekuschiy s4et
--ClientOid = 292BD755-7449-67DB-024C-16E575B61049
--SupplierOid = 28C681C4-4EB2-7172-004C-16E575B61049

--Project Oid (from table Project where client id = ClientOid) = 670CB686-4CA3-1FC8-4593-373516031D8E

--PaymentCategory 
-- avansoviy platej = 700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2
-- zakupka materialov = 951FAEE9-8883-4AEF-8CB2-11AAC0A245E0
-- vozvrat kredita = AC03D0B4-8060-4E8D-BEF2-6B2382500DD0


declare @tmp int
PRINT 'test1';
PRINT 'bank balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1484AF9B-1B63-50DE-014C-16E575B61049');
PRINT @tmp;
PRINT 'kassa balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1A65B8E8-1761-57B3-144C-16E575B61049');
PRINT @tmp;
PRINT 'client balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '292BD755-7449-67DB-024C-16E575B61049');
PRINT @tmp;
PRINT 'supplier balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '28C681C4-4EB2-7172-004C-16E575B61049');
PRINT @tmp;


INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 400000,
 '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2',
 '670CB686-4CA3-1FC8-4593-373516031D8E',
 NULL,
 'first payment',
 '1985-11-06 18:14:57.750',
 '1484AF9B-1B63-50DE-014C-16E575B61049',
 '28C681C4-4EB2-7172-004C-16E575B61049',
 NULL,
 NULL,
 '1985-11-06 18:14:57.750',
 '12345',
 0,
 '13256');

PRINT 'new bank balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1484AF9B-1B63-50DE-014C-16E575B61049');
PRINT @tmp;
PRINT 'new kassa balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1A65B8E8-1761-57B3-144C-16E575B61049');
PRINT @tmp;
PRINT 'new client balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '292BD755-7449-67DB-024C-16E575B61049');
PRINT @tmp;
PRINT 'new supplier balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '28C681C4-4EB2-7172-004C-16E575B61049');
PRINT @tmp;

PRINT 'test2';
INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 100000,
 '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2',
 '670CB686-4CA3-1FC8-4593-373516031D8E',
 NULL,
 'second payment',
 '1985-11-06 18:14:57.750',
 '28C681C4-4EB2-7172-004C-16E575B61049',
 '292BD755-7449-67DB-024C-16E575B61049',
 NULL,
 NULL,
 '1985-11-06 18:14:57.750',
 '12345',
 0,
 '13256');

PRINT 'new bank balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1484AF9B-1B63-50DE-014C-16E575B61049');
PRINT @tmp;
PRINT 'new kassa balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1A65B8E8-1761-57B3-144C-16E575B61049');
PRINT @tmp;
PRINT 'new client balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '292BD755-7449-67DB-024C-16E575B61049');
PRINT @tmp;
PRINT 'new supplier balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '28C681C4-4EB2-7172-004C-16E575B61049');
PRINT @tmp;

PRINT 'test4';
INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment,
 Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
 VALUES (
 NEWID(),
 100000,
 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0',
 '670CB686-4CA3-1FC8-4593-373516031D8E',
 NULL,
 'fourth payment',
 '1985-11-06 18:14:57.750',
 '1A65B8E8-1761-57B3-144C-16E575B61049',
 '1484AF9B-1B63-50DE-014C-16E575B61049',
 NULL,
 NULL,
 '1985-11-06 18:14:57.750',
 '12345',
 0,
 '13256');

PRINT 'new bank balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1484AF9B-1B63-50DE-014C-16E575B61049');
PRINT @tmp;
PRINT 'new kassa balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '1A65B8E8-1761-57B3-144C-16E575B61049');
PRINT @tmp;
PRINT 'new client balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '292BD755-7449-67DB-024C-16E575B61049');
PRINT @tmp;
PRINT 'new supplier balance:'
set @tmp = (SELECT Balance FROM PaymentParticipant WHERE Oid = '28C681C4-4EB2-7172-004C-16E575B61049');
PRINT @tmp;
