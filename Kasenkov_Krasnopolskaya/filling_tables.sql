DECLARE @countEntry INT;

DECLARE @countPaymentParticipantTarget INT = 1000;
DECLARE @countClientTarget INT = 500;
DECLARE @countEmployeeTarget INT = 80;
DECLARE @countProjectTarget INT = 800;
DECLARE @countBankTarget INT = 10;
DECLARE @countCashboxTarget INT = 8;
DECLARE @countPaymentTarget INT = 50000;
DECLARE @countSupplierTarget INT = 100;

DECLARE @ID_1 uniqueidentifier;
DECLARE @ID_2 uniqueidentifier;
DECLARE @ID_3 uniqueidentifier;
DECLARE @ID_4 uniqueidentifier;


SET @countEntry = 0;
WHILE @countEntry < @countPaymentParticipantTarget
BEGIN
	SET @ID_1 = NEWID();
	SET @ID_2 = NEWID();
	SET @ID_3 = NEWID();
	INSERT PaymentData.dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) VALUES 
		(@ID_1, 
		ForGenerData.dbo.genBalance(@ID_1),
		ForGenerData.dbo.genRandomString(@ID_1), 
		-ForGenerData.dbo.genBalance(@ID_2), 
		NULL,
		(@countEntry%4+1),
		ForGenerData.dbo.genDate(@ID_1),
		ForGenerData.dbo.genDate(@ID_2),
		ForGenerData.dbo.genRandomString(@ID_2),
		ForGenerData.dbo.genBalance(@ID_2),
		ForGenerData.dbo.genBalance(@ID_3));
	SET @countEntry = @countEntry + 1;
END;


DECLARE @PaymentParticipantOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @PaymentParticipantOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.PaymentParticipant;


DECLARE @indexReadPaymentParticipant INT = 1;

SET @countEntry = 0;
WHILE @countEntry < @countSupplierTarget
BEGIN
	SET @ID_1 = NEWID();
	SET @ID_2 = NEWID();
	SET @ID_3 = NEWID();
	INSERT PaymentData.dbo.Supplier(Oid, Contact, ProfitByMaterialAsPayer, ProfitByMaterialAsPayee, CostByMaterialAsPayer) VALUES 
		((select Oid from @PaymentParticipantOids where num=@indexReadPaymentParticipant),
		ForGenerData.dbo.genFullName(@ID_1,@ID_2,@ID_3), 
		ForGenerData.dbo.genBinValue(@ID_1), 
		ForGenerData.dbo.genBinValue(@ID_2), 
		ForGenerData.dbo.genBinValue(@ID_3)); 
	SET @indexReadPaymentParticipant = @indexReadPaymentParticipant + 1;
	SET @countEntry = @countEntry + 1;
END;

SET @countEntry = 0;
WHILE @countEntry < @countClientTarget
BEGIN
	SET @ID_1 = NEWID();
	SET @ID_2 = NEWID();
	INSERT PaymentData.dbo.Client(Oid, FirstName, SecondName, Phone) VALUES 
		((select Oid from @PaymentParticipantOids where num=@indexReadPaymentParticipant),
		ForGenerData.dbo.genName(@ID_1),
		ForGenerData.dbo.genName(@ID_2),
		ForGenerData.dbo.genPhone(@ID_1));
	SET @indexReadPaymentParticipant = @indexReadPaymentParticipant + 1;
	SET @countEntry = @countEntry + 1;
END;



DECLARE @AccountTypeOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @AccountTypeOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.AccountType;

SET @countEntry = 0;
WHILE @countEntry < @countBankTarget
BEGIN
	INSERT PaymentData.dbo.Bank(Oid, AccountType) VALUES 
		((select Oid from @PaymentParticipantOids where num=@indexReadPaymentParticipant),
		 (select Oid from @AccountTypeOids where num=(@countEntry%4 + 1)));
	SET @indexReadPaymentParticipant = @indexReadPaymentParticipant + 1;
	SET @countEntry = @countEntry + 1;
END;

SET @countEntry = 0;
WHILE @countEntry < @countCashboxTarget
BEGIN
	INSERT PaymentData.dbo.Cashbox(Oid, AccountType) VALUES 
		((select Oid from @PaymentParticipantOids where num=@indexReadPaymentParticipant),
		 (select Oid from @AccountTypeOids where num=(@countEntry%4 + 1)));
	SET @indexReadPaymentParticipant = @indexReadPaymentParticipant + 1;
	SET @countEntry = @countEntry + 1;
END;

DECLARE @head uniqueidentifier = null;
SET @countEntry = 0;
WHILE @countEntry < @countEmployeeTarget
BEGIN
	SET @ID_1 = NEWID();
	SET @head = (select Oid from @PaymentParticipantOids where num=@indexReadPaymentParticipant);
	INSERT PaymentData.dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask) VALUES 
		(@head,
		 ForGenerData.dbo.genDate(@ID_1),
		 ForGenerData.dbo.genName(@ID_1),
		 ForGenerData.dbo.genBalance(@ID_1),
		 ForGenerData.dbo.genRandomInteger(@ID_1,500,3000),
		 ForGenerData.dbo.genPatronymic(@ID_1),
		 @countEntry%4 + 1,
		 @head,
		 ForGenerData.dbo.genRandomString(@ID_1))
	SET @indexReadPaymentParticipant = @indexReadPaymentParticipant + 1;
	SET @countEntry = @countEntry + 1;
END;


DECLARE @ClientOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @ClientOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.Client;

DECLARE @EmployeeOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @EmployeeOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.Employee;

SET @countEntry = 0;
WHILE @countEntry < @countProjectTarget
BEGIN
	SET @ID_1 = NEWID();
	SET @ID_2 = NEWID();
	SET @ID_3 = NEWID();
	SET @ID_4 = NEWID();

	INSERT PaymentData.dbo.Project(Oid, Name, Address, Client, Manager, Foreman, OptimisticLockField, GCRecord, Balance, BalanceByMaterial, BalanceByWork, PlaningStartDate, Status, FinishDate,
									Area, WorkPriceRate, WorkersPriceRate, RemainderTheAdvance, PlanfixWorkTask, PlanfixChangeRequestTask, UseAnalytics) VALUES 
		(@ID_1,		ForGenerData.dbo.genRandomString(@ID_1),
		ForGenerData.dbo.genAddress(@ID_1,@ID_2,@ID_3),		(select Oid from @ClientOids where num=((@countEntry+1)%@countClientTarget)),		(select Oid from @EmployeeOids where num=((@countEntry+1)%@countEmployeeTarget)),		(select Oid from @EmployeeOids where num=((@countEntry+2)%@countEmployeeTarget)), 		-ForGenerData.dbo.genBalance(@ID_1), 		NULL,		ForGenerData.dbo.genBalance(@ID_2),		ForGenerData.dbo.genBalance(@ID_3),		ForGenerData.dbo.genBalance(@ID_4),		ForGenerData.dbo.genDate(@ID_1), 		null,		ForGenerData.dbo.genDate(@ID_2),		ForGenerData.dbo.genRandomInteger(@ID_1, -10000, 10000),		ForGenerData.dbo.genRandomInteger(@ID_2, 0, 60000),		ForGenerData.dbo.genRandomInteger(@ID_3, 10, 900),		ForGenerData.dbo.genRandomInteger(@ID_4, -50, 30),
		ForGenerData.dbo.genRandomString(@ID_1),
		ForGenerData.dbo.genRandomString(@ID_2),
		ForGenerData.dbo.genBinValue(@ID_1));

	SET @countEntry = @countEntry + 1;
END;


DECLARE @PaymentCategoryOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @PaymentCategoryOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.PaymentCategory;

DECLARE @ProjectOids TABLE(
	num bigint INDEX ix CLUSTERED,
	Oid uniqueidentifier);
INSERT INTO @ProjectOids(num,Oid) select ROW_NUMBER() over(ORDER BY Oid) as num, Oid from PaymentData.dbo.Project;


SET @countEntry = 0;
WHILE @countEntry < @countPaymentTarget
BEGIN
	SET @ID_1 = NEWID();
	SET @ID_2 = NEWID();
	SET @ID_3 = NEWID();
	SET @ID_4 = NEWID();

	INSERT PaymentData.dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) VALUES 
		(@ID_1,
		ForGenerData.dbo.genRandomInteger(@ID_1, -10000, 10000),
		(select Oid from @PaymentCategoryOids where num=(@countEntry%45 + 1)),
		(select Oid from @ProjectOids where num=(@countEntry%@countProjectTarget + 1)),
		ForGenerData.dbo.genRandomString(@ID_1),
		ForGenerData.dbo.genRandomString(@ID_2),
		ForGenerData.dbo.genDate(@ID_1), 
		(select Oid from @PaymentParticipantOids where num=ForGenerData.dbo.genRandomInteger(@ID_1,1,@countPaymentParticipantTarget)),
		(select Oid from @PaymentParticipantOids where num=ForGenerData.dbo.genRandomInteger(@ID_2,1,@countPaymentParticipantTarget)),
		ForGenerData.dbo.genRandomInteger(@ID_1, -1000, 1000),
		NULL, 
		ForGenerData.dbo.genDate(@ID_2),
		ForGenerData.dbo.genRandomString(@ID_3),
		ForGenerData.dbo.genBinValue(@ID_1),
		ForGenerData.dbo.genRandomString(@ID_4));
	SET @countEntry = @countEntry + 1;
END;