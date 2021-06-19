USE master;

go
-- IF (select DB_NAME()) <> N'master' SET NOEXEC ON

--
-- Создать базу данных [PaymentData]
--
PRINT (N'Создать базу данных [PaymentData]')
GO
IF DB_ID('PaymentData') IS NULL
CREATE DATABASE PaymentData
GO

USE PaymentData
GO

IF DB_NAME() <> N'PaymentData' SET NOEXEC ON
GO

--
-- Создать таблицу [dbo].[PaymentParticipant]
-- Эта таблица содержит базовые данные всех участников платежей
--
PRINT (N'Создать таблицу [dbo].[PaymentParticipant]')
GO
IF OBJECT_ID(N'dbo.PaymentParticipant', 'U') IS NULL
CREATE TABLE dbo.PaymentParticipant (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Balance int NULL,
  Name nvarchar(100) NULL,
  OptimisticLockField int NULL, -- Здесь и в других таблицах: специальное поле для отслеживания версий. К задаче оптимизации отношения не имеет.
  GCRecord int NULL, -- Здесь и далее: флаг удаления. Если значение отличается от Null, значит запись удалена
  ObjectType int NULL, -- Тип платильщика. Допустимы следующие типы платильщиков: Безналичный счёт, наличный счёт, клиент, сотрудник, поставщик
  ActiveFrom datetime NULL,
  InactiveFrom datetime NULL,
  BankDetails nvarchar(399) NULL,
  Balance2 int NULL,
  Balance3 int NULL,
  CONSTRAINT PK_PaymentParticipant PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]
--
PRINT (N'Создать индекс [iGCRecord_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_PaymentParticipant' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
CREATE INDEX iGCRecord_PaymentParticipant
  ON dbo.PaymentParticipant (GCRecord)
  ON [PRIMARY]
GO

--
-- Создать индекс [iObjectType_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]
--
PRINT (N'Создать индекс [iObjectType_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iObjectType_PaymentParticipant' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'ObjectType' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
CREATE INDEX iObjectType_PaymentParticipant
  ON dbo.PaymentParticipant (ObjectType)
  ON [PRIMARY]
GO

--
-- Создать таблицу [dbo].[PaymentCategory]
-- Эта таблица содержит категории платежа. В зависимости от категории, платёж участвует в том или ином балансе
--
PRINT (N'Создать таблицу [dbo].[PaymentCategory]')
GO
IF OBJECT_ID(N'dbo.PaymentCategory', 'U') IS NULL
CREATE TABLE dbo.PaymentCategory (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Name nvarchar(100) NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  ProfitByMaterial bit NULL, -- Флаг, говорящий о том, что платёж с этой категорией рассматривается как доход в балансе по материалам
  CostByMaterial bit NULL, -- Флаг, говорящий о том, что платёж с этой категорией рассматривается как расход в балансе по материалам
  NotInPaymentParticipantProfit bit NULL, -- Флаг, говорящий о том, что платёж с этой категорией не участвует в расчёте дохода участника платежа
  CONSTRAINT PK_PaymentCategory PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_PaymentCategory] для объекта типа таблица [dbo].[PaymentCategory]
--
PRINT (N'Создать индекс [iGCRecord_PaymentCategory] для объекта типа таблица [dbo].[PaymentCategory]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_PaymentCategory' AND object_id = OBJECT_ID(N'dbo.PaymentCategory'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.PaymentCategory'))
CREATE INDEX iGCRecord_PaymentCategory
  ON dbo.PaymentCategory (GCRecord)
  ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу PaymentCategory')
GO
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('f0f25486-f0e2-4c0a-99d3-068508d13eaf', N'Аванс на материалы', 4, NULL, CONVERT(bit, 'True'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('cdca2762-818e-408a-9e57-08c515c2d87e', N'Оплата работ подрядчика', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('eeff9d97-f6d1-4318-9391-0a83f7fb9b46', N'Личные расходы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('48a33b35-5606-40c3-8b34-0ad2d2036874', N'Расходы на командообразование', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('a9beeccc-6ff2-440f-a768-0f5d95f56f68', N'Компенсируемые расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'True'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('951faee9-8883-4aef-8cb2-11aac0a245e0', N'Закупка материалов', 2, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'True'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('4dc5f40c-206b-4754-9336-1431dda54072', N'Уплата комиссии', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('700ab7dd-72ae-4f01-a7e2-1dbc341ed4c2', N'Авансовые платежи', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('3498d54b-e9b1-4e48-bf1f-27d107f281f1', N'Переход года', 3, NULL, CONVERT(bit, 'True'), CONVERT(bit, 'True'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('494a13dc-f5b2-4559-b753-28c84173b0e7', N'Списание убытков', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('d831594d-d145-40b4-87b4-2a3a7b62a6cd', N'Бонусное поступление', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('b994305a-4e7d-4309-baae-2db3da972bed', N'Возврат долга', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('ba43961f-6903-4c1f-9f7c-2f9afd9c05a0', N'Оплата бонусов зарплатникам', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('f1362210-ec04-4e4d-8675-353430c3af7f', N'Накладные расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('c7554c3e-056a-4577-971d-365aadc15a05', N'Уплата процентов по кредиту', 3, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('c6132b41-dd99-49e3-808e-4436be30c485', N'Подрядное поступление', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('60219579-cc7b-44c3-a5cb-4dca47a93b9e', N'Маркетинг', 3, 1559123771, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('6d3c6db4-2e14-4c8b-b5c3-50c9c1ae2a5b', N'Аванс на работы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('06897bea-4012-442a-a92b-5327ff546f37', N'Оплата работ сдельщиков', 7, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('e33864db-6b91-4017-a13c-53ed08e4ea5f', N'Расходные подотчетные', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('3b66ff7e-6a63-409c-9e21-59c420260ba5', N'Списание долга', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('7249bf2e-4d51-4a97-b62e-632ffeedc961', N'Получение кредита', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('ac03d0b4-8060-4e8d-bef2-6b2382500dd0', N'Возврат кредита', 0, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('f601cfb6-93ed-4087-822a-6f2fed3eeb0a', N'Расходы на маркетинг', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('e0d56999-c9a7-4a1b-a995-77fc9e94aa04', N'Процентный доход', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('536199bf-9119-4659-a22b-783d05d4c715', N'Прочие поступления', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('52399204-dd9b-485c-9ebc-78aa27d7e2e8', N'Оплата работ зарплатников', 7, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('0d0e2c4b-3bee-405a-a6b3-78dc4d4abb2c', N'Накладные производственные расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('8aa549ff-ee0f-445d-b539-7ca53116a737', N'Выдача в новый долг', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('08a4bad6-f7b6-40ac-ab10-8a7f24ab536b', N'Вывод прибыли учредителя', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('b747e6e7-817d-4b3c-8bd2-91481acb46a6', N'Транзитный платеж', 3, 2052795103, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('639d2087-d6b5-4fd0-aefd-a572a4256ca3', N'Оплата бонусов сдельщикам', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('a3228980-1fd3-4570-868b-b3911492664e', N'Выдача в долг', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('07ea1363-fd9d-4b15-ac3e-c98407443665', N'Оплата работ', 3, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('bc5546da-69fa-4590-8023-e49a9150dff3', N'Представительские расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('cde5137c-6254-425e-9bc4-e6216658f4d5', N'Закупка инструмента', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('052d72eb-46a2-47da-8773-e6737c247f55', N'Списание материалов', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'True'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('6caa35ef-d394-4a9f-b08f-e6848b41e96c', N'Премия сотрудникам', 5, 1446639774, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('1ba76857-e16f-4c22-a75f-e79e5722adba', N'Административные расходы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('a16b0742-af56-4167-b085-ea642223cf2f', N'Возврат нового долга', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('9e85d735-6c53-4220-ad79-edf820cc7fed', N'Расходы на развитие', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('37425433-0989-4271-a6fd-f32af5bf9b26', N'Расчет смет', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('2450c83a-ce38-4748-b056-f92670410ec4', N'Бонусные вознаграждения', 3, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('69d0c922-3eea-47fb-9c22-f9c50b2846df', N'Технические переводы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('3abdc23d-93e0-4727-92ad-faf29216496d', N'Кредит', 2, 1385438376, NULL, NULL, NULL)
GO

--
-- Создать таблицу [dbo].[Supplier]
-- Поставщики
--
PRINT (N'Создать таблицу [dbo].[Supplier]')
GO
CREATE TABLE dbo.Supplier (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Contact nvarchar(100) NULL,
  ProfitByMaterialAsPayer bit NULL, -- Если установлен данный влаг, то при расчёте баланса по материалам учитываются платежи с этм поставщиком в роли плательщика как доход
  ProfitByMaterialAsPayee bit NULL, -- Если установлен данный влаг, то при расчёте баланса по материалам учитываются платежи с этм поставщиком в роли получателя платежа как доход
  CostByMaterialAsPayer bit NULL, -- Если установлен данный влаг, то при расчёте баланса по материалам учитываются платежи с этм поставщиком в роли плательщика как расход
  CONSTRAINT PK_Supplier PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Supplier_Oid] для объекта типа таблица [dbo].[Supplier]
--
PRINT (N'Создать внешний ключ [FK_Supplier_Oid] для объекта типа таблица [dbo].[Supplier]')
GO
ALTER TABLE dbo.Supplier WITH NOCHECK
  ADD CONSTRAINT FK_Supplier_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO
SET NOEXEC OFF
GO

--
-- Создать таблицу [dbo].[Employee]
--
PRINT (N'Создать таблицу [dbo].[Employee]')
GO
IF OBJECT_ID(N'dbo.Employee', 'U') IS NULL
CREATE TABLE dbo.Employee (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  BusyUntil datetime NULL,
  SecondName nvarchar(100) NULL,
  Stuff int NULL,
  HourPrice int NULL,
  Patronymic nvarchar(100) NULL,
  PlanfixId int NULL,  
  Head uniqueidentifier NULL, -- руководитель
  PlanfixMoneyRequestTask nvarchar(255) NULL,
  CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iHead_Employee] для объекта типа таблица [dbo].[Employee]
--
PRINT (N'Создать индекс [iHead_Employee] для объекта типа таблица [dbo].[Employee]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iHead_Employee' AND object_id = OBJECT_ID(N'dbo.Employee'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Head' AND object_id = OBJECT_ID(N'dbo.Employee'))
CREATE INDEX iHead_Employee
  ON dbo.Employee (Head)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Employee_Head] для объекта типа таблица [dbo].[Employee]
--
PRINT (N'Создать внешний ключ [FK_Employee_Head] для объекта типа таблица [dbo].[Employee]')
GO
IF OBJECT_ID('dbo.FK_Employee_Head', 'F') IS NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Head' AND object_id = OBJECT_ID(N'dbo.Employee'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
ALTER TABLE dbo.Employee WITH NOCHECK
  ADD CONSTRAINT FK_Employee_Head FOREIGN KEY (Head) REFERENCES dbo.Employee (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Employee_Oid] для объекта типа таблица [dbo].[Employee]
--
PRINT (N'Создать внешний ключ [FK_Employee_Oid] для объекта типа таблица [dbo].[Employee]')
GO
IF OBJECT_ID('dbo.FK_Employee_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Employee WITH NOCHECK
  ADD CONSTRAINT FK_Employee_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[Project]
-- Таблица содержит сведения об объектах работ (объектах недвижимости)
--
PRINT (N'Создать таблицу [dbo].[Project]')
GO
IF OBJECT_ID(N'dbo.Project', 'U') IS NULL
CREATE TABLE dbo.Project (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Name nvarchar(100) NULL,
  Address nvarchar(100) NULL,
  Client uniqueidentifier NULL,
  Manager uniqueidentifier NULL,
  Foreman uniqueidentifier NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  Balance int NULL, -- Общий баланс - сумма всех балансов
  BalanceByMaterial int NULL, -- Баланс по материалам
  BalanceByWork int NULL, -- Баланс по работам
  PlaningStartDate datetime NULL,
  Status int NULL,
  FinishDate datetime NULL,
  Area int NULL,
  WorkPriceRate float NULL,
  WorkersPriceRate float NULL,
  RemainderTheAdvance int NULL,
  PlanfixWorkTask nvarchar(512) NULL,
  PlanfixChangeRequestTask nvarchar(512) NULL,
  UseAnalytics bit NULL,
  CONSTRAINT PK_Project PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iClient_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iClient_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iClient_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Client' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iClient_Project
  ON dbo.Project (Client)
  ON [PRIMARY]
GO

--
-- Создать индекс [iForeman_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iForeman_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iForeman_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Foreman' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iForeman_Project
  ON dbo.Project (Foreman)
  ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iGCRecord_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iGCRecord_Project
  ON dbo.Project (GCRecord)
  ON [PRIMARY]
GO

--
-- Создать индекс [iManager_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iManager_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iManager_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Manager' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iManager_Project
  ON dbo.Project (Manager)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Project_Foreman] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать внешний ключ [FK_Project_Foreman] для объекта типа таблица [dbo].[Project]')
GO
IF OBJECT_ID('dbo.FK_Project_Foreman', 'F') IS NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Foreman' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
ALTER TABLE dbo.Project WITH NOCHECK
  ADD CONSTRAINT FK_Project_Foreman FOREIGN KEY (Foreman) REFERENCES dbo.Employee (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Project_Manager] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать внешний ключ [FK_Project_Manager] для объекта типа таблица [dbo].[Project]')
GO
IF OBJECT_ID('dbo.FK_Project_Manager', 'F') IS NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Manager' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
ALTER TABLE dbo.Project WITH NOCHECK
  ADD CONSTRAINT FK_Project_Manager FOREIGN KEY (Manager) REFERENCES dbo.Employee (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[Client]
--
PRINT (N'Создать таблицу [dbo].[Client]')
GO
IF OBJECT_ID(N'dbo.Client', 'U') IS NULL
CREATE TABLE dbo.Client (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  FirstName nvarchar(100) NULL,
  SecondName nvarchar(100) NULL,
  Phone nvarchar(100) NULL,  
  CONSTRAINT PK_Client PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Client_Oid] для объекта типа таблица [dbo].[Client]
--
PRINT (N'Создать внешний ключ [FK_Client_Oid] для объекта типа таблица [dbo].[Client]')
GO
IF OBJECT_ID('dbo.FK_Client_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Client', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Client'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Client WITH NOCHECK
  ADD CONSTRAINT FK_Client_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Project_Client] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать внешний ключ [FK_Project_Client] для объекта типа таблица [dbo].[Project]')
GO
IF OBJECT_ID('dbo.FK_Project_Client', 'F') IS NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Client', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Client' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Client'))
ALTER TABLE dbo.Project WITH NOCHECK
  ADD CONSTRAINT FK_Project_Client FOREIGN KEY (Client) REFERENCES dbo.Client (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[AccountType]
-- Тип счёта
--
PRINT (N'Создать таблицу [dbo].[AccountType]')
GO
IF OBJECT_ID(N'dbo.AccountType', 'U') IS NULL
CREATE TABLE dbo.AccountType (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Name nvarchar(100) NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  CONSTRAINT PK_AccountType PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_AccountType] для объекта типа таблица [dbo].[AccountType]
--
PRINT (N'Создать индекс [iGCRecord_AccountType] для объекта типа таблица [dbo].[AccountType]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_AccountType' AND object_id = OBJECT_ID(N'dbo.AccountType'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.AccountType'))
CREATE INDEX iGCRecord_AccountType
  ON dbo.AccountType (GCRecord)
  ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу [AccountType]')
GO
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('c14044c4-0d50-4bce-af32-0639f7738026', N'Авансовый Открытие КомТех', 3, 2000860855)
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('2126ef07-0276-4440-b71c-c353516a0946', N'Авансовый', 1, NULL)
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('f35c264e-9c7f-449b-ba68-f4e71f71e97e', N'Материальный', 1, NULL)
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('a126415b-734d-4d05-bf68-f888d680c5ba', N'Текущий', 1, NULL)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--
-- Создать функцию [dbo].[F_CalculateBalanceByMaterial]
-- Функция расчёта баланса (объекта) по материалам
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateBalanceByMaterial]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateBalanceByMaterial') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateBalanceByMaterial
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox On Payee.Oid = Cashbox.Oid
                      left join AccountType CashboxAccountType on Cashbox.AccountType = CashboxAccountType.Oid
                      left join Bank On Payee.Oid = Bank.Oid
                      left join AccountType BankAccountType on Bank.AccountType = BankAccountType.Oid
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
					  LEFT JOIN dbo.Supplier SupplierPayer ON SupplierPayer.Oid = Payer.Oid
					  LEFT JOIN dbo.Supplier SupplierPayee ON SupplierPayee.Oid = Payee.Oid
                      LEFT JOIN PaymentCategory ON Payment.Category = PaymentCategory.Oid 
					  LEFT JOIN Project ON Payment.Project = Project.Oid 
					  LEFT JOIN Client ON Project.Client = Client.Oid
where 
Project.Oid = @Project
and
Payment.GCRecord is null 
and
(
	(
		(Payment.Payer = Project.Client OR
        SupplierPayer.ProfitByMaterialAsPayer = 1
		)
		and
		(
		CashboxAccountType.Name = ''Материальный'' or
		BankAccountType.Name = ''Материальный'' or
		SupplierPayee.ProfitByMaterialAsPayee = 1
		)
		and
		(PaymentCategory.ProfitByMaterial = 1		
		) 
	)
	or
	(			
			(
			PayerCashboxAccountType.Name = ''Текущий'' or
			PayerBankAccountType.Name = ''Текущий''
			)
			and
			(
			CashboxAccountType.Name = ''Материальный'' or
			BankAccountType.Name = ''Материальный''
			)
			and
			PaymentCategory.Name = ''Списание убытков''
	)
)


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox On Payer.Oid = Cashbox.Oid
                      left join AccountType CashboxAccountType on Cashbox.AccountType = CashboxAccountType.Oid
                      left join Bank On Payer.Oid = Bank.Oid
                      left join AccountType BankAccountType on Bank.AccountType = BankAccountType.Oid
					  LEFT JOIN dbo.Supplier SupplierPayer ON SupplierPayer.Oid = Payer.Oid
					  LEFT JOIN dbo.Supplier SupplierPayee ON SupplierPayee.Oid = Payee.Oid
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(
CashboxAccountType.Name = ''Материальный'' or
BankAccountType.Name = ''Материальный'' or
SupplierPayer.CostByMaterialAsPayer = 1 or
Payer.Oid in (Select Oid from Employee))
and
(PaymentCategory.CostByMaterial = 1
)
and
Project.Oid = @Project

Return(coalesce(@Profit,0) - coalesce(@Cost,0))

End'
GO

--
-- Создать таблицу [dbo].[Cashbox]
-- Наличные счета
--
PRINT (N'Создать таблицу [dbo].[Cashbox]')
GO
IF OBJECT_ID(N'dbo.Cashbox', 'U') IS NULL
CREATE TABLE dbo.Cashbox (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  AccountType uniqueidentifier NULL,
  CONSTRAINT PK_Cashbox PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iAccountType_Cashbox] для объекта типа таблица [dbo].[Cashbox]
--
PRINT (N'Создать индекс [iAccountType_Cashbox] для объекта типа таблица [dbo].[Cashbox]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iAccountType_Cashbox' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
CREATE INDEX iAccountType_Cashbox
  ON dbo.Cashbox (AccountType)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Cashbox_AccountType] для объекта типа таблица [dbo].[Cashbox]
--
PRINT (N'Создать внешний ключ [FK_Cashbox_AccountType] для объекта типа таблица [dbo].[Cashbox]')
GO
IF OBJECT_ID('dbo.FK_Cashbox_AccountType', 'F') IS NULL
  AND OBJECT_ID('dbo.Cashbox', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.AccountType', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.AccountType'))
ALTER TABLE dbo.Cashbox WITH NOCHECK
  ADD CONSTRAINT FK_Cashbox_AccountType FOREIGN KEY (AccountType) REFERENCES dbo.AccountType (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Cashbox_Oid] для объекта типа таблица [dbo].[Cashbox]
--
PRINT (N'Создать внешний ключ [FK_Cashbox_Oid] для объекта типа таблица [dbo].[Cashbox]')
GO
IF OBJECT_ID('dbo.FK_Cashbox_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Cashbox', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Cashbox WITH NOCHECK
  ADD CONSTRAINT FK_Cashbox_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать функцию [dbo].[F_CalculateRemainderTheAdvance]
-- Остаток аванса (на объекте)
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateRemainderTheAdvance]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateRemainderTheAdvance') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateRemainderTheAdvance
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(
Payment.Payer = Project.Client
or
PayerCashboxAccountType.Name = ''Текущий'' or
PayerBankAccountType.Name = ''Текущий''
)
and
(
PayeeCashboxAccountType.Name = ''Авансовый'' or
PayeeBankAccountType.Name = ''Авансовый''
)
and
(
PaymentCategory.Name = ''Аванс на работы''
)
and
Project.Oid = @Project


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
PaymentCategory.Name = ''Оплата работ''
and
(
PayerCashboxAccountType.Name = ''Авансовый'' or
PayerBankAccountType.Name = ''Авансовый''
)
and
(PayeeCashboxAccountType.Name = ''Текущий'' or
PayeeBankAccountType.Name = ''Текущий'' or
Payment.Payee = Project.Client
)
and
Project.Oid = @Project

Return(coalesce(@Profit,0) - coalesce(@Cost,0))

End

'
GO

--
-- Создать функцию [dbo].[F_CalculatePaymentParticipantBalance]
-- Функция расчёта баланса участника платежа
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculatePaymentParticipantBalance]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculatePaymentParticipantBalance') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculatePaymentParticipantBalance
(@PaymentParticipant uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int
Declare @EmployeeCost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid                      
where
Payment.GCRecord is null and 
Payee.Oid = @PaymentParticipant and
(
	(		
		dbo.PaymentCategory.NotInPaymentParticipantProfit <> 1 or NotInPaymentParticipantProfit IS NULL
	)
	or
	(		
		
		(
		PayerCashboxAccountType.Name = ''Текущий'' or
		PayerBankAccountType.Name = ''Текущий''
		)
		and
		(
		PayeeCashboxAccountType.Name = ''Материальный'' or
		PayeeBankAccountType.Name = ''Материальный''
		)
		and
		PaymentCategory.Name =  ''Списание убытков''				
	)
)


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid                      
where 
(Payment.GCRecord is null and
Payer.Oid = @PaymentParticipant)
and
(
(Payer.Oid not in (Select Oid from Employee))
or
(
Payer.Oid in (Select Oid from Employee) and
PaymentCategory.Name <>  ''Возврат долга'')
)

SELECT     @EmployeeCost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid
where 
Payment.GCRecord is null and
Payee.Oid = @PaymentParticipant and
Payee.Oid in (Select Oid from Employee) and
PaymentCategory.Name =  ''Закупка материалов'' and
PaymentCategory.Name <>  ''Возврат долга''

Return(coalesce(@Profit,0) - coalesce(@Cost,0) - coalesce(@EmployeeCost,0))

End
'
GO

--
-- Создать триггер [T_PaymentParticipant_BU] на таблицу [dbo].[PaymentParticipant]
-- Триггер, срабатывающий до внесения изменений в таблицу
--
GO
PRINT (N'Создать триггер [T_PaymentParticipant_BU] на таблицу [dbo].[PaymentParticipant]')
GO
IF OBJECT_ID(N'dbo.T_PaymentParticipant_BU', 'TR') IS NULL
EXEC sp_executesql N'CREATE OR ALTER TRIGGER T_PaymentParticipant_BU ON dbo.PaymentParticipant
INSTEAD OF UPDATE
AS
BEGIN
UPDATE [dbo].[PaymentParticipant]
   SET 
      [Balance] = dbo.F_CalculatePaymentParticipantBalance(inserted.oid)
      ,[Name] = inserted.Name
      ,[OptimisticLockField] = inserted.OptimisticLockField
      ,[GCRecord] = inserted.GCRecord
      ,[ObjectType] = inserted.ObjectType      
      ,[ActiveFrom] = inserted.ActiveFrom
      ,[InactiveFrom] = inserted.InactiveFrom
      ,[BankDetails] = inserted.BankDetails
	  ,[Balance2] = inserted.Balance2
 FROM [PaymentParticipant] join Inserted on [PaymentParticipant].Oid = Inserted.Oid
END

'
GO

--
-- Создать функцию [dbo].[F_CalculateBalanceByWork]
-- Функция расчёта баланса по работам (объекта)
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateBalanceByWork]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateBalanceByWork') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateBalanceByWork
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN                      
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
Project.Oid = @Project
and
(
	(
		(Payment.Payer = Project.Client)
		and
		(
		PayeeCashboxAccountType.Name = ''Текущий'' or
		PayeeBankAccountType.Name = ''Текущий''
		)
		and
		PaymentCategory.Name = ''Оплата работ''
	)
	or
	(
		(PayerCashboxAccountType.Name = ''Авансовый'' or
		PayerBankAccountType.Name = ''Авансовый'')
		and
		(
		PayeeCashboxAccountType.Name = ''Текущий'' or
		PayeeBankAccountType.Name = ''Текущий''
		)	
	)
)


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(PaymentCategory.Name = ''Оплата работ сдельщиков'' or
PaymentCategory.Name = ''Оплата работ зарплатников''
)
and
Project.Oid = @Project

Return(coalesce(@Profit,0) - coalesce(@Cost,0))

End
'
GO

--
-- Создать функцию [dbo].[F_CalculateProjectBalance]
-- Функция расчёта баланса объекта
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateProjectBalance]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateProjectBalance') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateProjectBalance
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Cost int

SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(PaymentCategory.Name = ''Накладные расходы'' or
PaymentCategory.Name = ''Административные расходы'' or
PaymentCategory.Name = ''Списание убытков'' or
PaymentCategory.Name = ''Бонусные вознаграждения''
)
and
Project.Oid = @Project

Return(dbo.F_CalculateBalanceByMaterial(@Project) + dbo.F_CalculateBalanceByWork(@Project) - coalesce(@Cost,0))

End
'
GO

--
-- Создать триггер [T_Project_BU] на таблицу [dbo].[Project]
-- Триггер, срабатывающий до внесения правок в объект
--
GO
PRINT (N'Создать триггер [T_Project_BU] на таблицу [dbo].[Project]')
GO
IF OBJECT_ID(N'dbo.T_Project_BU', 'TR') IS NULL
EXEC sp_executesql N'CREATE OR ALTER TRIGGER T_Project_BU ON dbo.Project
INSTEAD OF UPDATE
AS
BEGIN

UPDATE [Project]
   SET [Name] = inserted.Name
      ,[Address] = Inserted.Address
      ,[Client] = Inserted.Client
      ,[Manager] = Inserted.Manager
      ,[Foreman] = Inserted.Foreman
      ,[OptimisticLockField] = Inserted.OptimisticLockField
      ,[GCRecord] = Inserted.GCRecord
      ,[Balance] = dbo.F_CalculateProjectBalance(Project.Oid)
      ,[BalanceByMaterial] = dbo.F_CalculateBalanceByMaterial(Project.Oid)
      ,[BalanceByWork] = dbo.F_CalculateBalanceByWork(Project.Oid)
      ,[RemainderTheAdvance] = dbo.F_CalculateRemainderTheAdvance(Project.Oid)
      ,[PlaningStartDate] = Inserted.PlaningStartDate
      ,[Status] = Inserted.Status
      ,[FinishDate] = Inserted.FinishDate
      ,[Area] = Inserted.Area 
      ,[WorkPriceRate] = Inserted.WorkPriceRate
      ,[WorkersPriceRate] = Inserted.WorkersPriceRate
      ,[PlanfixWorkTask] = Inserted.PlanfixWorkTask
      ,[PlanfixChangeRequestTask] = Inserted.PlanfixChangeRequestTask
      ,[UseAnalytics] = inserted.UseAnalytics
FROM Project join Inserted on Project.Oid = Inserted.Oid
      
END
'
GO

--
-- Создать таблицу [dbo].[Payment]
-- Платежи. Кто, кому, сколько, когда, зачем (в какой категории) и в контексте какого объекта
--
PRINT (N'Создать таблицу [dbo].[Payment]')
GO
IF OBJECT_ID(N'dbo.Payment', 'U') IS NULL
CREATE TABLE dbo.Payment (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Amount int NULL,
  Category uniqueidentifier NULL,
  Project uniqueidentifier NULL,
  Justification nvarchar(100) NULL,
  Comment nvarchar(100) NULL,
  Date datetime NULL,
  Payer uniqueidentifier NULL,
  Payee uniqueidentifier NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  CreateDate datetime NULL,  
  CheckNumber nvarchar(100) NULL,  
  IsAuthorized bit NULL,
  Number nvarchar(100) NULL,  
  CONSTRAINT PK_Payment PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iCategory_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iCategory_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iCategory_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Category' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iCategory_Payment
  ON dbo.Payment (Category)
  ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iGCRecord_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iGCRecord_Payment
  ON dbo.Payment (GCRecord)
  ON [PRIMARY]
GO

--
-- Создать индекс [iPayee_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iPayee_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iPayee_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payee' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iPayee_Payment
  ON dbo.Payment (Payee)
  ON [PRIMARY]
GO

--
-- Создать индекс [iPayer_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iPayer_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iPayer_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payer' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iPayer_Payment
  ON dbo.Payment (Payer)
  ON [PRIMARY]
GO

--
-- Создать индекс [iProject_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iProject_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iProject_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Project' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iProject_Payment
  ON dbo.Payment (Project)
  ON [PRIMARY]
GO

--
-- Создать триггер [T_Payment_AI] на таблицу [dbo].[Payment]
-- Триггер, срабатывающий после вставки или изменения платежа
--
GO
PRINT (N'Создать триггер [T_Payment_AI] на таблицу [dbo].[Payment]')
GO
IF OBJECT_ID(N'dbo.T_Payment_AI', 'TR') IS NULL
EXEC sp_executesql N'CREATE OR ALTER TRIGGER T_Payment_AI
ON dbo.Payment
AFTER INSERT, UPDATE 
AS
-- Обновляем баланс у новых участников

	-- У плательщика
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payer)
	from PaymentParticipant
	join Inserted on PaymentParticipant.Oid = inserted.Payer

	-- У получателя
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payee)
	from PaymentParticipant
	join Inserted on PaymentParticipant.Oid = inserted.Payee
	
-- Обновляем баланс у старых участников

	-- У плательщика
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payer)
	from PaymentParticipant
	join deleted on PaymentParticipant.Oid = deleted.Payer

	-- У получателя
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payee)
	from PaymentParticipant
	join deleted on PaymentParticipant.Oid = deleted.Payee	
	
-- Обновляем баланс у новых оъектов	
	update Project
	set BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(inserted.Project),
	BalanceByWork = dbo.F_CalculateBalanceByWork(inserted.Project),	
	Balance = dbo.F_CalculateProjectBalance(inserted.Project)	
	from Project
	join Inserted on Project.Oid = inserted.Project
	
-- Обновляем баланс у старых оъектов	
	update Project
	set BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(deleted.Project),
	BalanceByWork = dbo.F_CalculateBalanceByWork(deleted.Project),	
	Balance = dbo.F_CalculateProjectBalance(deleted.Project)	
	from Project
	join deleted on Project.Oid = deleted.Project	
	
'
GO

--
-- Создать внешний ключ [FK_Payment_Category] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Category] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Category', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentCategory', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Category' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentCategory'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Category FOREIGN KEY (Category) REFERENCES dbo.PaymentCategory (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Payment_Payee] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Payee] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Payee', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payee' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Payee FOREIGN KEY (Payee) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Payment_Payer] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Payer] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Payer', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payer' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Payer FOREIGN KEY (Payer) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Payment_Project] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Project] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Project', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Project' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Project'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Project FOREIGN KEY (Project) REFERENCES dbo.Project (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[Bank]
-- Безналичные счета
--
PRINT (N'Создать таблицу [dbo].[Bank]')
GO
IF OBJECT_ID(N'dbo.Bank', 'U') IS NULL
CREATE TABLE dbo.Bank (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  AccountType uniqueidentifier NULL,
  CONSTRAINT PK_Bank PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iAccountType_Bank] для объекта типа таблица [dbo].[Bank]
--
PRINT (N'Создать индекс [iAccountType_Bank] для объекта типа таблица [dbo].[Bank]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iAccountType_Bank' AND object_id = OBJECT_ID(N'dbo.Bank'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Bank'))
CREATE INDEX iAccountType_Bank
  ON dbo.Bank (AccountType)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Bank_AccountType] для объекта типа таблица [dbo].[Bank]
--
PRINT (N'Создать внешний ключ [FK_Bank_AccountType] для объекта типа таблица [dbo].[Bank]')
GO
IF OBJECT_ID('dbo.FK_Bank_AccountType', 'F') IS NULL
  AND OBJECT_ID('dbo.Bank', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.AccountType', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Bank'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.AccountType'))
ALTER TABLE dbo.Bank WITH NOCHECK
  ADD CONSTRAINT FK_Bank_AccountType FOREIGN KEY (AccountType) REFERENCES dbo.AccountType (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Bank_Oid] для объекта типа таблица [dbo].[Bank]
--
PRINT (N'Создать внешний ключ [FK_Bank_Oid] для объекта типа таблица [dbo].[Bank]')
GO
IF OBJECT_ID('dbo.FK_Bank_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Bank', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Bank'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Bank WITH NOCHECK
  ADD CONSTRAINT FK_Bank_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO
SET NOEXEC OFF
GO

IF (select DB_NAME()) <> N'master' SET NOEXEC ON

--
-- Создать базу данных [PaymentData]
--
PRINT (N'Создать базу данных [PaymentData]')
GO
IF DB_ID('PaymentData') IS NULL
CREATE DATABASE PaymentData
GO

USE PaymentData
GO

IF DB_NAME() <> N'PaymentData' SET NOEXEC ON
GO

--
-- Создать таблицу [dbo].[PaymentParticipant]
-- Эта таблица содержит базовые данные всех участников платежей
--
PRINT (N'Создать таблицу [dbo].[PaymentParticipant]')
GO
IF OBJECT_ID(N'dbo.PaymentParticipant', 'U') IS NULL
CREATE TABLE dbo.PaymentParticipant (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Balance int NULL,
  Name nvarchar(100) NULL,
  OptimisticLockField int NULL, -- Здесь и в других таблицах: специальное поле для отслеживания версий. К задаче оптимизации отношения не имеет.
  GCRecord int NULL, -- Здесь и далее: флаг удаления. Если значение отличается от Null, значит запись удалена
  ObjectType int NULL, -- Тип платильщика. Допустимы следующие типы платильщиков: Безналичный счёт, наличный счёт, клиент, сотрудник, поставщик
  ActiveFrom datetime NULL,
  InactiveFrom datetime NULL,
  BankDetails nvarchar(399) NULL,
  Balance2 int NULL,
  Balance3 int NULL,
  CONSTRAINT PK_PaymentParticipant PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]
--
PRINT (N'Создать индекс [iGCRecord_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_PaymentParticipant' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
CREATE INDEX iGCRecord_PaymentParticipant
  ON dbo.PaymentParticipant (GCRecord)
  ON [PRIMARY]
GO

--
-- Создать индекс [iObjectType_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]
--
PRINT (N'Создать индекс [iObjectType_PaymentParticipant] для объекта типа таблица [dbo].[PaymentParticipant]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iObjectType_PaymentParticipant' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'ObjectType' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
CREATE INDEX iObjectType_PaymentParticipant
  ON dbo.PaymentParticipant (ObjectType)
  ON [PRIMARY]
GO

--
-- Создать таблицу [dbo].[PaymentCategory]
-- Эта таблица содержит категории платежа. В зависимости от категории, платёж участвует в том или ином балансе
--
PRINT (N'Создать таблицу [dbo].[PaymentCategory]')
GO
IF OBJECT_ID(N'dbo.PaymentCategory', 'U') IS NULL
CREATE TABLE dbo.PaymentCategory (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Name nvarchar(100) NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  ProfitByMaterial bit NULL, -- Флаг, говорящий о том, что платёж с этой категорией рассматривается как доход в балансе по материалам
  CostByMaterial bit NULL, -- Флаг, говорящий о том, что платёж с этой категорией рассматривается как расход в балансе по материалам
  NotInPaymentParticipantProfit bit NULL, -- Флаг, говорящий о том, что платёж с этой категорией не участвует в расчёте дохода участника платежа
  CONSTRAINT PK_PaymentCategory PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_PaymentCategory] для объекта типа таблица [dbo].[PaymentCategory]
--
PRINT (N'Создать индекс [iGCRecord_PaymentCategory] для объекта типа таблица [dbo].[PaymentCategory]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_PaymentCategory' AND object_id = OBJECT_ID(N'dbo.PaymentCategory'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.PaymentCategory'))
CREATE INDEX iGCRecord_PaymentCategory
  ON dbo.PaymentCategory (GCRecord)
  ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу PaymentCategory')
GO
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('f0f25486-f0e2-4c0a-99d3-068508d13eaf', N'Аванс на материалы', 4, NULL, CONVERT(bit, 'True'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('cdca2762-818e-408a-9e57-08c515c2d87e', N'Оплата работ подрядчика', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('eeff9d97-f6d1-4318-9391-0a83f7fb9b46', N'Личные расходы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('48a33b35-5606-40c3-8b34-0ad2d2036874', N'Расходы на командообразование', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('a9beeccc-6ff2-440f-a768-0f5d95f56f68', N'Компенсируемые расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'True'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('951faee9-8883-4aef-8cb2-11aac0a245e0', N'Закупка материалов', 2, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'True'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('4dc5f40c-206b-4754-9336-1431dda54072', N'Уплата комиссии', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('700ab7dd-72ae-4f01-a7e2-1dbc341ed4c2', N'Авансовые платежи', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('3498d54b-e9b1-4e48-bf1f-27d107f281f1', N'Переход года', 3, NULL, CONVERT(bit, 'True'), CONVERT(bit, 'True'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('494a13dc-f5b2-4559-b753-28c84173b0e7', N'Списание убытков', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('d831594d-d145-40b4-87b4-2a3a7b62a6cd', N'Бонусное поступление', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('b994305a-4e7d-4309-baae-2db3da972bed', N'Возврат долга', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('ba43961f-6903-4c1f-9f7c-2f9afd9c05a0', N'Оплата бонусов зарплатникам', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('f1362210-ec04-4e4d-8675-353430c3af7f', N'Накладные расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('c7554c3e-056a-4577-971d-365aadc15a05', N'Уплата процентов по кредиту', 3, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('c6132b41-dd99-49e3-808e-4436be30c485', N'Подрядное поступление', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('60219579-cc7b-44c3-a5cb-4dca47a93b9e', N'Маркетинг', 3, 1559123771, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('6d3c6db4-2e14-4c8b-b5c3-50c9c1ae2a5b', N'Аванс на работы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('06897bea-4012-442a-a92b-5327ff546f37', N'Оплата работ сдельщиков', 7, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('e33864db-6b91-4017-a13c-53ed08e4ea5f', N'Расходные подотчетные', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('3b66ff7e-6a63-409c-9e21-59c420260ba5', N'Списание долга', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('7249bf2e-4d51-4a97-b62e-632ffeedc961', N'Получение кредита', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('ac03d0b4-8060-4e8d-bef2-6b2382500dd0', N'Возврат кредита', 0, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('f601cfb6-93ed-4087-822a-6f2fed3eeb0a', N'Расходы на маркетинг', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('e0d56999-c9a7-4a1b-a995-77fc9e94aa04', N'Процентный доход', 1, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('536199bf-9119-4659-a22b-783d05d4c715', N'Прочие поступления', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('52399204-dd9b-485c-9ebc-78aa27d7e2e8', N'Оплата работ зарплатников', 7, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('0d0e2c4b-3bee-405a-a6b3-78dc4d4abb2c', N'Накладные производственные расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('8aa549ff-ee0f-445d-b539-7ca53116a737', N'Выдача в новый долг', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('08a4bad6-f7b6-40ac-ab10-8a7f24ab536b', N'Вывод прибыли учредителя', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('b747e6e7-817d-4b3c-8bd2-91481acb46a6', N'Транзитный платеж', 3, 2052795103, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('639d2087-d6b5-4fd0-aefd-a572a4256ca3', N'Оплата бонусов сдельщикам', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('a3228980-1fd3-4570-868b-b3911492664e', N'Выдача в долг', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('07ea1363-fd9d-4b15-ac3e-c98407443665', N'Оплата работ', 3, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('bc5546da-69fa-4590-8023-e49a9150dff3', N'Представительские расходы', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('cde5137c-6254-425e-9bc4-e6216658f4d5', N'Закупка инструмента', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('052d72eb-46a2-47da-8773-e6737c247f55', N'Списание материалов', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'True'), CONVERT(bit, 'False'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('6caa35ef-d394-4a9f-b08f-e6848b41e96c', N'Премия сотрудникам', 5, 1446639774, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('1ba76857-e16f-4c22-a75f-e79e5722adba', N'Административные расходы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('a16b0742-af56-4167-b085-ea642223cf2f', N'Возврат нового долга', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('9e85d735-6c53-4220-ad79-edf820cc7fed', N'Расходы на развитие', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('37425433-0989-4271-a6fd-f32af5bf9b26', N'Расчет смет', 3, NULL, CONVERT(bit, 'False'), CONVERT(bit, 'False'), CONVERT(bit, 'True'))
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('2450c83a-ce38-4748-b056-f92670410ec4', N'Бонусные вознаграждения', 3, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('69d0c922-3eea-47fb-9c22-f9c50b2846df', N'Технические переводы', 1, NULL, NULL, NULL, NULL)
INSERT PaymentCategory(Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, CostByMaterial, NotInPaymentParticipantProfit) VALUES ('3abdc23d-93e0-4727-92ad-faf29216496d', N'Кредит', 2, 1385438376, NULL, NULL, NULL)
GO

--
-- Создать таблицу [dbo].[Supplier]
-- Поставщики
--
PRINT (N'Создать таблицу [dbo].[Supplier]')
GO
CREATE TABLE dbo.Supplier (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Contact nvarchar(100) NULL,
  ProfitByMaterialAsPayer bit NULL, -- Если установлен данный влаг, то при расчёте баланса по материалам учитываются платежи с этм поставщиком в роли плательщика как доход
  ProfitByMaterialAsPayee bit NULL, -- Если установлен данный влаг, то при расчёте баланса по материалам учитываются платежи с этм поставщиком в роли получателя платежа как доход
  CostByMaterialAsPayer bit NULL, -- Если установлен данный влаг, то при расчёте баланса по материалам учитываются платежи с этм поставщиком в роли плательщика как расход
  CONSTRAINT PK_Supplier PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Supplier_Oid] для объекта типа таблица [dbo].[Supplier]
--
PRINT (N'Создать внешний ключ [FK_Supplier_Oid] для объекта типа таблица [dbo].[Supplier]')
GO
ALTER TABLE dbo.Supplier WITH NOCHECK
  ADD CONSTRAINT FK_Supplier_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO
SET NOEXEC OFF
GO

--
-- Создать таблицу [dbo].[Employee]
--
PRINT (N'Создать таблицу [dbo].[Employee]')
GO
IF OBJECT_ID(N'dbo.Employee', 'U') IS NULL
CREATE TABLE dbo.Employee (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  BusyUntil datetime NULL,
  SecondName nvarchar(100) NULL,
  Stuff int NULL,
  HourPrice int NULL,
  Patronymic nvarchar(100) NULL,
  PlanfixId int NULL,  
  Head uniqueidentifier NULL, -- руководитель
  PlanfixMoneyRequestTask nvarchar(255) NULL,
  CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iHead_Employee] для объекта типа таблица [dbo].[Employee]
--
PRINT (N'Создать индекс [iHead_Employee] для объекта типа таблица [dbo].[Employee]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iHead_Employee' AND object_id = OBJECT_ID(N'dbo.Employee'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Head' AND object_id = OBJECT_ID(N'dbo.Employee'))
CREATE INDEX iHead_Employee
  ON dbo.Employee (Head)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Employee_Head] для объекта типа таблица [dbo].[Employee]
--
PRINT (N'Создать внешний ключ [FK_Employee_Head] для объекта типа таблица [dbo].[Employee]')
GO
IF OBJECT_ID('dbo.FK_Employee_Head', 'F') IS NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Head' AND object_id = OBJECT_ID(N'dbo.Employee'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
ALTER TABLE dbo.Employee WITH NOCHECK
  ADD CONSTRAINT FK_Employee_Head FOREIGN KEY (Head) REFERENCES dbo.Employee (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Employee_Oid] для объекта типа таблица [dbo].[Employee]
--
PRINT (N'Создать внешний ключ [FK_Employee_Oid] для объекта типа таблица [dbo].[Employee]')
GO
IF OBJECT_ID('dbo.FK_Employee_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Employee WITH NOCHECK
  ADD CONSTRAINT FK_Employee_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[Project]
-- Таблица содержит сведения об объектах работ (объектах недвижимости)
--
PRINT (N'Создать таблицу [dbo].[Project]')
GO
IF OBJECT_ID(N'dbo.Project', 'U') IS NULL
CREATE TABLE dbo.Project (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Name nvarchar(100) NULL,
  Address nvarchar(100) NULL,
  Client uniqueidentifier NULL,
  Manager uniqueidentifier NULL,
  Foreman uniqueidentifier NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  Balance int NULL, -- Общий баланс - сумма всех балансов
  BalanceByMaterial int NULL, -- Баланс по материалам
  BalanceByWork int NULL, -- Баланс по работам
  PlaningStartDate datetime NULL,
  Status int NULL,
  FinishDate datetime NULL,
  Area int NULL,
  WorkPriceRate float NULL,
  WorkersPriceRate float NULL,
  RemainderTheAdvance int NULL,
  PlanfixWorkTask nvarchar(512) NULL,
  PlanfixChangeRequestTask nvarchar(512) NULL,
  UseAnalytics bit NULL,
  CONSTRAINT PK_Project PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iClient_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iClient_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iClient_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Client' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iClient_Project
  ON dbo.Project (Client)
  ON [PRIMARY]
GO

--
-- Создать индекс [iForeman_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iForeman_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iForeman_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Foreman' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iForeman_Project
  ON dbo.Project (Foreman)
  ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iGCRecord_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iGCRecord_Project
  ON dbo.Project (GCRecord)
  ON [PRIMARY]
GO

--
-- Создать индекс [iManager_Project] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать индекс [iManager_Project] для объекта типа таблица [dbo].[Project]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iManager_Project' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Manager' AND object_id = OBJECT_ID(N'dbo.Project'))
CREATE INDEX iManager_Project
  ON dbo.Project (Manager)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Project_Foreman] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать внешний ключ [FK_Project_Foreman] для объекта типа таблица [dbo].[Project]')
GO
IF OBJECT_ID('dbo.FK_Project_Foreman', 'F') IS NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Foreman' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
ALTER TABLE dbo.Project WITH NOCHECK
  ADD CONSTRAINT FK_Project_Foreman FOREIGN KEY (Foreman) REFERENCES dbo.Employee (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Project_Manager] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать внешний ключ [FK_Project_Manager] для объекта типа таблица [dbo].[Project]')
GO
IF OBJECT_ID('dbo.FK_Project_Manager', 'F') IS NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Manager' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Employee'))
ALTER TABLE dbo.Project WITH NOCHECK
  ADD CONSTRAINT FK_Project_Manager FOREIGN KEY (Manager) REFERENCES dbo.Employee (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[Client]
--
PRINT (N'Создать таблицу [dbo].[Client]')
GO
IF OBJECT_ID(N'dbo.Client', 'U') IS NULL
CREATE TABLE dbo.Client (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  FirstName nvarchar(100) NULL,
  SecondName nvarchar(100) NULL,
  Phone nvarchar(100) NULL,  
  CONSTRAINT PK_Client PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Client_Oid] для объекта типа таблица [dbo].[Client]
--
PRINT (N'Создать внешний ключ [FK_Client_Oid] для объекта типа таблица [dbo].[Client]')
GO
IF OBJECT_ID('dbo.FK_Client_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Client', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Client'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Client WITH NOCHECK
  ADD CONSTRAINT FK_Client_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Project_Client] для объекта типа таблица [dbo].[Project]
--
PRINT (N'Создать внешний ключ [FK_Project_Client] для объекта типа таблица [dbo].[Project]')
GO
IF OBJECT_ID('dbo.FK_Project_Client', 'F') IS NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Client', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Client' AND object_id = OBJECT_ID(N'dbo.Project'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Client'))
ALTER TABLE dbo.Project WITH NOCHECK
  ADD CONSTRAINT FK_Project_Client FOREIGN KEY (Client) REFERENCES dbo.Client (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[AccountType]
-- Тип счёта
--
PRINT (N'Создать таблицу [dbo].[AccountType]')
GO
IF OBJECT_ID(N'dbo.AccountType', 'U') IS NULL
CREATE TABLE dbo.AccountType (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Name nvarchar(100) NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  CONSTRAINT PK_AccountType PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_AccountType] для объекта типа таблица [dbo].[AccountType]
--
PRINT (N'Создать индекс [iGCRecord_AccountType] для объекта типа таблица [dbo].[AccountType]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_AccountType' AND object_id = OBJECT_ID(N'dbo.AccountType'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.AccountType'))
CREATE INDEX iGCRecord_AccountType
  ON dbo.AccountType (GCRecord)
  ON [PRIMARY]
GO

PRINT (N'Вставка данных в таблицу [AccountType]')
GO
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('c14044c4-0d50-4bce-af32-0639f7738026', N'Авансовый Открытие КомТех', 3, 2000860855)
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('2126ef07-0276-4440-b71c-c353516a0946', N'Авансовый', 1, NULL)
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('f35c264e-9c7f-449b-ba68-f4e71f71e97e', N'Материальный', 1, NULL)
INSERT AccountType(Oid, Name, OptimisticLockField, GCRecord) VALUES ('a126415b-734d-4d05-bf68-f888d680c5ba', N'Текущий', 1, NULL)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--
-- Создать функцию [dbo].[F_CalculateBalanceByMaterial]
-- Функция расчёта баланса (объекта) по материалам
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateBalanceByMaterial]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateBalanceByMaterial') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateBalanceByMaterial
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox On Payee.Oid = Cashbox.Oid
                      left join AccountType CashboxAccountType on Cashbox.AccountType = CashboxAccountType.Oid
                      left join Bank On Payee.Oid = Bank.Oid
                      left join AccountType BankAccountType on Bank.AccountType = BankAccountType.Oid
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
					  LEFT JOIN dbo.Supplier SupplierPayer ON SupplierPayer.Oid = Payer.Oid
					  LEFT JOIN dbo.Supplier SupplierPayee ON SupplierPayee.Oid = Payee.Oid
                      LEFT JOIN PaymentCategory ON Payment.Category = PaymentCategory.Oid 
					  LEFT JOIN Project ON Payment.Project = Project.Oid 
					  LEFT JOIN Client ON Project.Client = Client.Oid
where 
Project.Oid = @Project
and
Payment.GCRecord is null 
and
(
	(
		(Payment.Payer = Project.Client OR
        SupplierPayer.ProfitByMaterialAsPayer = 1
		)
		and
		(
		CashboxAccountType.Name = ''Материальный'' or
		BankAccountType.Name = ''Материальный'' or
		SupplierPayee.ProfitByMaterialAsPayee = 1
		)
		and
		(PaymentCategory.ProfitByMaterial = 1		
		) 
	)
	or
	(			
			(
			PayerCashboxAccountType.Name = ''Текущий'' or
			PayerBankAccountType.Name = ''Текущий''
			)
			and
			(
			CashboxAccountType.Name = ''Материальный'' or
			BankAccountType.Name = ''Материальный''
			)
			and
			PaymentCategory.Name = ''Списание убытков''
	)
)


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox On Payer.Oid = Cashbox.Oid
                      left join AccountType CashboxAccountType on Cashbox.AccountType = CashboxAccountType.Oid
                      left join Bank On Payer.Oid = Bank.Oid
                      left join AccountType BankAccountType on Bank.AccountType = BankAccountType.Oid
					  LEFT JOIN dbo.Supplier SupplierPayer ON SupplierPayer.Oid = Payer.Oid
					  LEFT JOIN dbo.Supplier SupplierPayee ON SupplierPayee.Oid = Payee.Oid
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(
CashboxAccountType.Name = ''Материальный'' or
BankAccountType.Name = ''Материальный'' or
SupplierPayer.CostByMaterialAsPayer = 1 or
Payer.Oid in (Select Oid from Employee))
and
(PaymentCategory.CostByMaterial = 1
)
and
Project.Oid = @Project

Return(coalesce(@Profit,0) - coalesce(@Cost,0))

End'
GO

--
-- Создать таблицу [dbo].[Cashbox]
-- Наличные счета
--
PRINT (N'Создать таблицу [dbo].[Cashbox]')
GO
IF OBJECT_ID(N'dbo.Cashbox', 'U') IS NULL
CREATE TABLE dbo.Cashbox (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  AccountType uniqueidentifier NULL,
  CONSTRAINT PK_Cashbox PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iAccountType_Cashbox] для объекта типа таблица [dbo].[Cashbox]
--
PRINT (N'Создать индекс [iAccountType_Cashbox] для объекта типа таблица [dbo].[Cashbox]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iAccountType_Cashbox' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
CREATE INDEX iAccountType_Cashbox
  ON dbo.Cashbox (AccountType)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Cashbox_AccountType] для объекта типа таблица [dbo].[Cashbox]
--
PRINT (N'Создать внешний ключ [FK_Cashbox_AccountType] для объекта типа таблица [dbo].[Cashbox]')
GO
IF OBJECT_ID('dbo.FK_Cashbox_AccountType', 'F') IS NULL
  AND OBJECT_ID('dbo.Cashbox', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.AccountType', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.AccountType'))
ALTER TABLE dbo.Cashbox WITH NOCHECK
  ADD CONSTRAINT FK_Cashbox_AccountType FOREIGN KEY (AccountType) REFERENCES dbo.AccountType (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Cashbox_Oid] для объекта типа таблица [dbo].[Cashbox]
--
PRINT (N'Создать внешний ключ [FK_Cashbox_Oid] для объекта типа таблица [dbo].[Cashbox]')
GO
IF OBJECT_ID('dbo.FK_Cashbox_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Cashbox', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Cashbox'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Cashbox WITH NOCHECK
  ADD CONSTRAINT FK_Cashbox_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать функцию [dbo].[F_CalculateRemainderTheAdvance]
-- Остаток аванса (на объекте)
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateRemainderTheAdvance]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateRemainderTheAdvance') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateRemainderTheAdvance
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(
Payment.Payer = Project.Client
or
PayerCashboxAccountType.Name = ''Текущий'' or
PayerBankAccountType.Name = ''Текущий''
)
and
(
PayeeCashboxAccountType.Name = ''Авансовый'' or
PayeeBankAccountType.Name = ''Авансовый''
)
and
(
PaymentCategory.Name = ''Аванс на работы''
)
and
Project.Oid = @Project


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
PaymentCategory.Name = ''Оплата работ''
and
(
PayerCashboxAccountType.Name = ''Авансовый'' or
PayerBankAccountType.Name = ''Авансовый''
)
and
(PayeeCashboxAccountType.Name = ''Текущий'' or
PayeeBankAccountType.Name = ''Текущий'' or
Payment.Payee = Project.Client
)
and
Project.Oid = @Project

Return(coalesce(@Profit,0) - coalesce(@Cost,0))

End

'
GO

--
-- Создать функцию [dbo].[F_CalculatePaymentParticipantBalance]
-- Функция расчёта баланса участника платежа
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculatePaymentParticipantBalance]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculatePaymentParticipantBalance') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculatePaymentParticipantBalance
(@PaymentParticipant uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int
Declare @EmployeeCost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid                      
where
Payment.GCRecord is null and 
Payee.Oid = @PaymentParticipant and
(
	(		
		dbo.PaymentCategory.NotInPaymentParticipantProfit <> 1 or NotInPaymentParticipantProfit IS NULL
	)
	or
	(		
		
		(
		PayerCashboxAccountType.Name = ''Текущий'' or
		PayerBankAccountType.Name = ''Текущий''
		)
		and
		(
		PayeeCashboxAccountType.Name = ''Материальный'' or
		PayeeBankAccountType.Name = ''Материальный''
		)
		and
		PaymentCategory.Name =  ''Списание убытков''				
	)
)


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid                      
where 
(Payment.GCRecord is null and
Payer.Oid = @PaymentParticipant)
and
(
(Payer.Oid not in (Select Oid from Employee))
or
(
Payer.Oid in (Select Oid from Employee) and
PaymentCategory.Name <>  ''Возврат долга'')
)

SELECT     @EmployeeCost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid
where 
Payment.GCRecord is null and
Payee.Oid = @PaymentParticipant and
Payee.Oid in (Select Oid from Employee) and
PaymentCategory.Name =  ''Закупка материалов'' and
PaymentCategory.Name <>  ''Возврат долга''

Return(coalesce(@Profit,0) - coalesce(@Cost,0) - coalesce(@EmployeeCost,0))

End
'
GO

--
-- Создать триггер [T_PaymentParticipant_BU] на таблицу [dbo].[PaymentParticipant]
-- Триггер, срабатывающий до внесения изменений в таблицу
--
GO
PRINT (N'Создать триггер [T_PaymentParticipant_BU] на таблицу [dbo].[PaymentParticipant]')
GO
IF OBJECT_ID(N'dbo.T_PaymentParticipant_BU', 'TR') IS NULL
EXEC sp_executesql N'CREATE OR ALTER TRIGGER T_PaymentParticipant_BU ON dbo.PaymentParticipant
INSTEAD OF UPDATE
AS
BEGIN
UPDATE [dbo].[PaymentParticipant]
   SET 
      [Balance] = dbo.F_CalculatePaymentParticipantBalance(inserted.oid)
      ,[Name] = inserted.Name
      ,[OptimisticLockField] = inserted.OptimisticLockField
      ,[GCRecord] = inserted.GCRecord
      ,[ObjectType] = inserted.ObjectType      
      ,[ActiveFrom] = inserted.ActiveFrom
      ,[InactiveFrom] = inserted.InactiveFrom
      ,[BankDetails] = inserted.BankDetails
	  ,[Balance2] = inserted.Balance2
 FROM [PaymentParticipant] join Inserted on [PaymentParticipant].Oid = Inserted.Oid
END

'
GO

--
-- Создать функцию [dbo].[F_CalculateBalanceByWork]
-- Функция расчёта баланса по работам (объекта)
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateBalanceByWork]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateBalanceByWork') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateBalanceByWork
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Profit int
Declare @Cost int

SELECT   @Profit = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid 
                      left join Cashbox PayeeCashbox On Payee.Oid = PayeeCashbox.Oid
                      left join AccountType PayeeCashboxAccountType on PayeeCashbox.AccountType = PayeeCashboxAccountType.Oid
                      left join Bank PayeeBank On Payee.Oid = PayeeBank.Oid
                      left join AccountType PayeeBankAccountType on PayeeBank.AccountType = PayeeBankAccountType.Oid
                      
                      left join Cashbox PayerCashbox On Payer.Oid = PayerCashbox.Oid
                      left join AccountType PayerCashboxAccountType on PayerCashbox.AccountType = PayerCashboxAccountType.Oid
                      left join Bank PayerBank On Payer.Oid = PayerBank.Oid
                      left join AccountType PayerBankAccountType on PayerBank.AccountType = PayerBankAccountType.Oid
                      
                      INNER JOIN                      
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
Project.Oid = @Project
and
(
	(
		(Payment.Payer = Project.Client)
		and
		(
		PayeeCashboxAccountType.Name = ''Текущий'' or
		PayeeBankAccountType.Name = ''Текущий''
		)
		and
		PaymentCategory.Name = ''Оплата работ''
	)
	or
	(
		(PayerCashboxAccountType.Name = ''Авансовый'' or
		PayerBankAccountType.Name = ''Авансовый'')
		and
		(
		PayeeCashboxAccountType.Name = ''Текущий'' or
		PayeeBankAccountType.Name = ''Текущий''
		)	
	)
)


SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(PaymentCategory.Name = ''Оплата работ сдельщиков'' or
PaymentCategory.Name = ''Оплата работ зарплатников''
)
and
Project.Oid = @Project

Return(coalesce(@Profit,0) - coalesce(@Cost,0))

End
'
GO

--
-- Создать функцию [dbo].[F_CalculateProjectBalance]
-- Функция расчёта баланса объекта
--
GO
PRINT (N'Создать функцию [dbo].[F_CalculateProjectBalance]')
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.F_CalculateProjectBalance') AND type IN ('IF', 'FN', 'TF'))
EXEC sp_executesql N'CREATE OR ALTER Function dbo.F_CalculateProjectBalance
(@Project uniqueidentifier)
Returns int
as
Begin

Declare @Cost int

SELECT     @Cost = SUM(Payment.Amount)
FROM         Payment INNER JOIN
                      PaymentParticipant Payer ON Payment.Payer = Payer.Oid INNER JOIN
                      PaymentParticipant Payee ON Payment.Payee = Payee.Oid INNER JOIN
                      PaymentCategory ON Payment.Category = PaymentCategory.Oid INNER JOIN
                      Project ON Payment.Project = Project.Oid INNER JOIN
                      Client ON Project.Client = Client.Oid
where 
Payment.GCRecord is null and
(PaymentCategory.Name = ''Накладные расходы'' or
PaymentCategory.Name = ''Административные расходы'' or
PaymentCategory.Name = ''Списание убытков'' or
PaymentCategory.Name = ''Бонусные вознаграждения''
)
and
Project.Oid = @Project

Return(dbo.F_CalculateBalanceByMaterial(@Project) + dbo.F_CalculateBalanceByWork(@Project) - coalesce(@Cost,0))

End
'
GO

--
-- Создать триггер [T_Project_BU] на таблицу [dbo].[Project]
-- Триггер, срабатывающий до внесения правок в объект
--
GO
PRINT (N'Создать триггер [T_Project_BU] на таблицу [dbo].[Project]')
GO
IF OBJECT_ID(N'dbo.T_Project_BU', 'TR') IS NULL
EXEC sp_executesql N'CREATE OR ALTER TRIGGER T_Project_BU ON dbo.Project
INSTEAD OF UPDATE
AS
BEGIN

UPDATE [Project]
   SET [Name] = inserted.Name
      ,[Address] = Inserted.Address
      ,[Client] = Inserted.Client
      ,[Manager] = Inserted.Manager
      ,[Foreman] = Inserted.Foreman
      ,[OptimisticLockField] = Inserted.OptimisticLockField
      ,[GCRecord] = Inserted.GCRecord
      ,[Balance] = dbo.F_CalculateProjectBalance(Project.Oid)
      ,[BalanceByMaterial] = dbo.F_CalculateBalanceByMaterial(Project.Oid)
      ,[BalanceByWork] = dbo.F_CalculateBalanceByWork(Project.Oid)
      ,[RemainderTheAdvance] = dbo.F_CalculateRemainderTheAdvance(Project.Oid)
      ,[PlaningStartDate] = Inserted.PlaningStartDate
      ,[Status] = Inserted.Status
      ,[FinishDate] = Inserted.FinishDate
      ,[Area] = Inserted.Area 
      ,[WorkPriceRate] = Inserted.WorkPriceRate
      ,[WorkersPriceRate] = Inserted.WorkersPriceRate
      ,[PlanfixWorkTask] = Inserted.PlanfixWorkTask
      ,[PlanfixChangeRequestTask] = Inserted.PlanfixChangeRequestTask
      ,[UseAnalytics] = inserted.UseAnalytics
FROM Project join Inserted on Project.Oid = Inserted.Oid
      
END
'
GO

--
-- Создать таблицу [dbo].[Payment]
-- Платежи. Кто, кому, сколько, когда, зачем (в какой категории) и в контексте какого объекта
--
PRINT (N'Создать таблицу [dbo].[Payment]')
GO
IF OBJECT_ID(N'dbo.Payment', 'U') IS NULL
CREATE TABLE dbo.Payment (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  Amount int NULL,
  Category uniqueidentifier NULL,
  Project uniqueidentifier NULL,
  Justification nvarchar(100) NULL,
  Comment nvarchar(100) NULL,
  Date datetime NULL,
  Payer uniqueidentifier NULL,
  Payee uniqueidentifier NULL,
  OptimisticLockField int NULL,
  GCRecord int NULL,
  CreateDate datetime NULL,  
  CheckNumber nvarchar(100) NULL,  
  IsAuthorized bit NULL,
  Number nvarchar(100) NULL,  
  CONSTRAINT PK_Payment PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iCategory_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iCategory_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iCategory_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Category' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iCategory_Payment
  ON dbo.Payment (Category)
  ON [PRIMARY]
GO

--
-- Создать индекс [iGCRecord_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iGCRecord_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iGCRecord_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'GCRecord' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iGCRecord_Payment
  ON dbo.Payment (GCRecord)
  ON [PRIMARY]
GO

--
-- Создать индекс [iPayee_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iPayee_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iPayee_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payee' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iPayee_Payment
  ON dbo.Payment (Payee)
  ON [PRIMARY]
GO

--
-- Создать индекс [iPayer_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iPayer_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iPayer_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payer' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iPayer_Payment
  ON dbo.Payment (Payer)
  ON [PRIMARY]
GO

--
-- Создать индекс [iProject_Payment] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать индекс [iProject_Payment] для объекта типа таблица [dbo].[Payment]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iProject_Payment' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Project' AND object_id = OBJECT_ID(N'dbo.Payment'))
CREATE INDEX iProject_Payment
  ON dbo.Payment (Project)
  ON [PRIMARY]
GO

--
-- Создать триггер [T_Payment_AI] на таблицу [dbo].[Payment]
-- Триггер, срабатывающий после вставки или изменения платежа
--
GO
PRINT (N'Создать триггер [T_Payment_AI] на таблицу [dbo].[Payment]')
GO
IF OBJECT_ID(N'dbo.T_Payment_AI', 'TR') IS NULL
EXEC sp_executesql N'CREATE OR ALTER TRIGGER T_Payment_AI
ON dbo.Payment
AFTER INSERT, UPDATE 
AS
-- Обновляем баланс у новых участников

	-- У плательщика
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payer)
	from PaymentParticipant
	join Inserted on PaymentParticipant.Oid = inserted.Payer

	-- У получателя
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payee)
	from PaymentParticipant
	join Inserted on PaymentParticipant.Oid = inserted.Payee
	
-- Обновляем баланс у старых участников

	-- У плательщика
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payer)
	from PaymentParticipant
	join deleted on PaymentParticipant.Oid = deleted.Payer

	-- У получателя
	update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payee)
	from PaymentParticipant
	join deleted on PaymentParticipant.Oid = deleted.Payee	
	
-- Обновляем баланс у новых оъектов	
	update Project
	set BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(inserted.Project),
	BalanceByWork = dbo.F_CalculateBalanceByWork(inserted.Project),	
	Balance = dbo.F_CalculateProjectBalance(inserted.Project)	
	from Project
	join Inserted on Project.Oid = inserted.Project
	
-- Обновляем баланс у старых оъектов	
	update Project
	set BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(deleted.Project),
	BalanceByWork = dbo.F_CalculateBalanceByWork(deleted.Project),	
	Balance = dbo.F_CalculateProjectBalance(deleted.Project)	
	from Project
	join deleted on Project.Oid = deleted.Project	
	
'
GO

--
-- Создать внешний ключ [FK_Payment_Category] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Category] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Category', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentCategory', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Category' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentCategory'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Category FOREIGN KEY (Category) REFERENCES dbo.PaymentCategory (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Payment_Payee] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Payee] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Payee', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payee' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Payee FOREIGN KEY (Payee) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Payment_Payer] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Payer] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Payer', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Payer' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Payer FOREIGN KEY (Payer) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Payment_Project] для объекта типа таблица [dbo].[Payment]
--
PRINT (N'Создать внешний ключ [FK_Payment_Project] для объекта типа таблица [dbo].[Payment]')
GO
IF OBJECT_ID('dbo.FK_Payment_Project', 'F') IS NULL
  AND OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Project', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Project' AND object_id = OBJECT_ID(N'dbo.Payment'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Project'))
ALTER TABLE dbo.Payment WITH NOCHECK
  ADD CONSTRAINT FK_Payment_Project FOREIGN KEY (Project) REFERENCES dbo.Project (Oid) NOT FOR REPLICATION
GO

--
-- Создать таблицу [dbo].[Bank]
-- Безналичные счета
--
PRINT (N'Создать таблицу [dbo].[Bank]')
GO
IF OBJECT_ID(N'dbo.Bank', 'U') IS NULL
CREATE TABLE dbo.Bank (
  Oid uniqueidentifier NOT NULL ROWGUIDCOL,
  AccountType uniqueidentifier NULL,
  CONSTRAINT PK_Bank PRIMARY KEY CLUSTERED (Oid)
)
ON [PRIMARY]
GO

--
-- Создать индекс [iAccountType_Bank] для объекта типа таблица [dbo].[Bank]
--
PRINT (N'Создать индекс [iAccountType_Bank] для объекта типа таблица [dbo].[Bank]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'iAccountType_Bank' AND object_id = OBJECT_ID(N'dbo.Bank'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Bank'))
CREATE INDEX iAccountType_Bank
  ON dbo.Bank (AccountType)
  ON [PRIMARY]
GO

--
-- Создать внешний ключ [FK_Bank_AccountType] для объекта типа таблица [dbo].[Bank]
--
PRINT (N'Создать внешний ключ [FK_Bank_AccountType] для объекта типа таблица [dbo].[Bank]')
GO
IF OBJECT_ID('dbo.FK_Bank_AccountType', 'F') IS NULL
  AND OBJECT_ID('dbo.Bank', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.AccountType', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'AccountType' AND object_id = OBJECT_ID(N'dbo.Bank'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.AccountType'))
ALTER TABLE dbo.Bank WITH NOCHECK
  ADD CONSTRAINT FK_Bank_AccountType FOREIGN KEY (AccountType) REFERENCES dbo.AccountType (Oid) NOT FOR REPLICATION
GO

--
-- Создать внешний ключ [FK_Bank_Oid] для объекта типа таблица [dbo].[Bank]
--
PRINT (N'Создать внешний ключ [FK_Bank_Oid] для объекта типа таблица [dbo].[Bank]')
GO
IF OBJECT_ID('dbo.FK_Bank_Oid', 'F') IS NULL
  AND OBJECT_ID('dbo.Bank', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PaymentParticipant', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.Bank'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Oid' AND object_id = OBJECT_ID(N'dbo.PaymentParticipant'))
ALTER TABLE dbo.Bank WITH NOCHECK
  ADD CONSTRAINT FK_Bank_Oid FOREIGN KEY (Oid) REFERENCES dbo.PaymentParticipant (Oid) NOT FOR REPLICATION
GO
SET NOEXEC OFF
GO