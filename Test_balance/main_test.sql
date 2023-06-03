USE PaymentData
GO

BEGIN TRAN tr
	DECLARE @bank_id UNIQUEIDENTIFIER
			, @supplier_id UNIQUEIDENTIFIER
			, @client_id UNIQUEIDENTIFIER
			, @cashbox_id UNIQUEIDENTIFIER
			, @category_id UNIQUEIDENTIFIER
			, @project_id UNIQUEIDENTIFIER

	SELECT TOP 1 @bank_id = Bank.Oid
	FROM Bank 
	INNER JOIN PaymentParticipant ON Bank.Oid = PaymentParticipant.Oid
	WHERE Balance > 4000
	ORDER BY NEWID()

	SELECT TOP 1 @supplier_id = Supplier.Oid
	FROM Supplier 
	INNER JOIN PaymentParticipant ON Supplier.Oid = PaymentParticipant.Oid
	ORDER BY NEWID()

	SELECT TOP 1 @client_id = Client.Oid
	FROM Client
	INNER JOIN PaymentParticipant ON Client.Oid = PaymentParticipant.Oid
	ORDER BY NEWID()

	SELECT TOP 1 @cashbox_id = Cashbox.Oid
	FROM Cashbox 
	INNER JOIN PaymentParticipant ON Cashbox.Oid = PaymentParticipant.Oid
	ORDER BY NEWID()

	SELECT @project_id = Oid
	FROM Project
	WHERE Client = @client_id

	PRINT N'Selected bank: ' + CONVERT(VARCHAR(36), @bank_id)
	PRINT N'Selected supplier: ' + CONVERT(VARCHAR(36), @supplier_id)
	PRINT N'Selected client: ' + CONVERT(VARCHAR(36), @client_id)
	PRINT N'Selected cashbox: ' + CONVERT(VARCHAR(36), @cashbox_id)
	PRINT N'Selected project: ' + CONVERT(VARCHAR(36), @project_id)


	DECLARE @bank_balance_old INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_id)
			, @client_balance_old INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_id)
			, @cashbox_balance_old INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_id)
			, @supplier_balance_old INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_id)

	PRINT N'Bank balance itnitial value:'
	PRINT @bank_balance_old
	PRINT N'Cashbox balance initital value:'
	PRINT @cashbox_balance_old
	PRINT N'Client balance initial value:'
	PRINT @client_balance_old
	PRINT N'Supplier balance initial value:'
	PRINT @supplier_balance_old

	EXEC dbo.check_balances @bank_id, @cashbox_id, @client_id, @supplier_id,  
							@bank_balance_old, @cashbox_balance_old, 
							@client_balance_old, @supplier_balance_old


	SELECT @category_id = dbo.get_category(N'Аванс на материалы')

	INSERT Payment(
	Oid, Amount, Category, Project, Justification,
	Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
	CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES( 
	NEWID(), 400000, @category_id, @project_id, NULL, 
	N'Перевели денег поставщику для будущих закупок', NULL, @bank_id, @supplier_id, NULL, NULL, 
	NULL, NULL, NULL, NULL)

	EXEC dbo.check_balances @bank_id, @cashbox_id, @client_id, @supplier_id,  
							@bank_balance_old, @cashbox_balance_old, 
							@client_balance_old, @supplier_balance_old



	SELECT @category_id = dbo.get_category(N'Списание материалов')

	INSERT Payment(
	Oid, Amount, Category, Project, Justification,
	Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
	CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES( 
	NEWID(), 100000, @category_id, @project_id, NULL, 
	N'Для клиента приобрели материал. Поставщик нам должен меньше, а клиент должен за материалы', NULL, @supplier_id, @client_id, NULL, NULL, 
	NULL, NULL, NULL, NULL)

	EXEC dbo.check_balances @bank_id, @cashbox_id, @client_id, @supplier_id,  
							@bank_balance_old, @cashbox_balance_old, 
							@client_balance_old, @supplier_balance_old


	SELECT @category_id = dbo.get_category(N'Списание материалов')

	INSERT Payment(
	Oid, Amount, Category, Project, Justification,
	Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
	CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES( 
	NEWID(), 150000, @category_id, @project_id, NULL, 
	N'Клиент передал наличные для закупки материалов', NULL, @client_id, @cashbox_id, NULL, NULL, 
	NULL, NULL, NULL, NULL)

	EXEC dbo.check_balances @bank_id, @cashbox_id, @client_id, @supplier_id,  
							@bank_balance_old, @cashbox_balance_old, 
							@client_balance_old, @supplier_balance_old


	SELECT @category_id = dbo.get_category(N'Возврат кредита')

	INSERT Payment(
	Oid, Amount, Category, Project, Justification,
	Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
	CreateDate, CheckNumber, IsAuthorized, Number) 
	VALUES( 
	NEWID(), 100000, @category_id, @project_id, NULL, 
	N'Частично гасим кредит', NULL, @cashbox_id, @bank_id, NULL, NULL, 
	NULL, NULL, NULL, NULL)

	EXEC dbo.check_balances @bank_id, @cashbox_id, @client_id, @supplier_id,  
							@bank_balance_old, @cashbox_balance_old, 
							@client_balance_old, @supplier_balance_old

ROLLBACK TRAN tr