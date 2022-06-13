import random
from base_query_builder_service import BaseQueryBuilderService

class SuppliersQueryBuilderService(BaseQueryBuilderService):
    def generate_query(self, participant):   
        oid, contact = participant
        return "INSERT INTO [dbo].[Supplier] ([Oid], [Contact], [ProfitByMaterialAsPayer], [ProfitByMaterialAsPayee], [CostByMaterialAsPayer]) " \
               f"VALUES ('{oid}', '{contact}', {random.randint(0, 1)}, {random.randint(0, 1)}, {random.randint(0, 1)})"
