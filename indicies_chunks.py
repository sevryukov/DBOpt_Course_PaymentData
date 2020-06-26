from collections import defaultdict
from time import perf_counter

import numpy as np
from tqdm import tqdm

from sql_adapter import SQLAdapter

driver = "{ODBC Driver 17 for SQL Server}"
database = "PaymentData"
server = "localhost,1433"
user = "sa"
password = "yourStrong(!)Password1"

adapter = SQLAdapter(driver, database, server, user, password)

adapter.clean_tables()
adapter.generate(n_participants=1000, n_projects=100, n_payments=0)

times = defaultdict(list)
payments = [100, 1000, 3000]
chunk_sizes = [1, 10, 100]

with open("logs.txt", "w") as file:
    for _ in range(5):
        for chunk in chunk_sizes:
            for n in payments:
                adapter.clean_tables(tables=["Payment"])
                start_time = perf_counter()
                for _ in tqdm(range(n // chunk)):
                    adapter.generate_payments(chunk)
                total_time = perf_counter() - start_time
                times[(n, chunk)].append(total_time)
                file.write(
                    f"Number of inserted payments: {n},"
                    f"chunk size {chunk}, total time: {total_time} seconds\n"
                )
            file.write("\n")
    file.write("\n".join([f"{x}: {np.mean(times[x])}" for x in times]))
