Use PaymentData;

DECLARE @client_id UNIQUEIDENTIFIER = 'C6CBC26A-5B23-324C-BEBC-038AFF67DA1A'
DECLARE @bank_id UNIQUEIDENTIFIER = 'C98A2183-F2E2-B8C7-2F20-01EAAFACBBF7'
DECLARE @project_id UNIQUEIDENTIFIER = '1D3B4A68-4917-87EC-11DB-005ADD3F5006'
DECLARE @supplier_id UNIQUEIDENTIFIER = '645F4749-760D-39B7-73B3-0008BC479CC8'
DECLARE @payment_category_id UNIQUEIDENTIFIER = 'b747e6e7-817d-4b3c-8bd2-91481acb46a6'

INSERT dbo.PaymentParticipant(Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
	VALUES (@bank_id, 0, 'Bank', 1, null, 1, '2021-19-06 6:56:00.000', null, 'sql', 0, 0)