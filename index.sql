CREATE NONCLUSTERED INDEX IDX_Payment_Date ON dbo.Payment (Date)
CREATE NONCLUSTERED INDEX IDX_Payment_Payer ON dbo.Payment (Payer)
CREATE NONCLUSTERED INDEX IDX_Payment_Payee ON dbo.Payment (Payee)
CREATE NONCLUSTERED INDEX IDX_Payment_Project ON dbo.Payment (Project)
CREATE NONCLUSTERED INDEX IDX_Payment_Category ON dbo.Payment (Category)

--
DROP index dbo.Payment.IDX_Payment_Date
DROP index dbo.Payment.Payment_Payer
DROP index dbo.Payment.Payment_Payee
DROP index dbo.Payment.Payment_Project
DROP index dbo.Payment.Payment_Category
