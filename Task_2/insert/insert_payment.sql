USE [PaymentData]
GO

BEGIN TRAN tr
	INSERT INTO [dbo].[Payment]
			   ([Oid]
			   ,[Amount]
			   ,[Category]
			   ,[Project]
			   ,[Justification]
			   ,[Comment]
			   ,[Date]
			   ,[Payer]
			   ,[Payee]
			   ,[OptimisticLockField]
			   ,[GCRecord]
			   ,[CreateDate]
			   ,[CheckNumber]
			   ,[IsAuthorized]
			   ,[Number])
		 VALUES
			   (NEWID()
			   , 10000
			   , '700AB7DD-72AE-4F01-A7E2-1DBC341ED4C2'
			   , '6B15361A-B326-C6FE-1836-6A83F562DB19'
			   , NULL
			   , NULL
			   , NULL
			   , '5E4921C3-69C8-0B03-8BC5-28A076ECD5D7'
			   , 'BC4C5FA1-51ED-6A8E-4023-239E31EF3380'
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL)
ROLLBACK TRAN tr
GO


