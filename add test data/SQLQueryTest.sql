IF EXISTS(SELECT 1 FROM sys.tables WHERE NAME = 'TestData')
BEGIN
    DROP TABLE [dbo].[TestData];
END
GO

CREATE TABLE [dbo].[TestData](
RowNum INT PRIMARY KEY,
SomeId INT,
SomeCode CHAR(2)
);
GO

INSERT INTO [dbo].[TestData]
SELECT TOP 10000000
    ROW_NUMBER() OVER (ORDER BY t1.NAME) AS RowNumber,
    ABS(CHECKSUM(NEWID()))%2500+1 AS SomeId, 
    CHAR(ABS(CHECKSUM(NEWID()))%26+65)
    + CHAR(ABS(CHECKSUM(NEWID()))%26+65) AS SomeCode
FROM 
    Master.dbo.SysColumns t1,
    Master.dbo.SysColumns t2
GO

select COUNT(*) from TestData