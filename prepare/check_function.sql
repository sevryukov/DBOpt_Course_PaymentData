use PaymentData

begin tran T1;

declare @id_bank uniqueidentifier = NEWID()
declare @id_client uniqueidentifier = NEWID()
declare @id_cashbox uniqueidentifier = NEWID()
declare @id_supplier uniqueidentifier = NEWID()
declare @id_manager uniqueidentifier = NEWID()
declare @id_foreman uniqueidentifier = NEWID()
declare @id_project uniqueidentifier = NEWID()


insert dbo.PaymentParticipant
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
values (
		@id_bank,
        0,
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

insert dbo.PaymentParticipant(
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
values (
		@id_client,
        0,
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

insert dbo.PaymentParticipant(
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
values (
		@id_cashbox,
        0,
        N'Cashbox',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        null,
        0,
        0)

insert dbo.PaymentParticipant(
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
values (
		@id_supplier,
        0,
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
insert dbo.PaymentParticipant(
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
values (
		@id_manager,
        0,
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

insert dbo.PaymentParticipant(
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
values (
		@id_foreman,
        0,
        N'Foreman',
        1,
        null,
        1,
        '2023-02-07 21:36:00.000',
        null,
        null,
        0,
        0)


insert dbo.Bank(Oid, AccountType) values (@id_bank, '2126EF07-0276-4440-B71C-C353516A0946')

insert dbo.Client(Oid, FirstName, SecondName, Phone) values (@id_client, N'Test First Name', N'Test Second Name', N'(999) 999-9999')

insert dbo.Cashbox(Oid, AccountType) values (@id_cashbox, 'A126415B-734D-4D05-BF68-F888D680C5BA')

insert dbo.Supplier(Oid, Contact, ProfitByMaterialAsPayer, ProfitByMaterialAsPayee, CostByMaterialAsPayer) values (@id_supplier, N'Test Contact', 0, 1, 0)

insert dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask) values (@id_manager, '2023-02-07 21:36:00.000', N'Second Name 1', 1, 2000, N'P', 1, null, N'Task 1')

insert dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask) values (@id_foreman, '2023-02-07 21:36:00.000', N'Second Name 2', 1, 2500, N'PP', 2, null, N'Task 2')

insert dbo.Project(
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
values (
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
        1000000.00,
        1000.00,
        0,
        N'Task',
        N'Change request task',
        1
		)

declare @bank_balance int
declare @client_balance int
declare @cashbox_balance int
declare @supplier_balance int

set @bank_balance = (select Balance from PaymentParticipant where Oid = @id_bank)
set @client_balance = (select Balance from PaymentParticipant where Oid = @id_client)
set @cashbox_balance = (select Balance from PaymentParticipant where Oid = @id_cashbox)
set @supplier_balance = (select Balance from PaymentParticipant where Oid = @id_supplier)

declare @Category uniqueidentifier = '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2'

declare @Payment1Id uniqueidentifier = NEWID()
declare @Payment2Id uniqueidentifier = NEWID()
declare @Payment3Id uniqueidentifier = NEWID()
declare @Payment4Id uniqueidentifier = NEWID()

insert dbo.Payment(
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
values (
		@Payment1Id,
        400000,
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


set @Category = '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0'

insert dbo.Payment(
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
values (
		@Payment2Id,
        100000,
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

insert dbo.Payment(
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
values (
		@Payment3Id, 
        150000, 
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


set @Category = 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0'

insert dbo.Payment(
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
values (
		@Payment4Id,
        100000,
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

set @bank_balance = (select Balance from PaymentParticipant where Oid = @id_bank)
set @supplier_balance = (select Balance from PaymentParticipant where Oid = @id_supplier)
set @client_balance = (select Balance from PaymentParticipant where Oid = @id_client)
set @cashbox_balance = (select Balance from PaymentParticipant where Oid = @id_cashbox)

print N'Bank balance (table -300.000) : ' + CAST(@bank_balance as varchar)
print N'Client balance (table -50.000) : ' + CAST(@client_balance as varchar)
print N'Cashbox balance (table 50.000) : ' + CAST(@cashbox_balance as varchar)
print N'Supplier balance (table 30.000) : ' + CAST(@supplier_balance as varchar)
rollback tran T1;