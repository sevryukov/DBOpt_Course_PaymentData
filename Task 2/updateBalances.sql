USE PaymentData;

DECLARE @payee_id UNIQUEIDENTIFIER
DECLARE @payer_id UNIQUEIDENTIFIER
DECLARE @project_id UNIQUEIDENTIFIER

SET @payee_id = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant)
SET @payer_id = (SELECT TOP (1) PaymentParticipant.Oid FROM dbo.PaymentParticipant)
SET @project_id = (SELECT TOP (1) dbo.Project.Oid FROM dbo.Project ORDER BY RAND())

UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(@payer_id)

UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(@payee_id)

UPDATE Project
SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(@project_id),
BalanceByWork = dbo.F_CalculateBalanceByWork(@project_id),
Balance = dbo.F_CalculateProjectBalance(@project_id)