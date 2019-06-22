USE [PaymentData]
GO
/****** Object:  Trigger [dbo].[T_Payment_AI_Queue]    Script Date: 22.06.2019 19:01:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   TRIGGER [dbo].[T_Payment_AI_Queue]
ON [dbo].[Payment]
AFTER INSERT, UPDATE 
AS

-- inserted
INSERT dbo.PaymentQueue
(
    Payer,
    Payee,
    Project
)
SELECT  
    Inserted.Payer,
    Inserted.Payee,
    Inserted.Project
FROM Inserted	

-- deleted
INSERT dbo.PaymentQueue
(
    Payer,
    Payee,
    Project
)
SELECT  
    Deleted.Payer,
    Deleted.Payee,
    Deleted.Project
FROM Deleted


-- Пересчёт балансов если в очереди больше 1000 платежей
DECLARE @count_rows INT
SELECT @count_rows = COUNT(id) FROM PaymentQueue
IF @count_rows > 1000
BEGIN
				-- У плательщика
	UPDATE PaymentParticipant
	SET Balance = dbo.F_CalculatePaymentParticipantBalance(pq.Payer)
	FROM PaymentParticipant
	JOIN dbo.PaymentQueue pq ON PaymentParticipant.Oid = pq.Payer

	-- У получателя
	UPDATE PaymentParticipant
	SET Balance = dbo.F_CalculatePaymentParticipantBalance(pq.Payee)
	FROM PaymentParticipant
	JOIN dbo.PaymentQueue pq ON PaymentParticipant.Oid = pq.Payee
	
-- Обновляем баланс у новых оъектов	
	UPDATE Project
	SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(pq.Project),
		BalanceByWork = dbo.F_CalculateBalanceByWork(pq.Project),	
		Balance = dbo.F_CalculateProjectBalance(pq.Project)	
	FROM Project
	JOIN dbo.PaymentQueue pq ON Project.Oid = pq.Project

	DELETE FROM dbo.PaymentQueue
END