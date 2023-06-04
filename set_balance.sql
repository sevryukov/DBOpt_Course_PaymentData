

USE PaymentData_v2
GO

CREATE PROCEDURE set_balances
	@bank_id_new UNIQUEIDENTIFIER,
	@cashbox_id_new UNIQUEIDENTIFIER,
	@client_id_new UNIQUEIDENTIFIER,
	@supplier_id_new UNIQUEIDENTIFIER,
	@category_name_new NVARCHAR(100),
	@bank_balance_new INT OUTPUT,
	@cashbox_balance_new INT OUTPUT,
	@client_balance_new INT OUTPUT,
	@supplier_balance_new INT OUTPUT,
	@category_id_new UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  SELECT 
    @bank_balance_new = Balance, 
    @cashbox_balance_new = Balance, 
    @client_balance_new = Balance, 
    @supplier_balance_new = Balance
  FROM PaymentParticipant
  WHERE Oid IN (@bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new)

  SELECT @category_id_new = Oid
  FROM PaymentCategory
  WHERE Name = @category_name_new
END
GO



