from time import perf_counter
from sql_adapter import SQLAdapter
from tqdm import tqdm
from collections import defaultdict
import numpy as np

driver = "{ODBC Driver 17 for SQL Server}"
database = "PaymentData"
server = "localhost,1433"
user = "sa"
password = "yourStrong(!)Password1"

adapter = SQLAdapter(driver, database, server, user, password)

adapter.clean_tables()

drop_index_queries = [
    "DROP INDEX iName_AccountType ON [dbo].[AccountType]",
    "DROP INDEX iProfitByMaterialAsPayer_Supplier ON [dbo].[Supplier]",
    "DROP INDEX iProfitByMaterialAsPayee_Supplier ON [dbo].[Supplier]",
    "DROP INDEX iProfitByMaterial_Supplier ON [dbo].[PaymentCategory]",
    "DROP INDEX iName_Supplier ON [dbo].[PaymentCategory]",
    "DROP INDEX iCostByMaterial_Supplier ON [dbo].[PaymentCategory]",
    "DROP INDEX iNotInPaymentParticipantProfit_Supplier ON [dbo].[PaymentCategory]",
]

for query in drop_index_queries:
    adapter.execute(query)
    adapter.commit()
