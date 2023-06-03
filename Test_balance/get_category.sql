USE PaymentData
GO

DROP FUNCTION IF EXISTS dbo.get_category
GO

CREATE FUNCTION dbo.get_category(
	@category_name NVARCHAR(100)
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @category_id UNIQUEIDENTIFIER
	SELECT @category_id = Oid
	FROM PaymentCategory 
	WHERE Name = @category_name
	RETURN @category_id
END