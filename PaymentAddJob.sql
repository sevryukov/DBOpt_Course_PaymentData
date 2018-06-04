DECLARE @rows INT
SET @rows = 100
IF ((SELECT COUNT(*) FROM PaymentDataTemp.dbo.Payment) > 1000)
	SET @rows = 400
IF ((SELECT COUNT(*) FROM PaymentDataTemp.dbo.Payment) > @rows + 100)
	BEGIN TRY 
		BEGIN TRANSACTION PaymentTransfer
		INSERT INTO PaymentData.dbo.Payment SELECT TOP(@rows) NEWID(), Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number FROM PaymentDataTemp.dbo.Payment;
		DELETE TOP(@rows) FROM PaymentDataTemp.dbo.Payment;
		COMMIT TRANSACTION PaymentTransfer
	END TRY 
	BEGIN CATCH 
		ROLLBACK TRANSACTION PaymentTransfer
	END CATCH