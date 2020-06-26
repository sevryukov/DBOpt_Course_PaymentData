/*
This query text was retrieved from showplan XML, and may be truncated.
*/

INSERT INTO [dbo].[Payment]([Oid],[Amount],[Category],[Project],[Justification],[Comment],[Date],[Payer],[Payee],[OptimisticLockField],[GCRecord],[CreateDate],[CheckNumber],[IsAuthorized],[Number]) values(@1,@2,@3,@4,@5,@6,CONVERT([datetime],@7),@8,@9,@10,@11,CONVERT([datetime],@12),@13,@14,@15)
update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payer)
	from PaymentParticipant
	join Inserted on PaymentParticipant.Oid = inserted.Payer
UPDATE [dbo].[PaymentParticipant]
   SET 
      [Balance] = dbo.F_CalculatePaymentParticipantBalance(inserted.oid)
      ,[Name] = inserted.Name
      ,[OptimisticLockField] = inserted.OptimisticLockField
      ,[GCRecord] = inserted.GCRecord
      ,[ObjectType] = inserted.ObjectType      
      ,[ActiveFrom] = inserted.ActiveFrom
      ,[InactiveFrom] = inserted.InactiveFrom
      ,[BankDetails] = inserted.BankDetails
	  ,[Balance2] = inserted.Balance2
 FROM [PaymentParticipant] join Inserted on [PaymentParticipant].Oid = Inserted.Oid
update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payee)
	from PaymentParticipant
	join Inserted on PaymentParticipant.Oid = inserted.Payee
UPDATE [dbo].[PaymentParticipant]
   SET 
      [Balance] = dbo.F_CalculatePaymentParticipantBalance(inserted.oid)
      ,[Name] = inserted.Name
      ,[OptimisticLockField] = inserted.OptimisticLockField
      ,[GCRecord] = inserted.GCRecord
      ,[ObjectType] = inserted.ObjectType      
      ,[ActiveFrom] = inserted.ActiveFrom
      ,[InactiveFrom] = inserted.InactiveFrom
      ,[BankDetails] = inserted.BankDetails
	  ,[Balance2] = inserted.Balance2
 FROM [PaymentParticipant] join Inserted on [PaymentParticipant].Oid = Inserted.Oid
update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payer)
	from PaymentParticipant
	join deleted on PaymentParticipant.Oid = deleted.Payer
UPDATE [dbo].[PaymentParticipant]
   SET 
      [Balance] = dbo.F_CalculatePaymentParticipantBalance(inserted.oid)
      ,[Name] = inserted.Name
      ,[OptimisticLockField] = inserted.OptimisticLockField
      ,[GCRecord] = inserted.GCRecord
      ,[ObjectType] = inserted.ObjectType      
      ,[ActiveFrom] = inserted.ActiveFrom
      ,[InactiveFrom] = inserted.InactiveFrom
      ,[BankDetails] = inserted.BankDetails
	  ,[Balance2] = inserted.Balance2
 FROM [PaymentParticipant] join Inserted on [PaymentParticipant].Oid = Inserted.Oid
update PaymentParticipant
	set Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payee)
	from PaymentParticipant
	join deleted on PaymentParticipant.Oid = deleted.Payee
UPDATE [dbo].[PaymentParticipant]
   SET 
      [Balance] = dbo.F_CalculatePaymentParticipantBalance(inserted.oid)
      ,[Name] = inserted.Name
      ,[OptimisticLockField] = inserted.OptimisticLockField
      ,[GCRecord] = inserted.GCRecord
      ,[ObjectType] = inserted.ObjectType      
      ,[ActiveFrom] = inserted.ActiveFrom
      ,[InactiveFrom] = inserted.InactiveFrom
      ,[BankDetails] = inserted.BankDetails
	  ,[Balance2] = inserted.Balance2
 FROM [PaymentParticipant] join Inserted on [PaymentParticipant].Oid = Inserted.Oid
update Project
	set BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(inserted.Project),
	BalanceByWork = dbo.F_CalculateBalanceByWork(inserted.Project),	
	Balance = dbo.F_CalculateProjectBalance(inserted.Project)	
	from Project
	join Inserted on Project.Oid = inserted.Project
UPDATE [Project]
   SET [Name] = inserted.Name
      ,[Address] = Inserted.Address
      ,[Client] = Inserted.Client
      ,[Manager] = Inserted.Manager
      ,[Foreman] = Inserted.Foreman
      ,[OptimisticLockField] = Inserted.OptimisticLockField
      ,[GCRecord] = Inserted.GCRecord
      ,[Balance] = dbo.F_CalculateProjectBalance(Project.Oid)
      ,[BalanceByMaterial] = dbo.F_CalculateBalanceByMaterial(Project.Oid)
      ,[BalanceByWork] = dbo.F_CalculateBalanceByWork(Project.Oid)
      ,[RemainderTheAdvance] = dbo.F_CalculateRemainderTheAdvance(Project.Oid)
      ,[PlaningStartDate] = Inserted.PlaningStartDate
      ,[Status] = Inserted.Status
      ,[FinishDate] = Inserted.FinishDate
      ,[Area] = Inserted.Area 
      ,[WorkPriceRate] = Inserted.WorkPriceRate
      ,[WorkersPriceRate] = Inserted.WorkersPriceRate
      ,[PlanfixWorkTask] = Inserted.PlanfixWorkTask
      ,[PlanfixChangeRequestTask] = Inserted.PlanfixChangeRequestTask
      ,[UseAnalytics] = inserted.UseAnalytics
FROM Project join Inserted on Project.Oid = Inserted.Oid
update Project
	set BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(deleted.Project),
	BalanceByWork = dbo.F_CalculateBalanceByWork(deleted.Project),	
	Balance = dbo.F_CalculateProjectBalance(deleted.Project)	
	from Project
	join deleted on Project.Oid = deleted.Project
UPDATE [Project]
   SET [Name] = inserted.Name
      ,[Address] = Inserted.Address
      ,[Client] = Inserted.Client
      ,[Manager] = Inserted.Manager
      ,[Foreman] = Inserted.Foreman
      ,[OptimisticLockField] = Inserted.OptimisticLockField
      ,[GCRecord] = Inserted.GCRecord
      ,[Balance] = dbo.F_CalculateProjectBalance(Project.Oid)
      ,[BalanceByMaterial] = dbo.F_CalculateBalanceByMaterial(Project.Oid)
      ,[BalanceByWork] = dbo.F_CalculateBalanceByWork(Project.Oid)
      ,[RemainderTheAdvance] = dbo.F_CalculateRemainderTheAdvance(Project.Oid)
      ,[PlaningStartDate] = Inserted.PlaningStartDate
      ,[Status] = Inserted.Status
      ,[FinishDate] = Inserted.FinishDate
      ,[Area] = Inserted.Area 
      ,[WorkPriceRate] = Inserted.WorkPriceRate
      ,[WorkersPriceRate] = Inserted.WorkersPriceRate
      ,[PlanfixWorkTask] = Inserted.PlanfixWorkTask
      ,[PlanfixChangeRequestTask] = Inserted.PlanfixChangeRequestTask
      ,[UseAnalytics] = inserted.UseAnalytics
FROM Project join Inserted on Project.Oid = Inserted.Oid

