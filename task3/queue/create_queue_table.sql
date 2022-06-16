USE [PaymentData]
GO
CREATE TABLE [dbo].[PaymentQueue](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Payer] [uniqueidentifier] NULL,
	[Payee] [uniqueidentifier] NULL,
	[Project] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
([id] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
