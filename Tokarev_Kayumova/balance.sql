SELECT Balance FROM PaymentParticipant WHERE Oid = '2a450567-2f77-6b37-ff4b-16e575b61049';
SELECT Balance FROM PaymentParticipant WHERE Oid = (select Oid from Supplier where Contact = 'Larita Hammett');
GO

SELECT 1
	where '2a450567-2f77-6b37-ff4b-16e575b61049' -- bank oid
	not in (Select Oid from Employee); 
GO
-- Payer.Oid not in (Select Oid from Employee)
-- Payee.Oid in (Select Oid from Employee)


SELECT NotInPaymentParticipantProfit from PaymentCategory where Name = 'Аванс на материалы';
GO
-- dbo.PaymentCategory.NotInPaymentParticipantProfit <> 1

SELECT 1
	WHERE (select Oid from Supplier where Contact = 'Larita Hammett')
	in (Select Oid from Employee);
GO
-- Payee.Oid in (Select Oid from Employee)