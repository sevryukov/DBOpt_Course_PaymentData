USE PaymentData_v2
GO
CREATE PROCEDURE set_balances
	@bank_id UNIQUEIDENTIFIER,
	@cashbox_id UNIQUEIDENTIFIER,
	@client_id UNIQUEIDENTIFIER,
	@supplier_id UNIQUEIDENTIFIER,
	@category_name NVARCHAR(100),
	@bank_balance INT OUTPUT,
	@cashbox_balance INT OUTPUT,
	@client_balance INT OUTPUT,
	@supplier_balance INT OUTPUT,
	@category_id UNIQUEIDENTIFIER OUTPUT
AS
  SET @bank_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @bank_id)
  SET @cashbox_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @cashbox_id)
  SET @client_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @client_id)
  SET @supplier_balance = (SELECT Balance FROM PaymentParticipant WHERE Oid = @supplier_id)

  SELECT @category_id = Oid
  FROM PaymentCategory 
  WHERE Name = @category_name