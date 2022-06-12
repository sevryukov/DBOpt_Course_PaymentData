--- Simple Balance Calculation Test

USE [PaymentData]
GO

 DECLARE @BankId uniqueidentifier;
 DECLARE @SupplierId uniqueidentifier;
 DECLARE @ClientId uniqueidentifier;
 DECLARE @CashboxId uniqueidentifier;
 DECLARE @CategoryId uniqueidentifier;

 SELECT TOP 1 @BankId = Bank.Oid
 FROM Bank 
	INNER JOIN PaymentParticipant ON Bank.Oid = PaymentParticipant.Oid
 WHERE Balance > 400000
 ORDER BY NEWID();

 SELECT TOP 1 @SupplierId = Supplier.Oid
 FROM Supplier 
	INNER JOIN PaymentParticipant ON Supplier.Oid = PaymentParticipant.Oid
 ORDER BY NEWID();

 SELECT TOP 1 @ClientId = Client.Oid
 FROM Client
	INNER JOIN PaymentParticipant ON Client.Oid = PaymentParticipant.Oid
 ORDER BY NEWID();

 SELECT TOP 1 @CashboxId = Bank.Oid
 FROM Bank 
	INNER JOIN PaymentParticipant ON Bank.Oid = PaymentParticipant.Oid
 ORDER BY NEWID();


 PRINT N'Выбран банк: ' + CONVERT(varchar(36), @BankId)
 PRINT N'Выбран поставщик: ' + CONVERT(varchar(36), @SupplierId)
 PRINT N'Выбран клиент: ' + CONVERT(varchar(36), @ClientId)
 PRINT N'Выбрана касса: ' + CONVERT(varchar(36), @CashBoxId)

