INSERT dbo.Payment 
(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
	VALUES (
		NEWID(),
		100,
		(select Oid from PaymentCategory where Name = 'Аванс на материалы'),
		'28186996-5b5b-7729-455f-1885b89fc8fc', -- project oid
		'test payment',
		'test payment',
		'2010-10-10 10:10:10',
		'2a450567-2f77-6b37-ff4b-16e575b61049', -- bank oid
		(select Oid from Supplier where Contact = 'Larita Hammett'), -- supplier oid
		NULL,
		NULL,
		'2010-10-10 10:10:10',
		'111',
		0,
		'111');