DECLARE @id UNIQUEIDENTIFIER;
DECLARE @result int;
SET @id = CAST('6d82168c-a9c2-432b-b3cb-e8dc20777792' AS UNIQUEIDENTIFIER);
SET @result = dbo.F_CalculatePaymentParticipantBalance(@id);