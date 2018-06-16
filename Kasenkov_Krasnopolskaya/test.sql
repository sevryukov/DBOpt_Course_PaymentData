use PaymentData;

BEGIN TRAN T1;  

DECLARE @id_the_category uniqueidentifier
DECLARE @id_the_project uniqueidentifier

DECLARE @id_the_supplier uniqueidentifier
DECLARE @id_the_bank uniqueidentifier
DECLARE @id_the_client uniqueidentifier
DECLARE @id_the_cashbox uniqueidentifier

DECLARE @payment_supplier_to_bank int = 70
DECLARE @payment_bank_to_client int = 400
DECLARE @payment_client_to_cashbox int = 1000
DECLARE @payment_cashbox_to_supplier int = 3

DECLARE @balance_the_supplier_start int
DECLARE @balance_the_bank_start int
DECLARE @balance_the_client_start int
DECLARE @balance_the_cashbox_start int

DECLARE @balance_the_supplier_end int
DECLARE @balance_the_bank_end int
DECLARE @balance_the_client_end int
DECLARE @balance_the_cashbox_end int

set @id_the_category = (select Oid from (select TOP 1  Oid from PaymentCategory) as t1)
set @id_the_project = (select Oid from (select TOP 1  Oid from Project) as t1)

set @id_the_supplier = (select oid from (select TOP 1  PaymentParticipant.Oid as oid, balance from PaymentParticipant, Supplier where PaymentParticipant.Oid = Supplier.Oid order by balance desc)as t1)
set @id_the_bank = (select oid from (select TOP 1  PaymentParticipant.Oid as oid, balance from PaymentParticipant, Bank where PaymentParticipant.Oid = Bank.Oid order by balance desc)as t1)
set @id_the_client = (select oid from (select TOP 1  PaymentParticipant.Oid as oid, balance from PaymentParticipant, Client where PaymentParticipant.Oid = Client.Oid order by balance desc)as t1)
set @id_the_cashbox = (select oid from (select TOP 1  PaymentParticipant.Oid as oid, balance from PaymentParticipant, Cashbox where PaymentParticipant.Oid = Cashbox.Oid order by balance desc)as t1)

set @balance_the_supplier_start = (select balance from PaymentParticipant where Oid = @id_the_supplier)
set @balance_the_bank_start = (select balance from PaymentParticipant where Oid = @id_the_bank)
set @balance_the_client_start = (select balance from PaymentParticipant where Oid = @id_the_client)
set @balance_the_cashbox_start = (select balance from PaymentParticipant where Oid = @id_the_cashbox)


print  N'Balance the supplier: ' + CAST(@balance_the_supplier_start AS VARCHAR)
print  N'Balance the bank: ' + CAST(@balance_the_bank_start AS VARCHAR)
print  N'Balance the client: ' + CAST(@balance_the_client_start AS VARCHAR)
print  N'Balance the cashbox: ' + CAST(@balance_the_cashbox_start AS VARCHAR)

insert Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) values
	(NEWID(),
	 @payment_supplier_to_bank,
	 @id_the_category,
	 @id_the_project,
	 NULL,
	 N'Payment form supplier to bank',
	'1999-01-01 00:00:00.000', 
	 @id_the_supplier,
	 @id_the_bank,
	 NULL,
	 NULL,
	 '2000-02-02 01:01:01.000',
	 N'11111',
	 0,
	 N'22222')

insert Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) values
	(NEWID(),
	 @payment_bank_to_client,
	 @id_the_category,
	 @id_the_project,
	 NULL,
	 N'Payment form supplier to bank',
	'1999-01-01 00:00:00.000', 
	 @id_the_bank,
	 @id_the_client,
	 NULL,
	 NULL,
	 '2000-02-02 01:01:01.000',
	 N'11111',
	 0,
	 N'22222')

insert Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) values
	(NEWID(),
	 @payment_client_to_cashbox,
	 @id_the_category,
	 @id_the_project,
	 NULL,
	 N'Payment form supplier to bank',
	'1999-01-01 00:00:00.000', 
	 @id_the_client,
	 @id_the_cashbox,
	 NULL,
	 NULL,
	 '2000-02-02 01:01:01.000',
	 N'11111',
	 0,
	 N'22222')

insert Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) values
	(NEWID(),
	 @payment_cashbox_to_supplier,
	 @id_the_category,
	 @id_the_project,
	 NULL,
	 N'Payment form supplier to bank',
	'1999-01-01 00:00:00.000', 
	 @id_the_cashbox,
	 @id_the_supplier,
	 NULL,
	 NULL,
	 '2000-02-02 01:01:01.000',
	 N'11111',
	 0,
	 N'22222')

set @balance_the_supplier_end = (select balance from PaymentParticipant where Oid = @id_the_supplier)
set @balance_the_bank_end = (select balance from PaymentParticipant where Oid = @id_the_bank)
set @balance_the_client_end = (select balance from PaymentParticipant where Oid = @id_the_client)
set @balance_the_cashbox_end = (select balance from PaymentParticipant where Oid = @id_the_cashbox)

print  N'Balance the supplier: ' + CAST(@balance_the_supplier_end AS VARCHAR)
print  N'Balance the bank: ' + CAST(@balance_the_bank_end AS VARCHAR)
print  N'Balance the client: ' + CAST(@balance_the_client_end AS VARCHAR)
print  N'Balance the cashbox: ' + CAST(@balance_the_cashbox_end AS VARCHAR)

print N''

IF((@balance_the_supplier_start - @payment_supplier_to_bank + @payment_cashbox_to_supplier) = @balance_the_supplier_end)
	print N'Balance the supplier: Correct'
ELSE
	print N'Balance the supplier: Uncorrect'

IF((@balance_the_bank_start - @payment_bank_to_client + @payment_supplier_to_bank) = @balance_the_bank_end)
	print N'Balance the bank: Correct'
ELSE
	print N'Balance the bank: Uncorrect'

IF((@balance_the_client_start - @payment_client_to_cashbox + @payment_bank_to_client) = @balance_the_client_end)
	print N'Balance the client: Correct'
ELSE
	print N'Balance the client: Uncorrect'

IF((@balance_the_cashbox_start - @payment_cashbox_to_supplier + @payment_client_to_cashbox) = @balance_the_cashbox_end)
	print N'Balance the cashbox: Correct'
ELSE
	print N'Balance the cashbox: Uncorrect'


ROLLBACK TRAN T1;  