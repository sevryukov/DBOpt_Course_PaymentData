

USE [PaymentData]
GO

BEGIN TRY
    BEGIN TRAN tr

    DECLARE @bank_id_new UNIQUEIDENTIFIER
    DECLARE @supplier_id_new UNIQUEIDENTIFIER
    DECLARE @client_id_new UNIQUEIDENTIFIER
    DECLARE @cashbox_id_new UNIQUEIDENTIFIER
    DECLARE @category_id_new UNIQUEIDENTIFIER
    DECLARE @project_id_new UNIQUEIDENTIFIER

    SELECT TOP 1 @bank_id_new = Oid
    FROM (
        SELECT Bank.Oid, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RowNum
        FROM Bank
        INNER JOIN PaymentParticipant ON Bank.Oid = PaymentParticipant.Oid
        WHERE Balance > 400000
    ) AS BankRows
    WHERE RowNum = 1

    SELECT TOP 1 @supplier_id_new = Oid
    FROM (
        SELECT Supplier.Oid, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RowNum
        FROM Supplier
        INNER JOIN PaymentParticipant ON Supplier.Oid = PaymentParticipant.Oid
    ) AS SupplierRows
    WHERE RowNum = 1

    SELECT TOP 1 @client_id_new = Oid
    FROM (
        SELECT Client.Oid, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RowNum
        FROM Client
        INNER JOIN PaymentParticipant ON Client.Oid = PaymentParticipant.Oid
    ) AS ClientRows
    WHERE RowNum = 1

    SELECT TOP 1 @cashbox_id_new = Oid
    FROM (
        SELECT Cashbox.Oid, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RowNum
        FROM Cashbox
        INNER JOIN PaymentParticipant ON Cashbox.Oid = PaymentParticipant.Oid
    ) AS CashboxRows
    WHERE RowNum = 1

    SELECT @project_id_new = Oid
    FROM Project
    WHERE Client = @client_id_new

    PRINT N' bank: ' + CONVERT(VARCHAR(36), @bank_id_new)
    PRINT N' supplier: ' + CONVERT(VARCHAR(36), @supplier_id_new)
    PRINT N' client: ' + CONVERT(VARCHAR(36), @client_id_new)
    PRINT N' cashbox: ' + CONVERT(VARCHAR(36), @cashbox_id_new)
    PRINT N' project: ' + CONVERT(VARCHAR(36), @project_id_new)

    DECLARE @bank_balance_new INT
    DECLARE @client_balance_new INT
    DECLARE @cashbox_balance_new INT
    DECLARE @supplier_balance_new INT

    EXEC set_balances @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
                      N'Аванс на материалы',
                      @bank_balance_new OUTPUT, @cashbox_balance_new OUTPUT,
                      @client_balance_new OUTPUT, @supplier_balance_new OUTPUT,
                      @category_id_new OUTPUT

    PRINT N'Bank balance initial value:'
    PRINT @bank_balance_new
    PRINT N'Client balance initial value:'
    PRINT @client_balance_new
    PRINT N'Cashbox balance initial value:'
    PRINT @cashbox_balance_new
    PRINT N'Supplier balance initial value:'
    PRINT @supplier_balance_new

    INSERT INTO Payment (
        Oid, Amount, Category, Project, Justification,
        Comment, Date, Payer, Payee, OptimisticLockField, GCRecord,
        CreateDate, CheckNumber, IsAuthorized, Number
    )
    VALUES (
        NEWID(), 400000, @category_id_new, @project_id_new, NULL,
        N'备注', GETDATE(), @bank_id_new, @supplier_id_new, NULL, NULL,
        GETDATE(), '111111', 0, '222222'
    )

    SELECT * FROM check_diffs(
        @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
        @bank_balance_new, @cashbox_balance_new,
        @client_balance_new, @supplier_balance_new
    )

    EXEC set_balances @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
                      N'Списание материалов',
                      @bank_balance_new OUTPUT, @cashbox_balance_new OUTPUT,
                      @client_balance_new OUTPUT, @supplier_balance_new OUTPUT,
                      @category_id_new OUTPUT

    INSERT INTO Payment (
        Oid, Amount, Category, Project, Justification,
        Comment, Date, Payer, Payee, OptimisticLockField, GCRecord,
        CreateDate, CheckNumber, IsAuthorized, Number
    )
    VALUES (
        NEWID(), 100000, @category_id_new, @project_id_new, NULL,
        N'Для клиента приобрели материал. Поставщик нам должен меньше, а клиент должен за материалы',
        GETDATE(), @supplier_id_new, @client_id_new, NULL, NULL,
        GETDATE(), '111111', 0, '222222'
    )

    SELECT * FROM check_diffs(
        @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
        @bank_balance_new, @cashbox_balance_new,
        @client_balance_new, @supplier_balance_new
    )

    EXEC set_balances @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
                      N'Списание материалов',
                      @bank_balance_new OUTPUT, @cashbox_balance_new OUTPUT,
                      @client_balance_new OUTPUT, @supplier_balance_new OUTPUT,
                      @category_id_new

    INSERT INTO Payment (
        Oid, Amount, Category, Project, Justification,
        Comment, Date, Payer, Payee, OptimisticLockField, GCRecord,
        CreateDate, CheckNumber, IsAuthorized, Number
    )
    VALUES (
        NEWID(), 150000, @category_id_new, @project_id_new, NULL,
        N'备注', GETDATE(), @client_id_new, @cashbox_id_new, NULL, NULL,
        GETDATE(), '111111', 0, '222222'
    )

    SELECT * FROM check_diffs(
        @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
        @bank_balance_new, @cashbox_balance_new,
        @client_balance_new, @supplier_balance_new
    )

    EXEC set_balances @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
                      N'Возврат кредита',
                      @bank_balance_new OUTPUT, @cashbox_balance_new OUTPUT,
                      @client_balance_new OUTPUT, @supplier_balance_new OUTPUT,
                      @category_id_new

    INSERT INTO Payment (
        Oid, Amount, Category, Project, Justification,
        Comment, Date, Payer, Payee, OptimisticLockField, GCRecord,
        CreateDate, CheckNumber, IsAuthorized, Number
    )
    VALUES (
        NEWID(), 100000, @category_id_new, @project_id_new, NULL,
        N'Частично гасим кредит', GETDATE(), @cashbox_id_new, @bank_id_new, NULL, NULL,
        GETDATE(), '111111', 0, '222222'
    )

    SELECT * FROM check_diffs(
        @bank_id_new, @cashbox_id_new, @client_id_new, @supplier_id_new,
        @bank_balance_new, @cashbox_balance_new,
        @client_balance_new, @supplier_balance_new
    )

    COMMIT TRAN tr
END TRY
BEGIN CATCH
    ROLLBACK TRAN tr
END CATCH
