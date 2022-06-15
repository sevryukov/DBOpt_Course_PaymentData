DECLARE @ProjectId UNIQUEIDENTIFIER;
DECLARE @Result int;
SET @ProjectId = CAST('40004eda-e3d6-49ab-85f4-d44ac783c5e6' AS UNIQUEIDENTIFIER);
SET @Result = dbo.F_CalculateProjectBalance(@ProjectId);