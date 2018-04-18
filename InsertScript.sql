USE PaymentData;

DECLARE @startTime DATETIME
SET @startTime = GETDATE()

DECLARE @sql VARCHAR(max)
DECLARE @i INT

SET @i=0

--SET STATISTICS IO ON SET STATISTICS TIME ON 
SET @sql='INSERT INTO dbo.Payment(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) VALUES ';

WHILE (@i < 1000)
BEGIN
	SELECT @sql = @sql + '(
		NEWID(),
		5 + ABS(CHECKSUM(NewId())) % 46,
		(SELECT TOP 1 (Oid) FROM PaymentCategory ORDER BY NEWID()),
		(SELECT TOP 1 Oid FROM Project ORDER BY NEWID()),
		(SELECT CONVERT(varchar(100), NEWID())),
		(SELECT CONVERT(varchar(100), NEWID())),
		(DATEADD(day, (ABS(CHECKSUM(NEWID())) % 65530), 0)),
		(SELECT TOP 1 Oid FROM PaymentParticipant ORDER BY NEWID()),
		(SELECT TOP 1 Oid FROM PaymentParticipant ORDER BY NEWID()),
		NULL,
		NULL,
		(DATEADD(day, (ABS(CHECKSUM(NEWID())) % 65530), 0)),
		(SELECT CONVERT(varchar(100), NEWID())),
		(SELECT CRYPT_GEN_RANDOM(1) % 2),
		(SELECT CONVERT(varchar(100), NEWID()))
	),';
    SET @i=@i+1;
END

SELECT @sql=SUBSTRING(@sql,1,LEN(@sql)-1)+';'

EXECUTE (@sql);

PRINT datediff(ms, @startTime, getdate());
