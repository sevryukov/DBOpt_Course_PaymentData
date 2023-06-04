USE [PaymentData]
GO

-- AccountType.Name
DROP INDEX [iName_AccountType] ON [dbo].[AccountType]


-- Supplier.ProfitByMaterialAsPayer
DROP INDEX [iProfitByMaterialAsPayer_Supplier] ON [dbo].[Supplier]


-- Supplier.ProfitByMaterialAsPayee
DROP INDEX [iProfitByMaterialAsPayee_Supplier] ON [dbo].[Supplier]


-- PaymentCategory.ProfitByMaterial
DROP INDEX [iProfitByMaterial_Supplier] ON [dbo].[PaymentCategory]


-- PaymentCategory.Name
DROP INDEX [iName_Supplier] ON [dbo].[PaymentCategory]


-- PaymentCategory.CostByMaterial
DROP INDEX [iCostByMaterial_Supplier] ON [dbo].[PaymentCategory]


-- PaymentCategory.NotInPaymentParticipantProfit
DROP INDEX [iNotInPaymentParticipantProfit_Supplier] ON [dbo].[PaymentCategory]
