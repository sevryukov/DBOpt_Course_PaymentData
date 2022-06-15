USE PaymentData

DROP INDEX IF EXISTS iNotInPaymentProfit_PaymentCategory ON [dbo].[PaymentCategory]
DROP INDEX IF EXISTS iName_PaymentCategory ON [dbo].[PaymentCategory]
DROP INDEX IF EXISTS iProfitByMaterial_PaymentCategory ON [dbo].[PaymentCategory]
DROP INDEX IF EXISTS iCostByMaterial_PaymentCategory ON [dbo].[PaymentCategory]
DROP INDEX IF EXISTS iName_AccountType ON [dbo].[AccountType]
DROP INDEX IF EXISTS iProfitByMaterialAsPayee_Supplier ON [dbo].[Supplier]
DROP INDEX IF EXISTS iProfitByMaterialAsPayer_Supplier ON [dbo].[Supplier]
DROP INDEX IF EXISTS iCostByMaterialAsPayer_Supplier ON [dbo].[Supplier]
