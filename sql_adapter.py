import datetime
import random

import pyodbc
from faker import Faker


class SQLAdapter:
    MIN_AMOUNT = 1
    MAX_AMOUNT = 100000
    START_DATE = datetime.datetime(2010, 1, 1)
    END_DATE = datetime.datetime.now()

    OBJECT_TYPES = ["cashless", "cash", "client", "employee", "supplier"]

    def __init__(self, driver, database, server, user, password):
        self._connection = pyodbc.connect(
            f"DRIVER={driver};DATABASE={database};SERVER={server};UID={user};PWD={password}"
        )
        self._cursor = self._connection.cursor()
        self._faker = Faker()

    @property
    def execute(self):
        return self._cursor.execute

    @property
    def commit(self):
        return self._connection.commit

    @staticmethod
    def _generate_date(start, end):
        return datetime.datetime.fromtimestamp(
            random.randint(int(start.timestamp()), int(end.timestamp()))
        )

    def generate_payment_participants(self, n):
        for _ in range(n):
            balance = 0
            balance2 = 0
            balance3 = 0
            name = self._faker.name()
            optimistic_lock_field = random.randint(1, 3)
            object_type = random.randint(0, 4)
            bank_details = self._faker.bban()
            active_from = self._generate_date(self.START_DATE, self.END_DATE)
            inactive_from = self._generate_date(active_from, self.END_DATE)
            active_from = active_from.isoformat()
            inactive_from = inactive_from.isoformat()

            query = f"""INSERT INTO [dbo].[PaymentParticipant] ([Oid], [Balance], [Name], [OptimisticLockField], [GCRecord], 
                       [ObjectType], [ActiveFrom], [InactiveFrom], [BankDetails], [Balance2], [Balance3]) 
                       VALUES (NEWID(), {balance}, '{name}', {optimistic_lock_field}, Null, {object_type}, '{active_from}',
                       '{inactive_from}', '{bank_details}', {balance2}, {balance3})"""

            self.execute(query)
            self.commit()

    def generate_suppliers(self):
        supplier = self.OBJECT_TYPES.index("supplier")
        participants = self.execute(
            f"SELECT Oid, Name FROM [dbo].[PaymentParticipant] WHERE ObjectType = {supplier}"
        )
        for participant in participants.fetchall():
            oid, contact = participant
            query = f"""INSERT INTO [dbo].[Supplier] ([Oid], [Contact], [ProfitByMaterialAsPayer], [ProfitByMaterialAsPayee], [CostByMaterialAsPayer])
                       VALUES ('{oid}', '{contact}', {random.randint(0, 1)}, {random.randint(0, 1)}, {random.randint(0, 1)})"""
            self.execute(query)
        self.commit()

    def generate_employees(self):
        employee = self.OBJECT_TYPES.index("employee")
        participants = self.execute(
            f"SELECT Oid, Name FROM [dbo].[PaymentParticipant] WHERE ObjectType = {employee}"
        )
        for participant in participants.fetchall():
            oid, name = participant
            first_name, second_name = name.split(maxsplit=1)
            busy_until = self._generate_date(self.START_DATE, self.END_DATE).isoformat()
            stuff = random.randint(0, 100000)
            hour_price = random.randint(100, 2000)
            plan_fix_id = random.randint(1, 10000)
            plan_fix_money_request_task = self._faker.text(100)

            query = f"""INSERT INTO [dbo].[Employee] ([Oid], [BusyUntil], [SecondName], [Stuff], [HourPrice], [Patronymic], 
                        [PlanfixId], [Head], [PlanfixMoneyRequestTask])
                        VALUES ('{oid}', '{busy_until}', '{second_name}', {stuff}, {hour_price}, '{first_name}',
                                 {plan_fix_id}, Null, '{plan_fix_money_request_task}')"""
            self.execute(query)
        self.commit()

    def generate_clients(self):
        client = self.OBJECT_TYPES.index("client")

        participants = self.execute(
            f"SELECT Oid, Name FROM [dbo].[PaymentParticipant] WHERE ObjectType = {client}"
        )
        for participant in participants.fetchall():
            oid, name = participant
            first_name, second_name = name.split(maxsplit=1)
            phone_number = self._faker.phone_number()
            query = f"""INSERT INTO [dbo].[Client] ([Oid], [FirstName], [SecondName], [Phone])
                       VALUES ('{oid}', '{first_name}', '{second_name}', '{phone_number}')"""
            self.execute(query)
        self.commit()

    def generate_projects(self, n):
        employees = [
            employee[0] for employee in self.execute("SELECT Oid FROM [dbo].[Employee]")
        ]
        clients = [
            client[0] for client in self.execute("SELECT Oid FROM [dbo].[Client]")
        ]
        for _ in range(n):
            manager, foreman = random.sample(employees, 2)
            client = random.choice(clients)
            name = self._faker.bs()
            address = self._faker.address()
            optimistic_lock_field = random.randint(1, 3)
            status = random.randint(0, 4)
            start_date = self._generate_date(self.START_DATE, self.END_DATE)
            finish_date = self._generate_date(
                start_date + datetime.timedelta(180),
                start_date + datetime.timedelta(3650),
            )
            start_date = start_date.isoformat()
            finish_date = finish_date.isoformat()
            area = random.randint(1, 1000000)
            work_price_rate = random.uniform(100, 100000000)
            workers_price_rate = random.uniform(100, 500000)

            plan_fix_work_task = self._faker.text(100)
            plan_fix_change_request_task = self._faker.text(100)
            use_analytics = random.randint(0, 1)

            balance = 0
            balance_by_material = 0
            balance_by_work = 0
            remainder_the_advance = 0

            query = f"""INSERT INTO [dbo].[Project] ([Oid], [Name], [Address], [Client], [Manager], [Foreman], [OptimisticLockField], [GCRecord], 
                       [Balance], [BalanceByMaterial], [BalanceByWork], [PlaningStartDate], [Status], [FinishDate], [Area], [WorkPriceRate],
                       [WorkersPriceRate], [RemainderTheAdvance], [PlanfixWorkTask], [PlanfixChangeRequestTask], [UseAnalytics]) 
                       VALUES (NEWID(), '{name}', '{address}', '{client}', '{manager}', '{foreman}', {optimistic_lock_field}, 
                               Null, {balance}, {balance_by_material}, {balance_by_work}, '{start_date}', {status}, '{finish_date}', 
                               {area}, {work_price_rate}, {workers_price_rate}, {remainder_the_advance}, '{plan_fix_work_task}', 
                               '{plan_fix_change_request_task}', {use_analytics})"""
            self.execute(query)
        self.commit()

    def generate_cashboxes(self):
        cash = self.OBJECT_TYPES.index("cash")
        account_types = [
            account[0]
            for account in self._cursor.execute("SELECT Oid FROM [dbo].[AccountType]")
        ]
        participants = self._cursor.execute(
            f"SELECT Oid FROM [dbo].[PaymentParticipant] WHERE ObjectType = {cash}"
        )
        for participant in participants.fetchall():
            account_type = random.choice(account_types)
            query = f"""INSERT INTO [dbo].[Cashbox] ([Oid], [AccountType]) VALUES ('{participant[0]}', '{account_type}')"""
            self.execute(query)
        self.commit()

    def generate_payments(self, n):
        categories = [
            category[0]
            for category in self._cursor.execute(
                "SELECT Oid FROM [dbo].[PaymentCategory]"
            )
        ]
        participants = [
            participant[0]
            for participant in self._cursor.execute(
                "SELECT Oid FROM [dbo].[PaymentParticipant]"
            )
        ]
        projects = [
            project[0]
            for project in self._cursor.execute("SELECT Oid FROM [dbo].[Project]")
        ]
        for _ in range(n):
            category = random.choice(categories)
            project = random.choice(projects)
            payee, payer = random.sample(participants, 2)
            amount = random.randint(self.MIN_AMOUNT, self.MAX_AMOUNT)
            justificaton = self._faker.text(30)
            comment = self._faker.text(100)
            optimistic_lock_field = random.randint(1, 3)
            check_number = random.randint(10000, 99999)
            number = random.randint(10000, 99999)

            date = self._generate_date(self.START_DATE, self.END_DATE).isoformat()
            created_date = datetime.datetime.fromtimestamp(
                int(datetime.datetime.now().timestamp())
            ).isoformat()
            query = f"""INSERT INTO [dbo].[Payment] ([Oid], [Amount], [Category], [Project], [Justification], [Comment], [Date], [Payer], [Payee],
                       [OptimisticLockField], [GCRecord], [CreateDate], [CheckNumber], [IsAuthorized], [Number]) 
                       VALUES (NEWID(), {amount}, '{category}', '{project}', '{justificaton}', '{comment}', '{date}', '{payer}', '{payee}', 
                       {optimistic_lock_field}, Null, '{created_date}', '{check_number}', {random.randint(0, 1)}, '{number}')"""
            self.execute(query)
        self.commit()

    def generate_banks(self):
        bank = self.OBJECT_TYPES.index("cashless")
        account_types = [
            account_type[0]
            for account_type in self._cursor.execute(
                "SELECT Oid FROM [dbo].[AccountType]"
            )
        ]
        participants = self._cursor.execute(
            f"SELECT Oid FROM [dbo].[PaymentParticipant] WHERE ObjectType = {bank}"
        )
        for participant in participants.fetchall():
            account_type = random.choice(account_types)
            oid = participant[0]
            query = f"""INSERT INTO [dbo].[Bank] ([Oid], [AccountType]) VALUES ('{oid}', '{account_type}')"""
            self.execute(query)
        self.commit()

    def clean_tables(self, tables=None):
        tables = tables or [
            "Bank",
            "Payment",
            "Cashbox",
            "Project",
            "Client",
            "Employee",
            "Supplier",
            "PaymentParticipant",
        ]
        for table in tables:
            self.execute(f"DELETE FROM [dbo].[{table}]")
        self.commit()

    def generate(self, n_participants, n_projects, n_payments):
        self.generate_payment_participants(n_participants)
        self.generate_suppliers()
        self.generate_employees()
        self.generate_clients()
        self.generate_projects(n_projects)
        self.generate_cashboxes()
        self.generate_banks()
        self.generate_payments(n_payments)
