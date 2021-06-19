
DECLARE @client_id UNIQUEIDENTIFIER = 'C6CBC26A-5B23-324C-BEBC-038AFF67DA1A'
DECLARE @project_id UNIQUEIDENTIFIER = '1D3B4A68-4917-87EC-11DB-005ADD3F5006'
DECLARE @manager_id UNIQUEIDENTIFIER = '357238B9-673D-B0F1-2AFD-001E55F33B62'
DECLARE @foreman_id UNIQUEIDENTIFIER = '083D3B09-BB02-F26E-66BB-00568D59CA2F'

INSERT dbo.Project(Oid, Name, Address,Client, Manager, Foreman, OptimisticLockField, GCRecord, Balance, BalanceByMaterial, BalanceByWork, PlaningStartDate, Status, FinishDate,Area,WorkPriceRate,WorkersPriceRate,RemainderTheAdvance,PlanfixWorkTask,PlanfixChangeRequestTask,UseAnalytics)
	VALUES (NEWID(), 'Tbcxjscdbsjbcjsc', 'CGM', @client_id, @manager_id, @foreman_id, 0, null, 3, 0, 0, '2020-19-06 21:22:00.000', 1, '2021-19-06 21:22:00.000', 10, 1000000.00, 1000.00, 0, N'Task', N'Change request task', 1)