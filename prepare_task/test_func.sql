USE PaymentData

DECLARE @bank_oid UNIQUEIDENTIFIER = NEWID()
DECLARE @client_oid UNIQUEIDENTIFIER = NEWID()
DECLARE @cashbox_oid UNIQUEIDENTIFIER = NEWID()
DECLARE @supplier_oid UNIQUEIDENTIFIER = NEWID()
DECLARE @manager_oid UNIQUEIDENTIFIER = NEWID()
DECLARE @foreman_oid UNIQUEIDENTIFIER = NEWID()
DECLARE @project_oid UNIQUEIDENTIFIER = NEWID()

DECLARE @balance_supplier_start INT = 0
DECLARE @balance_bank_start INT = 0
DECLARE @balance_client_start INT = 0
DECLARE @balance_cashbox_start INT = 0

DECLARE @bank_to_supplier  INT = 400000
DECLARE @supplier_to_client  INT = 100000
DECLARE @client_to_cashbox 	 INT  = 150000
DECLARE @cashbox_to_bank INT = 100000

INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@bank_oid, 0, 'test_name_bank', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@client_oid, 0, 'test_name_client', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@cashbox_oid, 0, 'test_name_cashbox', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@supplier_oid, 0, 'test_name_supplier', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@manager_oid, 0, 'test_name_manager', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) 
	VALUES (@foreman_oid, 0, 'test_name_foreman', 1, NULL, 1, '2023-01-01 00:00:00.000', NULL, NULL, 0, 0)

INSERT dbo.Bank(Oid, AccountType) VALUES (@bank_oid, '2126EF07-0276-4440-B71C-C353516A0946')
INSERT dbo.Client(Oid, FirstName) VALUES (@client_oid, 'test')
INSERT dbo.Cashbox(Oid, AccountType) VALUES (@cashbox_oid, 'A126415B-734D-4D05-BF68-F888D680C5BA')
INSERT dbo.Supplier(Oid, Contact, ProfitByMaterialAsPayer, ProfitByMaterialAsPayee, CostByMaterialAsPayer) VALUES (@supplier_oid, 'test_contact', 0, 1, 0)
INSERT dbo.Employee(Oid, BusyUntil, Stuff, HourPrice, PlanfixId, Head, PlanfixMoneyRequestTask) 
	VALUES (@manager_oid, '2023-01-01 00:00:00.000', 1, 2000, 1, NULL, 'task_1')
INSERT dbo.Employee(Oid, BusyUntil, Stuff, HourPrice, PlanfixId, Head, PlanfixMoneyRequestTask) 
	VALUES (@foreman_oid, '2023-02-02 00:00:00.000', 1, 2500, 2, NULL, 'task_2')
INSERT dbo.Project(Oid, Name, Address, Client, Manager, Foreman, OptimisticLockField, GCRecord, Balance, BalanceByMaterial, BalanceByWork, PlaningStartDate, Status, FinishDate, Area, WorkPriceRate, WorkersPriceRate, RemainderTheAdvance, PlanfixWorkTask, PlanfixChangeRequestTask, UseAnalytics) 
	VALUES (@project_oid, 'test_name_project', 'test_address', @client_oid, @manager_oid, @foreman_oid, 0, NULL, 3, 0, 0, '2023-04-01 00:00:00.000', 1, '2024-01-01 00:00:00.000', 10, 1000000.00, 1000.00, 0, 'work_task', 'change_request_task', 1)

DECLARE @bank_balance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_oid)
DECLARE @client_balance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_oid)
DECLARE @cashbox_balance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_oid)
DECLARE @supplier_balance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_oid)


DECLARE @payment_id_1 UNIQUEIDENTIFIER = NEWID()
DECLARE @payment_id_2 UNIQUEIDENTIFIER = NEWID()
DECLARE @payment_id_3 UNIQUEIDENTIFIER = NEWID()
DECLARE @payment_id_4 UNIQUEIDENTIFIER = NEWID()

-- Аванс

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@payment_id_1, @bank_to_supplier, '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2', @project_oid, NULL, 'test1', '2023-01-01 00:00:00.000', @bank_oid, @supplier_oid, NULL, NULL, '2023-01-01 00:00:00.000', '1', NULL, '1')

-- Закупка материалов

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@payment_id_2, @supplier_to_client, '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0', @project_oid, NULL, 'test2', '2023-02-01 00:00:00.000', @supplier_oid, @client_oid, NULL, NULL, '2023-02-01 00:00:00.000', '2', NULL, '2')

-- На закупку материалов

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@payment_id_3, @client_to_cashbox, '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0', @project_oid, NULL, 'test3', '2023-03-01 00:00:00.000', @client_oid, @cashbox_oid, NULL, NULL, '2023-03-01 00:00:00.000', '3', NULL, '3')

-- Возврат кредита

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES (@payment_id_4, @cashbox_to_bank, 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0', @project_oid, NULL, 'test4', '2023-04-01 00:00:00.000', @cashbox_oid, @bank_oid, NULL, NULL, '2023-04-01 00:00:00.000', '4', NULL, '4')

SET @bank_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_oid)
SET @supplier_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_oid)
SET @client_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_oid)
SET @cashbox_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_oid)

PRINT 'Проверяем балансы:'


IF((@balance_supplier_start - @bank_to_supplier + @cashbox_to_bank) = @bank_balance)
	print 'Баланс банка = Рассчитанному балансу'
ELSE
	print 'Баланс банка != Рассчитанному балансу'

IF((@balance_bank_start - @supplier_to_client  + @bank_to_supplier ) = @supplier_balance)
	print 'Баланс поставщика = Рассчитанному балансу'
ELSE
	print 'Баланс поставщика != Рассчитанному балансу'

IF((@balance_client_start - @client_to_cashbox  + @supplier_to_client ) = @client_balance)
	print 'Баланс клиента = Рассчитанному балансу'
ELSE
	print 'Баланс клиента != Рассчитанному балансу'

IF((@balance_cashbox_start - @cashbox_to_bank  + @client_to_cashbox) = @cashbox_balance)
	print 'Баланс кассы = Рассчитанному балансу'
ELSE
	print 'Баланс кассы != Рассчитанному балансу'


-- очистка 
DELETE FROM dbo.Payment WHERE Oid = @payment_id_4
DELETE FROM dbo.Payment WHERE Oid = @payment_id_3
DELETE FROM dbo.Payment WHERE Oid = @payment_id_2
DELETE FROM dbo.Payment WHERE Oid = @payment_id_1

DELETE FROM dbo.Project WHERE Oid = @project_oid
DELETE FROM dbo.Employee WHERE Oid = @foreman_oid
DELETE FROM dbo.Employee WHERE Oid = @manager_oid

DELETE FROM dbo.Cashbox WHERE Oid = @cashbox_oid
DELETE FROM dbo.Client WHERE Oid = @client_oid
DELETE FROM dbo.Supplier WHERE Oid = @supplier_oid
DELETE FROM dbo.Bank WHERE Oid = @bank_oid

DELETE FROM dbo.PaymentParticipant WHERE Oid = @foreman_oid
DELETE FROM dbo.PaymentParticipant WHERE Oid = @manager_oid
DELETE FROM dbo.PaymentParticipant WHERE Oid = @cashbox_oid
DELETE FROM dbo.PaymentParticipant WHERE Oid = @client_oid
DELETE FROM dbo.PaymentParticipant WHERE Oid = @supplier_oid
DELETE FROM dbo.PaymentParticipant WHERE Oid = @bank_oid