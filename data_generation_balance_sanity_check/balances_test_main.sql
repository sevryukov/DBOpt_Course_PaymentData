USE [PaymentData_v2]
GO

BEGIN TRAN tr
 DECLARE @bank_id UNIQUEIDENTIFIER
 DECLARE @supplier_id UNIQUEIDENTIFIER
 DECLARE @client_id UNIQUEIDENTIFIER
 DECLARE @cashbox_id UNIQUEIDENTIFIER
 DECLARE @category_id UNIQUEIDENTIFIER
 DECLARE @project_id UNIQUEIDENTIFIER

 SELECT TOP 1 @bank_id = Bank.Oid
 FROM Bank 
	INNER JOIN PaymentParticipant ON Bank.Oid = PaymentParticipant.Oid
 WHERE Balance > 400000
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


 DECLARE @bank_balance INT
 DECLARE @client_balance INT
 DECLARE @cashbox_balance INT
 DECLARE @supplier_balance INT

 EXEC set_balances @bank_id, @cashbox_id, @client_id, @supplier_id,
				   N'Аванс на материалы',
				   @bank_balance OUTPUT, @cashbox_balance OUTPUT,  
				   @client_balance OUTPUT, @supplier_balance OUTPUT,
				   @category_id OUTPUT

 PRINT N'Bank balance itnitial value:'
 PRINT @bank_balance
 PRINT N'Client balance initial value:'
 PRINT @client_balance
 PRINT N'Cashbox balance initital value:'
 PRINT @cashbox_balance
 PRINT N'Supplier balance initial value:'
 PRINT @supplier_balance


 INSERT Payment(
 Oid, Amount, Category, Project, Justification,
 Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
 CreateDate, CheckNumber, IsAuthorized, Number) 
 VALUES( 
 NEWID(), 400000, @category_id, @project_id, NULL, 
 N'Перевели денег поставщику для будущих закупок', GETDATE(), @bank_id, @supplier_id, NULL, NULL, 
 GETDATE(), '111111', 0, '222222')

 SELECT * FROM check_diffs(@bank_id, @cashbox_id, @client_id, @supplier_id,  
										@bank_balance, @cashbox_balance, 
										@client_balance, @supplier_balance)

 EXEC set_balances @bank_id, @cashbox_id, @client_id, @supplier_id,
				   N'Списание материалов',
				   @bank_balance OUTPUT, @cashbox_balance OUTPUT, 
				   @client_balance OUTPUT, @supplier_balance OUTPUT,
				   @category_id OUTPUT


 INSERT Payment(
 Oid, Amount, Category, Project, Justification,
 Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
 CreateDate, CheckNumber, IsAuthorized, Number) 
 VALUES( 
 NEWID(), 100000, @category_id, @project_id, NULL, 
 N'Для клиента приобрели материал. Поставщик нам должен меньше, а клиент должен за материалы', GETDATE(), @supplier_id, @client_id, NULL, NULL, 
 GETDATE(), '111111', 0, '222222')


 SELECT * FROM check_diffs(@bank_id, @cashbox_id, @client_id, @supplier_id,  
										@bank_balance, @cashbox_balance, 
										@client_balance, @supplier_balance)

 EXEC set_balances @bank_id, @cashbox_id, @client_id, @supplier_id,
				   N'Списание материалов',
				   @bank_balance OUTPUT, @cashbox_balance OUTPUT, 
				   @client_balance OUTPUT, @supplier_balance OUTPUT,
				   @category_id

 INSERT Payment(
 Oid, Amount, Category, Project, Justification,
 Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
 CreateDate, CheckNumber, IsAuthorized, Number) 
 VALUES( 
 NEWID(), 150000, @category_id, @project_id, NULL, 
 N'Клиент передал наличные для закупки материалов', GETDATE(), @client_id, @cashbox_id, NULL, NULL, 
 GETDATE(), '111111', 0, '222222')

 SELECT * FROM check_diffs(@bank_id, @cashbox_id, @client_id, @supplier_id,  
										@bank_balance, @cashbox_balance, 
										@client_balance, @supplier_balance)
 

 EXEC set_balances @bank_id, @cashbox_id, @client_id, @supplier_id,
				   N'Возврат кредита',
				   @bank_balance OUTPUT, @cashbox_balance OUTPUT, 
				   @client_balance OUTPUT, @supplier_balance OUTPUT,
				   @category_id

 INSERT Payment(
 Oid, Amount, Category, Project, Justification,
 Comment,  Date, Payer, Payee, OptimisticLockField, GCRecord,
 CreateDate, CheckNumber, IsAuthorized, Number) 
 VALUES( 
 NEWID(), 100000, @category_id, @project_id, NULL, 
 N'Частично гасим кредит', GETDATE(), @cashbox_id, @bank_id, NULL, NULL, 
 GETDATE(), '111111', 0, '222222')

 SELECT * FROM check_diffs(@bank_id, @cashbox_id, @client_id, @supplier_id,  
										@bank_balance, @cashbox_balance, 
										@client_balance, @supplier_balance)
ROLLBACK TRAN tr