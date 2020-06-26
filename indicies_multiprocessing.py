from time import perf_counter
from sql_adapter import SQLAdapter
from multiprocessing import Pool

driver = "{ODBC Driver 17 for SQL Server}"
database = "PaymentData"
server = "localhost,1433"
user = "sa"
password = "yourStrong(!)Password1"

adapter = SQLAdapter(driver, database, server, user, password)

adapter.clean_tables()
adapter.generate(n_participants=1000, n_projects=100, n_payments=0)

payments = [100, 1000, 10000]


def generate_payments_with_adapter(n):
    driver = "{ODBC Driver 17 for SQL Server}"
    database = "PaymentData"
    server = "localhost,1433"
    user = "sa"
    password = "yourStrong(!)Password1"

    adapter = SQLAdapter(driver, database, server, user, password)
    adapter.generate_payments(n)


for n in payments:
    adapter.clean_tables(tables=["Payment"])
    start_time = perf_counter()
    with Pool(2) as p:
        p.map(generate_payments_with_adapter, [1] * n)
    total_time = perf_counter() - start_time
    print(f"Number of inserted payments: {n}, total time: {total_time} seconds")
