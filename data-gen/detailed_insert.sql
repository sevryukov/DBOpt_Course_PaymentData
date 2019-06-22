USE [PaymentData]
GO

-- Генерация случайных участников
DECLARE @r_payee UNIQUEIDENTIFIER
DECLARE @r_payer UNIQUEIDENTIFIER
DECLARE @r_project UNIQUEIDENTIFIER

SET @r_payee = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant ORDER BY RAND())
SET @r_payer = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant ORDER BY RAND())
SET @r_project = (SELECT TOP (1) dbo.Project.Oid FROM dbo.Project ORDER BY RAND())

-- Обновляем баланс у новых участников
-- У плательщика
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(@r_payer)

-- У получателя
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(@r_payee)
	
-- Обновляем баланс у новых оъектов	
UPDATE Project
SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(@r_project),
BalanceByWork = dbo.F_CalculateBalanceByWork(@r_project),	
Balance = dbo.F_CalculateProjectBalance(@r_project)	
GO
