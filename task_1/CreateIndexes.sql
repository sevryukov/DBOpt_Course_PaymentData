USE PaymentData

CREATE NONCLUSTERED INDEX PayCat_NotInPaymentProfit ON [dbo].[PaymentCategory](NotInPaymentParticipantProfit)
CREATE NONCLUSTERED INDEX PayCat_Name ON [dbo].[PaymentCategory](Name)
CREATE NONCLUSTERED INDEX AccType_Name ON [dbo].[AccountType](Name)
