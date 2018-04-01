DECLARE @RowCount INT
DECLARE @myid uniqueidentifier 
DECLARE @id uniqueidentifier 
DECLARE @name VARCHAR(10)

SET @RowCount = 0

WHILE @RowCount < 10
BEGIN
	SET @id = NEWID()
	SET @name = (SELECT SUBSTRING(CONVERT(varchar(40), NEWID()),0,9))

	IF NOT EXISTS (SELECT * FROM PaymentParticipant WHERE Oid=@myid)
	BEGIN  
	--INSERT INTO Cashbox (Oid, AccountType) VALUES (@myid, (SELECT TOP (1) Oid FROM AccountType))
	INSERT PaymentParticipant(Oid,Balance,Name,OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3) VALUES 
	( @id,1000, @name,1, NULL, NULL, NULL, NULL, NULL, 1, 1)
	END

	SET @RowCount = @RowCount + 1
END