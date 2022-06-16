USE [PaymentData]
GO

CREATE OR ALTER TRIGGER [dbo].[T_Payment_AI_Queue]
ON [dbo].[Payment]
AFTER INSERT, UPDATE 
AS

INSERT dbo.PaymentQueue (Payer, Payee, Project)
SELECT inserted.Payer, inserted.Payee, inserted.Project
FROM Inserted	

INSERT dbo.PaymentQueue (Payer, Payee, Project)
SELECT deleted.Payer, deleted.Payee, deleted.Project
FROM Deleted

DECLARE @count INT
SELECT @count = COUNT(id) FROM PaymentQueue
IF @count > 10
BEGIN
	UPDATE PaymentParticipant
	SET Balance = dbo.F_CalculatePaymentParticipantBalance(pq.Payer)
	FROM PaymentParticipant
	JOIN dbo.PaymentQueue pq ON PaymentParticipant.Oid = pq.Payer

	UPDATE PaymentParticipant
	SET Balance = dbo.F_CalculatePaymentParticipantBalance(pq.Payee)
	FROM PaymentParticipant
	JOIN dbo.PaymentQueue pq ON PaymentParticipant.Oid = pq.Payee
	
	UPDATE Project
	SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(pq.Project),
		BalanceByWork = dbo.F_CalculateBalanceByWork(pq.Project),	
		Balance = dbo.F_CalculateProjectBalance(pq.Project)	
	FROM Project
	JOIN dbo.PaymentQueue pq ON Project.Oid = pq.Project

	DELETE FROM dbo.PaymentQueue
END
