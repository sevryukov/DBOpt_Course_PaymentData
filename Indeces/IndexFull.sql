DROP INDEX [iName_AccountType] ON [dbo].[AccountType]
DROP INDEX [iProfitByMaterialAsPayer_Supplier] ON [dbo].[Supplier]
DROP INDEX [iProfitByMaterialAsPayee_Supplier] ON [dbo].[Supplier]
DROP INDEX [iProfitByMaterial_Supplier] ON [dbo].[PaymentCategory]
DROP INDEX [iName_Supplier] ON [dbo].[PaymentCategory]
DROP INDEX [iCostByMaterial_Supplier] ON [dbo].[PaymentCategory]
DROP INDEX [iNotInPaymentParticipantProfit_Supplier] ON [dbo].[PaymentCategory]
 
USE [PaymentData]
GO
 
CREATE NONCLUSTERED INDEX [iName_AccountType] ON [dbo].[AccountType]
(
    [Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 
CREATE NONCLUSTERED INDEX [iProfitByMaterialAsPayer_Supplier] ON [dbo].[Supplier]
(
    [ProfitByMaterialAsPayer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 
CREATE NONCLUSTERED INDEX [iProfitByMaterialAsPayee_Supplier] ON [dbo].[Supplier]
(
    [ProfitByMaterialAsPayee] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 
CREATE NONCLUSTERED INDEX [iProfitByMaterial_Supplier] ON [dbo].[PaymentCategory]
(
    [ProfitByMaterial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 
CREATE NONCLUSTERED INDEX [iName_Supplier] ON [dbo].[PaymentCategory]
(
    [Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 
CREATE NONCLUSTERED INDEX [iCostByMaterial_Supplier] ON [dbo].[PaymentCategory]
(
    [CostByMaterial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 
CREATE NONCLUSTERED INDEX [iNotInPaymentParticipantProfit_Supplier] ON [dbo].[PaymentCategory]
(
    [NotInPaymentParticipantProfit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 
DELETE FROM dbo.Payment;
 
GO
INSERT [dbo].[Payment] ([Oid], [Amount], [Category], [Project], [Justification], [Comment], [Date], [Payer], [Payee], [OptimisticLockField], [GCRecord], [CreateDate], [CheckNumber], [IsAuthorized], [Number]) VALUES (N'37e0c01c-ee64-9267-03a4-0021e29698b6', -1056122756, N'104c0918-02a1-1f98-e0b7-861516c4f4cd', N'62cad2a3-2629-46ee-19be-9ad64ec14231', N'TWG0PUK77LY41YLXR21RQ86LOJCKS8VN1IAPUU0L5X8V8D7YLCHS6ZAKQUB5I0EYPA3JOW2X2FLT0ADBBDYFR3H28PZ0IU35I', N'gravis apparens novum Id bono habitatio quis vobis delerium. nomen Versus vobis fecit. brevens, Tam', CAST(N'1971-04-29T19:14:28.440' AS DateTime), N'a458f59a-c8c6-333d-2ae5-c31511ab1110', N'a458f59a-c8c6-333d-2ae5-c31511ab1110', 423059831, 1552449752, CAST(N'2018-09-28T10:31:08.350' AS DateTime), N'70320', 0, N'36623')
INSERT [dbo].[Payment] ([Oid], [Amount], [Category], [Project], [Justification], [Comment], [Date], [Payer], [Payee], [OptimisticLockField], [GCRecord], [CreateDate], [CheckNumber], [IsAuthorized], [Number]) VALUES (N'de4e7670-4632-58a3-f2c9-0055c624a55d', -1489679771, N'31b0efa6-9c49-0c76-5c70-6858f6528bdb', N'2ec3f4d4-272d-5f58-9f93-033300a9bfd7', N'6HANBI5XXQ', N'gravum Sed non travissimantor cognitio, estis in non fecit. novum estum. egreddior sed nomen gravis', CAST(N'1998-05-11T06:35:19.040' AS DateTime), N'0733b9ef-dd72-17cd-bdd2-ab0d956eef23', N'0733b9ef-dd72-17cd-bdd2-ab0d956eef23', 690788047, -1358593097, CAST(N'1992-05-18T15:22:55.680' AS DateTime), N'05746', 1, N'97099')
