DECLARE @RowCount INT
DECLARE @id uniqueidentifier 


SET @RowCount = 0

WHILE @RowCount < 10
BEGIN
	SET @id = NEWID()

	IF NOT EXISTS (SELECT * FROM Cashbox WHERE Oid=@id)
	BEGIN  
	INSERT Cashbox (Oid, AccountType) VALUES (@id, (SELECT TOP (1) Oid FROM AccountType))
	END

	SET @RowCount = @RowCount + 1
END