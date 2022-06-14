USE PaymentData

DROP INDEX IF EXISTS PayCat_NotInPaymentProfit ON [dbo].[PaymentCategory]
DROP INDEX IF EXISTS PayCat_Name ON [dbo].[PaymentCategory]
DROP INDEX IF EXISTS AccType_Name ON [dbo].[AccountType]
