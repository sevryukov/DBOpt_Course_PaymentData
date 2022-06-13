from payment_participants_query_builder import PaymentParticipantsQueryBuilderService
from suppliers_query_builder_service import SuppliersQueryBuilderService
from employees_query_builder_service import EmployeesQueryBuilderService
from clients_query_builder_service import ClientsQueryBuilderService
from projects_query_builder_service import ProjectsQueryBuilderService
from cashboxes_query_builder_service import CashboxesQueryBuilderService
from banks_query_builder_service import BanksQueryBuilderService
from payments_query_builder_service import PaymentsQueryBuilderService
import pyodbc


class SQLClient:
    OBJECT_TYPES = ["cashless", "cash", "client", "employee", "supplier"]

    def __init__(self, driver, database, server, user, password):
        self.cnxn = pyodbc.connect(
            f"DRIVER={driver};DATABASE={database};SERVER={server};UID={user};PWD={password}"
        )

    @property
    def execute(self):
        return self.cnxn.cursor().execute

    @property
    def commit(self):
        return self.cnxn.commit

    def generate_participants_records(self, n):
        for _ in range(n):
            self.execute(PaymentParticipantsQueryBuilderService().generate_query())
        self.commit()

    def generate_suppliers_records(self):
        supplier = self.OBJECT_TYPES.index("supplier")
        for participant in self.participant_ids_with_name(supplier).fetchall():
            self.execute(SuppliersQueryBuilderService().generate_query(participant))
        self.commit()

    def generate_employees_records(self):
        employee = self.OBJECT_TYPES.index("employee")
        for participant in self.participant_ids_with_name(employee).fetchall():
            self.execute(EmployeesQueryBuilderService().generate_query(participant))
        self.commit()

    def generate_clients_records(self):
        client = self.OBJECT_TYPES.index("client")
        for participant in self.participant_ids_with_name(client).fetchall():
            self.execute(ClientsQueryBuilderService().generate_query(participant))
        self.commit()

    def generate_projects_records(self, n):
        for _ in range(n):
            self.execute(ProjectsQueryBuilderService().generate_query(self.employee_ids(), self.client_ids()))
        self.commit()

    def generate_cashboxes_records(self):
        cash = self.OBJECT_TYPES.index("cash")
        for participant in self.participant_ids(cash):
            self.execute(CashboxesQueryBuilderService().generate_query(participant, self.account_type_ids()))
        self.commit()

    def generate_payments_records(self, n):
        for _ in range(n):
            self.execute(PaymentsQueryBuilderService().generate_query(self.category_ids(), self.participant_ids(), self.project_ids()))
        self.commit()

    def generate_banks_records(self):
        bank = self.OBJECT_TYPES.index("cashless")
        for participant in self.participant_ids(bank):
            self.execute(BanksQueryBuilderService().generate_query(participant, self.account_type_ids()))
        self.commit()

    def clean_table(self, table):
        self.execute(f"DELETE FROM [dbo].[{table}]")
        self.commit()

    def clean_all_tables(self):
        tables = ["Bank", "Payment", "Cashbox", "Project", "Client",
                  "Employee", "Supplier", "PaymentParticipant"]
        for table in tables:
            self.execute(f"DELETE FROM [dbo].[{table}]")
        self.commit()

    def account_type_ids(self):
        return [account_type[0] for account_type in self.execute("SELECT Oid FROM [dbo].[AccountType]")]

    def category_ids(self):
        return [category[0] for category in self.execute("SELECT Oid FROM [dbo].[PaymentCategory]")]

    def client_ids(self):
        return [client[0] for client in self.execute("SELECT Oid FROM [dbo].[Client]")]

    def employee_ids(self):
        return [employee[0] for employee in self.execute("SELECT Oid FROM [dbo].[Employee]")]

    def participant_ids(self, object_type = None):
        if object_type == None:
            return [participant[0] for participant in self.execute("SELECT Oid FROM [dbo].[PaymentParticipant]")]
        else: 
            return [participant[0] for participant in self.execute(f"SELECT Oid FROM [dbo].[PaymentParticipant] WHERE ObjectType = {object_type}")]

    def participant_ids_with_name(self, object_type = None):
        return [participant for participant in  self.execute(f"SELECT Oid, Name FROM [dbo].[PaymentParticipant] WHERE ObjectType = {object_type}")]

    def project_ids(self):
        return [project[0] for project in self.execute("SELECT Oid FROM [dbo].[Project]")]

    def payment_ids(self):
        return [payment[0] for payment in  self.execute("SELECT Oid FROM [dbo].[Payment]")]

    def bank_ids(self):
        return [payment[0] for payment in  self.execute("SELECT Oid FROM [dbo].[Bank]")]

    def cashbox_ids(self):
        return  [cashbox[0] for cashbox in self.execute("SELECT Oid FROM [dbo].[Cashbox]")]

    def supplier_ids(self):
        return  [supplier[0] for supplier in self.execute("SELECT Oid FROM [dbo].[Supplier]")]
