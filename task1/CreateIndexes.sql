USE PaymentData

CREATE NONCLUSTERED INDEX iNotInPaymentProfit_PaymentCategory ON [dbo].[PaymentCategory](NotInPaymentParticipantProfit)
CREATE NONCLUSTERED INDEX iName_PaymentCategory ON [dbo].[PaymentCategory](Name)
CREATE NONCLUSTERED INDEX iProfitByMaterial_PaymentCategory ON [dbo].[PaymentCategory](ProfitByMaterial)
CREATE NONCLUSTERED INDEX iCostByMaterial_PaymentCategory ON [dbo].[PaymentCategory](CostByMaterial)
CREATE NONCLUSTERED INDEX iName_AccountType ON [dbo].[AccountType](Name)
CREATE NONCLUSTERED INDEX iProfitByMaterialAsPayee_Supplier ON [dbo].[Supplier](ProfitByMaterialAsPayee)
CREATE NONCLUSTERED INDEX iProfitByMaterialAsPayer_Supplier ON [dbo].[Supplier](ProfitByMaterialAsPayer)
CREATE NONCLUSTERED INDEX iCostByMaterialAsPayer_Supplier ON [dbo].[Supplier](CostByMaterialAsPayer)

