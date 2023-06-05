USE PaymentData

BEGIN TRAN T1;

DECLARE @id_bank UNIQUEIDENTIFIER = NEWID()
DECLARE @id_client UNIQUEIDENTIFIER = NEWID()
DECLARE @id_cashbox UNIQUEIDENTIFIER = NEWID()
DECLARE @id_supplier UNIQUEIDENTIFIER = NEWID()
DECLARE @id_manager UNIQUEIDENTIFIER = NEWID()
DECLARE @id_foreman UNIQUEIDENTIFIER = NEWID()
DECLARE @id_project UNIQUEIDENTIFIER = NEWID()


INSERT dbo.PaymentParticipant
		(
		Oid, 
		Balance, 
		Name, 
		OptimisticLockField, 
		GCRecord, 
		ObjectType, 
		ActiveFrom, 
		InactiveFrom,
		BankDetails,
		Balance2, 
		Balance3
		)
VALUES (
		@id_bank,
        1000,
        N'Bank',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        N'Details',
        0,
        0
		)

INSERT dbo.PaymentParticipant(
		Oid, 
		Balance, 
		Name, 
		OptimisticLockField, 
		GCRecord, 
		ObjectType, 
		ActiveFrom, 
		InactiveFrom,
		BankDetails, 
		Balance2, 
		Balance3
		)
VALUES (
		@id_client,
        10000,
        N'Client',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        null,
        0,
        0
		)

INSERT dbo.PaymentParticipant(
		Oid, 
		Balance, 
		Name, 
		OptimisticLockField, 
		GCRecord, 
		ObjectType, 
		ActiveFrom, 
		InactiveFrom,
		BankDetails, 
		Balance2, 
		Balance3
		)
VALUES (
		@id_cashbox,
        3000,
        N'Cashbox',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        null,
        0,
        0)

INSERT dbo.PaymentParticipant(
		Oid, 
		Balance, 
		Name, 
		OptimisticLockField, 
		GCRecord, 
		ObjectType, 
		ActiveFrom, 
		InactiveFrom,
		BankDetails, 
		Balance2, 
		Balance3
		)
VALUES (
		@id_supplier,
        4000,
        N'Supplier',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        null,
        0,
        0
		)
INSERT dbo.PaymentParticipant(
		Oid, 
		Balance, 
		Name, 
		OptimisticLockField, 
		GCRecord, 
		ObjectType, 
		ActiveFrom, 
		InactiveFrom,
		BankDetails, 
		Balance2, 
		Balance3
		)
VALUES (
		@id_manager,
        5000,
        N'Manager',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        null,
        0,
        0
		)

INSERT dbo.PaymentParticipant(
		Oid, 
		Balance, 
		Name, 
		OptimisticLockField, 
		GCRecord, 
		ObjectType, 
		ActiveFrom, 
		InactiveFrom,
		BankDetails, 
		Balance2, 
		Balance3
		)
VALUES (
		@id_foreman,
        7000,
        N'Foreman',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        null,
        0,
        0)


INSERT dbo.Bank(Oid, AccountType) VALUES (@id_bank, '2126EF07-0276-4440-B71C-C353516A0946')

INSERT dbo.Client(Oid, FirstName, SecondName, Phone) VALUES (@id_client, N'Test First Name', N'Test Second Name', N'(999) 999-9999')

INSERT dbo.Cashbox(Oid, AccountType) VALUES (@id_cashbox, 'A126415B-734D-4D05-BF68-F888D680C5BA')

INSERT dbo.Supplier(Oid, Contact, ProfitByMaterialAsPayer, ProfitByMaterialAsPayee, CostByMaterialAsPayer) VALUES (@id_supplier, N'Test Contact', 0, 1, 0)

INSERT dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask) VALUES (@id_manager, '2023-02-07 21:36:00.000', N'Second Name 1', 1, 2000, N'P', 1, null, N'Task 1')

INSERT dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask) VALUES (@id_foreman, '2023-02-07 21:36:00.000', N'Second Name 2', 1, 2500, N'PP', 2, null, N'Task 2')

INSERT dbo.Project(
		Oid, 
		Name, 
		Address, 
		Client, 
		Manager, 
		Foreman, 
		OptimisticLockField, 
		GCRecord, 
		Balance,
		BalanceByMaterial, 
		BalanceByWork, 
		PlaningStartDate, 
		Status, 
		FinishDate, 
		Area, 
		WorkPriceRate,
		WorkersPriceRate, 
		RemainderTheAdvance, 
		PlanfixWorkTask, 
		PlanfixChangeRequestTask, 
		UseAnalytics
		)
VALUES (
		@id_project,
        N'Project',
        N'Adress',
        @id_client,
        @id_manager,
        @id_foreman,
        0,
        null,
        3,
        0,
        0,
        '2023-02-07 21:36:00.000',
        1,
        '2023-02-07 21:36:00.000',
        10,
        1200000.00,
        1500.00,
        0,
        N'Task',
        N'Change request task',
        1
		)

DECLARE @bank_balance INT
DECLARE @client_balance INT
DECLARE @cashbox_balance INT
DECLARE @supplier_balance INT

SET @bank_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_bank)
SET @client_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_client)
SET @cashbox_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_cashbox)
SET @supplier_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_supplier)

DECLARE @Category UNIQUEIDENTIFIER = '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2'

DECLARE @Payment1Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment2Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment3Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment4Id UNIQUEIDENTIFIER = NEWID()

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
		)
VALUES (
		@Payment1Id,
        450000,
        @Category,
        @id_project,
        null,
        N'Money to supplier',
        '2020-26-06 21:22:00.000',
        @id_bank,
        @id_supplier,
        null,
        null,
        '2023-02-07 21:36:00.000',
        N'12345',
        null,
        N'12345'
		)


SET @Category = '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0'

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
		)
VALUES (
		@Payment2Id,
        10000,
        @Category,
        @id_project,
        null,
        N'Payment for materials',
        '2023-02-07 21:36:00.000',
        @id_supplier,
        @id_client,
        null,
        null, 
        '2023-02-07 21:36:00.000', 
        N'12345', 
        null,
        N'12345'
		)

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
		)
VALUES (
		@Payment3Id, 
        170000, 
        @Category, 
        @id_project, 
        null, 
        N'Client payment for materials',
        '2023-02-07 21:36:00.000', 
        @id_client, 
        @id_cashbox, 
        null, 
        null, 
        '2023-02-07 21:36:00.000', 
        N'12345', 
        null, 
        N'12345'
		)


SET @Category = 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0'

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
		)
VALUES (
		@Payment4Id,
        150000,
        @Category,
        @id_project,
        null,
        N'Partially pay off the loan',
        '2023-02-07 21:36:00.000',
        @id_cashbox,
        @id_bank,
        null,
        null,
        '2023-02-07 21:36:00.000',
        N'12345',
        null,
        N'12345')

SET @bank_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_bank)
SET @supplier_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_supplier)
SET @client_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_client)
SET @cashbox_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @id_cashbox)

PRINT N'Expected Bank balance: -300.000,  calculated: ' + CAST(@bank_balance AS VARCHAR)
PRINT N'Expected Client balance: -160.000, claculated: ' + CAST(@client_balance AS VARCHAR)
PRINT N'Expected Cashbox balance: 20.000, calculated: ' + CAST(@cashbox_balance AS VARCHAR)
PRINT N'Expected Supplier balance: 44.000, calculated: ' + CAST(@supplier_balance AS VARCHAR)
ROLLBACK TRAN T1;