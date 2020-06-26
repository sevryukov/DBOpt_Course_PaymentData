from time import perf_counter
from sql_adapter import SQLAdapter
from multiprocessing import Pool
from tqdm import tqdm
import numpy as np
from collections import defaultdict

driver = "{ODBC Driver 17 for SQL Server}"
database = "PaymentData"
server = "localhost,1433"
user = "sa"
password = "yourStrong(!)Password1"

adapter = SQLAdapter(driver, database, server, user, password)

adapter.clean_tables()
adapter.generate(n_participants=1000, n_projects=100, n_payments=0)


def generate_payments_with_adapter(n):
    driver = "{ODBC Driver 17 for SQL Server}"
    database = "PaymentData"
    server = "localhost,1433"
    user = "sa"
    password = "yourStrong(!)Password1"

    adapter = SQLAdapter(driver, database, server, user, password)
    adapter.generate_payments(n, lock="WITH (UPDLOCK)")


payments = [100, 1000, 3000]
chunk_sizes = [1, 10, 100]
pool_size = 2
times = defaultdict(list)

with open("logs_multiprocessing.txt", "w") as file:
    for _ in tqdm(range(5)):
        for chunk in chunk_sizes:
            for n in payments:
                adapter.clean_tables(tables=["Payment"])
                start_time = perf_counter()
                with Pool(pool_size) as p:
                    p.map(generate_payments_with_adapter, [chunk] * (n // chunk))
                total_time = perf_counter() - start_time
                times[(n, chunk)].append(total_time)
                file.write(
                    f"Number of inserted payments: {n},"
                    f" number of chunks: {chunk},"
                    f" number of processes {pool_size},"
                    f" total time: {total_time} seconds\n"
                )
    file.write("\n".join([f"{x}: {np.mean(times[x])}" for x in times]))
