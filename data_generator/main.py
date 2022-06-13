from sql_client import SQLClient

n_participants = 10
n_projects = 10
n_participants = 10
n_payments = 100

driver = ''
database = ''
server = ''
user = ''
password = ''

client = SQLClient(driver, database, server, user, password)
# client.generate_participants_records(n_participants)
# client.generate_suppliers_records()
# client.generate_employees_records()
# client.generate_clients_records()
# client.generate_projects_records(n_projects)
# client.generate_cashboxes_records()
# client.generate_banks_records()
client.generate_payments_records(n_payments)
