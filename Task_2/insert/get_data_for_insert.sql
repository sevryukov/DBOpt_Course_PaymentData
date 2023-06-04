USE [PaymentData]
GO

DECLARE @client_id UNIQUEIDENTIFIER

SELECT TOP 1 Supplier.Oid AS Suplier
FROM Supplier 
INNER JOIN PaymentParticipant ON Supplier.Oid = PaymentParticipant.Oid
ORDER BY NEWID()

SELECT TOP 1 @client_id = Client.Oid
FROM Client
INNER JOIN PaymentParticipant ON Client.Oid = PaymentParticipant.Oid
ORDER BY NEWID()

SELECT @client_id As Client

SELECT TOP 1 Oid AS Category
FROM PaymentCategory 
ORDER BY NEWID()

SELECT Oid AS Project
FROM Project
WHERE Client = @client_id
GO