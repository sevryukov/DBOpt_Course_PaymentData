USE PaymentData
GO

DROP PROCEDURE IF EXISTS dbo.check_balances
GO

CREATE PROCEDURE dbo.check_balances
	@bank_id UNIQUEIDENTIFIER,
	@cashbox_id UNIQUEIDENTIFIER,
	@client_id UNIQUEIDENTIFIER,
	@supplier_id UNIQUEIDENTIFIER,
	@old_bank_balance INT,
	@old_cashbox_balance INT,
	@old_client_balance INT,
	@old_supplier_balance INT
AS
	DECLARE @curr_bank_balance INT
	DECLARE @curr_client_balance INT
	DECLARE @curr_cashbox_balance INT
	DECLARE @curr_supplier_balance INT

	SET @curr_bank_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_id);
	SET @curr_client_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_id);
	SET @curr_cashbox_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_id);
	SET @curr_supplier_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_id);

	SELECT 
		@curr_bank_balance - @old_bank_balance AS bank,
		@curr_client_balance - @old_client_balance AS cashbox,
		@curr_cashbox_balance - @old_cashbox_balance AS client,
		@curr_supplier_balance - @old_supplier_balance AS supplier
