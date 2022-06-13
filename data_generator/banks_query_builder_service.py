import random
from base_query_builder_service import BaseQueryBuilderService

class BanksQueryBuilderService(BaseQueryBuilderService):
    @staticmethod
    def generate_query(bank_oid, account_types):   
        account_type = random.choice(account_types)
        return f"INSERT INTO [dbo].[Bank] ([Oid], [AccountType]) VALUES ('{bank_oid}', '{account_type}')"
