from sql_client import SQLClient

n_participants = 10
n_projects = 10
n_participants = 10
n_payments = 1

driver = '{ODBC Driver 17 for SQL Server}'
database = 'PaymentData'
server = '192.168.0.155'
user = 'sa'
password = 'Sevryuk0v_BD'

client = SQLClient(driver, database, server, user, password)
# client.generate_participants_records(n_participants)
# client.generate_suppliers_records()
# client.generate_employees_records()
# client.generate_clients_records()
# client.generate_projects_records(n_projects)
# client.generate_cashboxes_records()
# client.generate_banks_records()
client.generate_payments_records(n_payments)
