Use PaymentData;

DECLARE @client_id UNIQUEIDENTIFIER = 'C6CBC26A-5B23-324C-BEBC-038AFF67DA1A'
DECLARE @bank_id UNIQUEIDENTIFIER = 'F1892588-35D7-7D59-4984-916FDE141879'
DECLARE @project_id UNIQUEIDENTIFIER = '1D3B4A68-4917-87EC-11DB-005ADD3F5006'
DECLARE @payment_category_id UNIQUEIDENTIFIER = 'b747e6e7-817d-4b3c-8bd2-91481acb46a6'

INSERT dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
	VALUES (NEWID(),400000, @payment_category_id, @project_id, NULL, 'First iteration', '2021-19-06 03:56:00.000', @bank_id, @supplier_id, NULL, NULL, '2021-19-05 03:56:00.000',  '233', 4, '0');

	DECLARE @bank_balance INT = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_id);
	PRINT @bank_balance;