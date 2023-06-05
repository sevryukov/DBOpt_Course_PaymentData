import time
from contextlib import closing

import pandas as pd
import pymssql

import datetime
import random
import names


class BaseMSSQLConnector:
    def __init__(self, server: str, database: str, user: str, password: str):
        self.server = server
        self.database = database
        self.user = user
        self.password = password

    def get_conn(self):
        conn = pymssql.connect(
            server=self.server,
            database=self.database,
            user=self.user,
            password=self.password
        )
        return conn

    def execute(self, sql: str):
        with closing(self.get_conn()) as conn:
            with closing(conn.cursor()) as cur:
                cur.execute(sql)
            conn.commit()

    def get_df(self, sql: str, as_dict: bool = False):

        with closing(self.get_conn()) as conn:
            with closing(conn.cursor(as_dict=as_dict)) as cur:
                cur.execute(sql)
                data = cur.fetchall()
                return pd.DataFrame(data)


class MSSQLPaymentDataGenerator(BaseMSSQLConnector):
    PARTICIPANTS_CNT = 500
    PARTICIPANT_IDS = {
        'bank': 0,
        'cashbox': 1,
        'employee': 2,
        'client': 3,
        'supplier': 4
    }
    PROJECTS_CNT = 40
    PAYMENTS_CNT = 10000

    def random_date(self, start_date: str = None):
        if start_date:
            start_date = datetime.datetime.strptime(start_date, '%Y-%m-%d')
            end_date = start_date + datetime.timedelta(days=random.randint(10, 400))
            return str(end_date.date())
        else:
            date = datetime.date(2000, 1, 1) + datetime.timedelta(days=random.randint(50, 100))
            return str(date)

    def random_date_interval(self):
        start_date = self.random_date()
        end_date = self.random_date(start_date)
        return [start_date, end_date]

    def random_name(self):
        return names.get_full_name()

    def random_object_type(self):
        return random.randint(0, 4)

    def random_bank_details(self):
        details = ''
        for i in range(4):
            details += chr(random.randint(65, 90))
        details += str(random.randint(10000000000000, 99999999999999))
        return details

    def random_phone(self):
        phone = '+79'
        phone += str(random.randint(100000000, 999999999))
        return phone

    def random_text(self, length):
        text = chr(random.randint(65, 90))
        while length > len(text):
            word = ''
            word_len = random.randint(4, 12)
            for i in range(word_len):
                word += chr(random.randint(97, 122))
            text += word + ' '
        return text[:length]

    def random_address(self):
        return self.random_text(random.randint(10, 20)) + ' ' + str(random.randint(1, 200))

    def insert_many(self, sql: str, values: list):
        with closing(self.get_conn()) as conn:
            with closing(conn.cursor()) as cur:
                cur.executemany(sql, values)
            conn.commit()

    def generate_payment_participants(self):
        values = []
        for i in range(self.PARTICIPANTS_CNT):

            activity_interval = self.random_date_interval()
            values.append(
                (
                    self.random_name(),
                    self.random_object_type(),
                    activity_interval[0],
                    activity_interval[1],
                    self.random_bank_details()
                )
            )
        sql = """INSERT INTO [dbo].[PaymentParticipant] VALUES (NEWID(), 0, %s, Null, Null, %d, %s, %s, %s, 0, 0)"""
        self.insert_many(sql, values)

    def get_participant_data(self, participant, data):
        oids = self.get_df(
            f'SELECT {data} FROM [dbo].[PaymentParticipant] WHERE ObjectType = {self.PARTICIPANT_IDS.get(participant)}',
            True
        )
        return oids

    def fill_banks(self):
        account_type_oids = self.get_df('SELECT oid FROM [dbo].[AccountType]', True)
        values = []
        bank_oids = self.get_participant_data("bank", "Oid")
        for oid in bank_oids['Oid']:
            values.append((oid, random.choice(account_type_oids['oid'])))
        sql = 'INSERT INTO [dbo].[Bank] VALUES (%s, %s)'
        self.insert_many(sql, values)

    def fill_cashboxes(self):
        account_type_oids = self.get_df('SELECT oid FROM [dbo].[AccountType]', True)
        values = []
        cashbox_oids = self.get_participant_data("cashbox", "Oid")
        for oid in cashbox_oids['Oid']:
            values.append((oid, random.choice(account_type_oids['oid'])))
        sql = 'INSERT INTO [dbo].[Cashbox] VALUES (%s, %s)'
        self.insert_many(sql, values)

    def fill_clients(self):
        values = []
        clients = self.get_participant_data("client", "Oid, Name")
        for i in range(len(clients)):
            name = clients['Name'][i].split(' ')
            values.append(
                (clients['Oid'][i], name[0], name[1], self.random_phone())
            )
        sql = 'INSERT INTO [dbo].[Client] VALUES (%s, %s, %s, %s)'
        self.insert_many(sql, values)

    def fill_employees(self):
        values = []
        employees = self.get_participant_data("employee", "Oid, Name")
        for i in range(len(employees)):
            name = employees['Name'][i].split(' ')
            values.append(
                (
                    employees['Oid'][i],
                    self.random_date(),
                    name[1],
                    random.randint(3000, 10000),
                    random.randint(3, 12) * 100,
                    name[0],
                    random.randint(1, 1000),
                    self.random_text(50)
                )
            )
        sql = 'INSERT INTO [dbo].[Employee] VALUES (%s, %s, %s, %d, %d, %s, %d, Null, %s)'
        self.insert_many(sql, values)

    def fill_suppliers(self):
        values = []
        suppliers = self.get_participant_data("supplier", "Oid, Name")
        for i in range(len(suppliers)):
            values.append(
                (
                    suppliers['Oid'][i],
                    suppliers['Name'][i],
                    random.randint(0, 1),
                    random.randint(0, 1),
                    random.randint(0, 1)
                )
            )
        sql = 'INSERT INTO [dbo].[Supplier] VALUES (%s, %s, %d, %d, %d)'
        self.insert_many(sql, values)

    def generate_projects(self):
        values = []
        clients = self.get_participant_data("client", "Oid")["Oid"].values
        employees = self.get_participant_data("employee", "Oid")["Oid"].values
        for i in range(self.PROJECTS_CNT):
            date_interval = self.random_date_interval()
            manager = random.choice(employees)
            foreman = random.choice(employees)
            while foreman == manager:
                foreman = random.choice(employees)
            values.append(
                (
                    names.get_last_name(),
                    self.random_address(),
                    random.choice(clients),
                    manager,
                    foreman,
                    0,
                    0,
                    0,
                    date_interval[0],
                    random.randint(0, 5),
                    date_interval[1],
                    random.randint(1, 100),
                    random.randint(1000, 10000),
                    random.randint(100, 1000),
                    0,
                    self.random_text(50),
                    self.random_text(50),
                    random.randint(0, 1)
                )
            )
        sql = 'INSERT INTO [dbo].[Project] VALUES (NEWID(), %s, %s, %s, %s, %s, Null, Null, %d, %d, %d, %s, %d, ' \
              '%s, %d, %d, %d, %d, %s, %s, %d)'
        self.insert_many(sql, values)

    def generate_payments(self, non_default_cnt: int = None, enable_log: bool = False):
        values = []
        categories = self.get_df('SELECT oid FROM [dbo].[PaymentCategory]', True)['oid'].values
        participants = self.get_df('SELECT oid FROM [dbo].[PaymentParticipant]', True)['oid'].values
        projects = self.get_df('SELECT oid FROM [dbo].[Project]', True)['oid'].values
        info = 10
        count = non_default_cnt if non_default_cnt is not None else self.PAYMENTS_CNT
        for i in range(count):
            if enable_log and i / count * 100 > info:
                print(f'Prepared {info}% payments')
                info += 10

            payer = random.choice(participants)
            payee = random.choice(participants)
            while payee == payer:
                payee = random.choice(participants)
            values.append(
                (
                    random.randint(3, 1000) * 100,
                    random.choice(categories),
                    random.choice(projects),
                    self.random_text(50),
                    self.random_text(50),
                    self.random_date(),
                    payer,
                    payee,
                    str(datetime.datetime.now().date()),
                    random.randint(1000, 10000),
                    random.randint(0, 1),
                    random.randint(1000, 10000)
                )
            )
        if enable_log:
            print('Prepared all payments')
        sql = 'INSERT INTO [dbo].[Payment] VALUES (NEWID(), %d, %s, %s, %s, %s, %s, %s, %s, Null, Null, %s, %s, %d, %s)'
        self.insert_many(sql, values)

    def generate_data(self):
        self.generate_payment_participants()
        self.fill_banks()
        self.fill_cashboxes()
        self.fill_clients()
        self.fill_employees()
        self.fill_suppliers()
        self.generate_projects()
        self.generate_payments()

    def get_balance(self, oid):
        return self.get_df(f"SELECT Balance FROM [dbo].[PaymentParticipant] WHERE Oid = '{oid}'")[0][0]

    def prepare_test(self):
        values = []
        bank = self.get_df("""
        SELECT TOP 1 pp.Oid 
        FROM [PaymentParticipant] pp
        JOIN [Bank] b 
            ON pp.Oid = b.Oid
        WHERE pp.ObjectType = 0 AND b.AccountType = '2126EF07-0276-4440-B71C-C353516A0946'
        """)[0][0]

        cashbox = self.get_df("""
        SELECT TOP 1 pp.Oid 
        FROM [PaymentParticipant] pp
        JOIN [Bank] b 
            ON pp.Oid = b.Oid
        WHERE pp.ObjectType = 1 AND b.AccountType = 'A126415B-734D-4D05-BF68-F888D680C5BA'
        """)[0][0]

        manager, foreman = self.get_df("""
        SELECT TOP 2 pp.Oid 
        FROM [PaymentParticipant] pp
        WHERE pp.ObjectType = 2
        """)[0]

        client = self.get_df("""
        SELECT TOP 1 pp.Oid 
        FROM [PaymentParticipant] pp
        WHERE pp.ObjectType = 3
        """)[0][0]

        supplier = self.get_df("""
        SELECT TOP 1 pp.Oid 
        FROM [PaymentParticipant] pp
        WHERE pp.ObjectType = 4
        """)[0][0]

        project = self.get_df("""SELECT NEWID()""")[0][0]

        date_interval = self.random_date_interval()
        values.append(
            (
                project,
                'Test Project',
                'Test St. 152',
                client,
                manager,
                foreman,
                0,
                0,
                0,
                date_interval[0],
                random.randint(0, 5),
                date_interval[1],
                random.randint(1, 100),
                random.randint(1000, 10000),
                random.randint(100, 1000),
                0,
                self.random_text(50),
                self.random_text(50),
                random.randint(0, 1)
            )
        )

        sql = 'INSERT INTO [dbo].[Project] VALUES (%s, %s, %s, %s, %s, %s, Null, Null, %d, %d, %d, %s, %d, ' \
              '%s, %d, %d, %d, %d, %s, %s, %d)'
        self.insert_many(sql, values)
        oids = {
            'bank': bank,
            'cashbox': cashbox,
            'manager': manager,
            'foreman': foreman,
            'client': client,
            'supplier': supplier,
            'project': project
        }
        return oids

    def make_test_payment(self, payment_data):
        values = []
        for payment in payment_data:
            amount, category, project, payer, payee = payment
            values.append(
                (
                    amount,
                    category,
                    project,
                    self.random_text(50),
                    self.random_text(50),
                    self.random_date(),
                    payer,
                    payee,
                    str(datetime.datetime.now().date()),
                    random.randint(1000, 10000),
                    random.randint(0, 1),
                    random.randint(1000, 10000)
                )
            )
        sql = 'INSERT INTO [dbo].[Payment] VALUES (NEWID(), %d, %s, %s, %s, %s, %s, %s, %s, Null, Null, %s, %s, %d, %s)'
        self.insert_many(sql, values)

    def get_all_balances(self, oids):
        balances = {}
        for participant in oids:
            if participant != 'project':
                balance = self.get_balance(oids.get(participant))
                balances.update({participant: balance})
        return balances

    def get_balance_diff(self, old_balances, new_balances):
        for participant in old_balances:
            new_balance = new_balances.get(participant)
            old_balance = old_balances.get(participant)
            print(f'{participant}: Old balance: {old_balance}; New balance: {new_balance}; ' +
                  f'Diff: {new_balance - old_balance}')
        print('\n')

    def test_balance(self):
        oids = self.prepare_test()
        balances = self.get_all_balances(oids)
        print('Initial balances')
        for participant in oids:
            print(f'{participant} balance: {balances.get(participant)}')
        print('\n')

        # amount, category, project, payer, payee
        payments = [
            (400000, 'F0F25486-F0E2-4C0A-99D3-068508D13EAF', oids.get('project'), oids.get('bank'),
                oids.get('supplier')),
            (100000, '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0', oids.get('project'), oids.get('supplier'),
             oids.get('client')),
            (150000, '951FAEE9-8883-4AEF-8CB2-11AAC0A245E0', oids.get('project'), oids.get('client'),
             oids.get('cashbox')),
            (100000, 'AC03D0B4-8060-4E8D-BEF2-6B2382500DD0', oids.get('project'), oids.get('cashbox'),
             oids.get('bank')),
        ]

        for i, payment in enumerate(payments):
            print(f'Payment #{i+1}')
            self.make_test_payment([payment])
            new_balances = self.get_all_balances(oids)
            self.get_balance_diff(balances, new_balances)

    def get_payments_insert_timing(self, non_default_cnt: int = None):
        start = time.perf_counter()
        self.generate_payments(non_default_cnt)
        end = time.perf_counter()
        return end - start

    def test_insert_payments(self, tests_cnt, sample_size):
        res = 0
        for i in range(tests_cnt):
            res += mssql.get_payments_insert_timing(sample_size)
        res /= tests_cnt
        print(f'Avg. elapsed time: {res:0.4f} seconds')

    def create_indexes(self):
        self.execute('CREATE UNIQUE INDEX i1 ON [dbo].[Payment] (Oid, Payer, Amount)')
        self.execute('CREATE UNIQUE INDEX i2 ON [dbo].[Payment] (Oid, Payee, Amount)')
        self.execute('CREATE UNIQUE INDEX i3 ON [dbo].[PaymentParticipant] (Oid)')

    def drop_index(self, index_name):
        self.execute(f'DROP INDEX IF EXISTS {index_name} ON [dbo].[Payment]')
        self.execute(f'DROP INDEX IF EXISTS {index_name} ON [dbo].[PaymentParticipant]')

    def test_index(self, tests_cnt, sample_size):
        indexes = ['i1', 'i2', 'i3']
        for index in indexes:
            self.drop_index(index)
        self.test_insert_payments(tests_cnt, sample_size)
        self.create_indexes()
        self.test_insert_payments(tests_cnt, sample_size)


mssql = MSSQLPaymentDataGenerator('DESKTOP-HKOSUQT', 'PaymentData', 'sa', 'RPSsql12345')
mssql.generate_data()
mssql.test_balance()
mssql.test_index(tests_cnt=50, sample_size=10)
