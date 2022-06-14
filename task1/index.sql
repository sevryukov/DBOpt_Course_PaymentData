CREATE NONCLUSTERED INDEX iProfitByMaterialAsPayer_Supplier 
ON [dbo].[Supplier] (ProfitByMaterialAsPayer)

CREATE NONCLUSTERED INDEX iProfitByMaterialAsPayee_Supplier 
ON [dbo].[Supplier] (ProfitByMaterialAsPayee)

CREATE NONCLUSTERED INDEX iName_AccountType 
ON [dbo].[AccountType] (Name)

CREATE NONCLUSTERED INDEX iProfitByMaterial_PaymentCategory 
ON [dbo].[PaymentCategory] (ProfitByMaterial)

CREATE NONCLUSTERED INDEX iCostByMaterial_PaymentCategory 
ON [dbo].[PaymentCategory] (CostByMaterial)

CREATE NONCLUSTERED INDEX iNotInPaymentParticipantProfit_PaymentCategory 
ON [dbo].[PaymentCategory] (NotInPaymentParticipantProfit)