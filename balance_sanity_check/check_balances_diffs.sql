 CREATE FUNCTION dbo.check_diffs(
 @bank_id UNIQUEIDENTIFIER,
 @cashbox_id UNIQUEIDENTIFIER,
 @client_id UNIQUEIDENTIFIER,
 @supplier_id UNIQUEIDENTIFIER,
 @old_bank_balance INT,
 @old_cashbox_balance INT,
 @old_client_balance INT,
 @old_supplier_balance INT)
 RETURNS @Diffs TABLE(
 bank INT,
 cashbox INT,
 client INT,
 supplier INT)
 AS
 BEGIN 
	DECLARE @curr_bank_balance INT
	DECLARE @curr_client_balance INT
	DECLARE @curr_cashbox_balance INT
	DECLARE @curr_supplier_balance INT

	DECLARE @bank_balance_diff INT
	DECLARE @client_balance_diff INT
	DECLARE @cashbox_balance_diff INT
	DECLARE @supplier_balance_diff INT

	SET @curr_bank_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_id);
	SET @curr_client_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_id);
	SET @curr_cashbox_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_id);
	SET @curr_supplier_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_id);

	SET @bank_balance_diff = @curr_bank_balance - @old_bank_balance
	SET @client_balance_diff = @curr_client_balance - @old_client_balance 
	SET @cashbox_balance_diff = @curr_cashbox_balance - @old_cashbox_balance
	SET @supplier_balance_diff = @curr_supplier_balance - @old_supplier_balance

	INSERT INTO @Diffs
	(
	    bank,
		cashbox,
	    client,
	    supplier
	)
	VALUES
	(   @bank_balance_diff,
		@cashbox_balance_diff, 
	    @client_balance_diff, 
	    @supplier_balance_diff  
	    )

RETURN
END
