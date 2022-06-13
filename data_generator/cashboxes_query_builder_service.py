import random
from base_query_builder_service import BaseQueryBuilderService

class CashboxesQueryBuilderService(BaseQueryBuilderService):
    def generate_query(self, participant_id, account_types):    
        account_type = random.choice(account_types)
        return f"""INSERT INTO [dbo].[Cashbox] ([Oid], [AccountType]) VALUES ('{participant_id}', '{account_type}')"""
