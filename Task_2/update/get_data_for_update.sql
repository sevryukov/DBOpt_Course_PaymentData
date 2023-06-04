USE [PaymentData]
GO

SELECT TOP 1 *
FROM dbo.Payment
ORDER BY NEWID()
GO