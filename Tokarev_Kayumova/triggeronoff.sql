INSERT INTO Payment SELECT TOP 5000 NEWID() as Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number FROM Payment;
INSERT INTO Payment SELECT TOP 1 NEWID() as Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number FROM Payment;
GO

DISABLE TRIGGER T_Payment_AI ON Payment;  
INSERT INTO Payment SELECT TOP 5000 NEWID() as Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number FROM Payment;
ENABLE Trigger T_Payment_AI ON Payment; 
INSERT INTO Payment SELECT TOP 1 NEWID() as Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number FROM Payment;
GO