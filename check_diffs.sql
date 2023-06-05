


CREATE FUNCTION dbo.check_diffs(
    @bank_id UNIQUEIDENTIFIER,
    @cashbox_id UNIQUEIDENTIFIER,
    @client_id UNIQUEIDENTIFIER,
    @supplier_id UNIQUEIDENTIFIER,
    @old_bank_balance INT,
    @old_cashbox_balance INT,
    @old_client_balance INT,
    @old_supplier_balance INT
)
RETURNS TABLE
AS
RETURN (
    SELECT
        curr.Balance - @old_bank_balance AS bank,
        curc.Balance - @old_cashbox_balance AS cashbox,
        curcl.Balance - @old_client_balance AS client,
        curs.Balance - @old_supplier_balance AS supplier
    FROM
        PaymentParticipant curr
    CROSS JOIN
        PaymentParticipant curc
    CROSS JOIN
        PaymentParticipant curcl
    CROSS JOIN
        PaymentParticipant curs
    WHERE
        curr.Oid = @bank_id
        AND curc.Oid = @cashbox_id
        AND curcl.Oid = @client_id
        AND curs.Oid = @supplier_id
)
