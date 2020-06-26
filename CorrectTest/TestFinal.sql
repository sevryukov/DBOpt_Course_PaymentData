USE [PaymentData]
GO
 
 
BEGIN TRAN tranzac;  
 
-- Для тестирования корректности расчета баланса была взята
-- за пример таблица из файла с описанием данных (Balance description.pdf).
-- При этом сгенерированы новые сущности для банка, клиента и т.д.
 
 
-- создаем тестовые данные
DECLARE @BankId UNIQUEIDENTIFIER = NEWID()
DECLARE @ClientId UNIQUEIDENTIFIER = NEWID()
DECLARE @CashboxId UNIQUEIDENTIFIER = NEWID()
DECLARE @SupplierId UNIQUEIDENTIFIER = NEWID()
DECLARE @ManagerId UNIQUEIDENTIFIER = NEWID()
DECLARE @ForemanId UNIQUEIDENTIFIER = NEWID()
DECLARE @ProjectId UNIQUEIDENTIFIER = NEWID()
 
 
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
    VALUES (@BankId,
        0,
        N'Банк',
        1,
        NULL,
        1,
        '2020-01-01 00:00:00.000',
        NULL,
        'HJOX IT YO WW7',
        0,
        0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
    VALUES (@ClientID,
    0,
    N'Клиент',
    1,
    NULL,
    1,
    '2020-01-01 01:00:00.000',
    NULL,
    NULL,
    0,
    0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
    VALUES (@CashboxID,
    0,
    N'Касса',
    1,
    NULL,
    1,
    '2020-01-01 02:00:00.000',
    NULL,
    NULL,
    0,
    0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
    VALUES (@SupplierID,
    0,
    N'Поставщик',
    1,
    NULL,
    1,
    '2020-01-01 03:00:00.000',
    NULL,
    NULL,
    0,
    0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
    VALUES (@ManagerId,
    0,
    N'Менеджер',
    1,
    NULL,
    1,
    '2020-01-01 04:00:00.000',
    NULL,
    NULL,
    0,
    0)
INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
    VALUES (@ForemanId,
    0,
    N'Босс',
    1,
    NULL,
    1,
    '2020-01-01 05:00:00.000',
    NULL,
    NULL,
    0,
    0)
 
-- Авансовый
INSERT dbo.Bank(Oid, AccountType) VALUES (@BankId, '2126EF07-0276-4440-B71C-C353516A0946')
 
INSERT dbo.Client(Oid, FirstName, SecondName, Phone) VALUES (@ClientId, N'Petr', N'Petrov', N'1(123) 456-7890')
 
-- Текущий
INSERT dbo.Cashbox(Oid, AccountType) VALUES (@CashboxId, 'A126415B-734D-4D05-BF68-F888D680C5BA')
 
INSERT dbo.Supplier(Oid, Contact, ProfitByMaterialAsPayer, ProfitByMaterialAsPayee, CostByMaterialAsPayer) VALUES (@SupplierId, N'abacaba', 0, 1, 0)
 
INSERT dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask)
    VALUES (@ManagerId, '2020-01-01 06:00:00.000', N'Ivanov', 1, 2, N'P', 1, NULL, N't1')
INSERT dbo.Employee(Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask)
    VALUES (@ForemanId, '2020-01-01 07:00:00.000', N'Sidorov', 1, 3, N'PP', 2, NULL, N't2')
INSERT dbo.Project(Oid, Name, Address, Client, Manager, Foreman, OptimisticLockField, GCRecord, Balance, BalanceByMaterial, BalanceByWork, PlaningStartDate, Status, FinishDate, Area, WorkPriceRate, WorkersPriceRate, RemainderTheAdvance, PlanfixWorkTask, PlanfixChangeRequestTask, UseAnalytics)
    VALUES (@ProjectId, N'proj', N'addr', @ClientId, @ManagerId, @ForemanId, 0, NULL, 3, 0, 0, '2020-01-01 01:00:00.000', 1, '2020-01-01 01:00:00.000', 10, 1000000.00, 1000.00, 0, N't', N'tt', 1)
 
DECLARE @BankBalance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @BankId)
DECLARE @ClientBalance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @ClientId)
DECLARE @CashboxBalance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @CashboxId)
DECLARE @SupplierBalance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @SupplierId)
 
-- проводим рассчеты с помощью функций
-- Авансовые платежи
DECLARE @Category UNIQUEIDENTIFIER = '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2'
 
DECLARE @Payment1Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment2Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment3Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Payment4Id UNIQUEIDENTIFIER = NEWID()
 
-- 1 строка
INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
    VALUES (@Payment1Id, 400000, @Category, @ProjectId, NULL, N'Перевели денег поставщику для будущих закупок. Образовался долг банку.', '2010-05-05 00:00:00.000', @BankId, @SupplierId, NULL, NULL, '2010-05-05 00:00:00.000', N'31862', NULL, N'001')
 
SET @BankBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @BankId)
SET @SupplierBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @SupplierId)
SET @ClientBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @ClientId)
SET @CashboxBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @CashboxId)
 
PRINT 'Баланс после первой операции'
PRINT N'Баланс банка: ' + CONVERT(varchar(10), @BankBalance)
PRINT N'Баланс клиента: ' + CONVERT(varchar(10), @ClientBalance)
PRINT N'Баланс кассы: ' + CONVERT(varchar(10), @CashboxBalance)
PRINT N'Баланс поставщика: ' + CONVERT(varchar(10), @SupplierBalance)
 
-- Закупка материалов
SET @Category  = '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0'
 
INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
    VALUES (@Payment2Id, 100000, @Category, @ProjectId, NULL, N'Для клиента приобрели материал. Поставщик нам должен меньше, а клиент должен за материалы.', '2010-06-06 00:00:00.000', @SupplierId, @ClientId, NULL, NULL, '2010-06-06 00:00:00.000', N'31863', NULL, N'002')
 
SET @BankBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @BankId)
SET @SupplierBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @SupplierId)
SET @ClientBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @ClientId)
SET @CashboxBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @CashboxId)
 
PRINT 'Баланс после второй операции'
PRINT N'Баланс банка: ' + CONVERT(varchar(10), @BankBalance)
PRINT N'Баланс клиента: ' + CONVERT(varchar(10), @ClientBalance)
PRINT N'Баланс кассы: ' + CONVERT(varchar(10), @CashboxBalance)
PRINT N'Баланс поставщика: ' + CONVERT(varchar(10), @SupplierBalance)
 
INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
    VALUES (@Payment3Id, 150000, @Category, @ProjectId, NULL, N'Клиент передал наличные для закупки материалов.', '2010-07-07 00:00:00.000', @ClientId, @CashboxId, NULL, NULL, '2010-07-07 00:00:00.000', N'31864', NULL, N'003')
 
SET @BankBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @BankId)
SET @SupplierBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @SupplierId)
SET @ClientBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @ClientId)
SET @CashboxBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @CashboxId)
 
PRINT 'Баланс после третьей операции'
PRINT N'Баланс банка: ' + CONVERT(varchar(10), @BankBalance)
PRINT N'Баланс клиента: ' + CONVERT(varchar(10), @ClientBalance)
PRINT N'Баланс кассы: ' + CONVERT(varchar(10), @CashboxBalance)
PRINT N'Баланс поставщика: ' + CONVERT(varchar(10), @SupplierBalance)
 
-- Возврат кредита
SET @Category = 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0'
 
INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
    VALUES (@Payment4Id, 100000, @Category, @ProjectId, NULL, N'Частично гасим кредит.', '2010-08-08 00:00:00.000', @CashboxId, @BankId, NULL, NULL, '2010-08-08 00:00:00.000', N'31865', NULL, N'004')
 
SET @BankBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @BankId)
SET @SupplierBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @SupplierId)
SET @ClientBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @ClientId)
SET @CashboxBalance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @CashboxId)
 
PRINT 'Баланс после 4 операции:'
PRINT N'Баланс банка: ' + CONVERT(varchar(10), @BankBalance)
PRINT N'Баланс клиента: ' + CONVERT(varchar(10), @ClientBalance)
PRINT N'Баланс кассы: ' + CONVERT(varchar(10), @CashboxBalance)
PRINT N'Баланс поставщика: ' + CONVERT(varchar(10), @SupplierBalance)
 
ROLLBACK TRAN tranzac;
