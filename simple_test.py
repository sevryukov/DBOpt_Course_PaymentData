'''testing balance calculation'''
import os
import unittest
import logging

import pymssql
from dotenv import load_dotenv

# load env variables
load_dotenv()

# constants
TYPES_OIDS = {
    'account_types': {
        'advance': '2126ef07-0276-4440-b71c-c353516a0946',
        'material': 'f35c264e-9c7f-449b-ba68-f4e71f71e97e',
        'current': 'a126415b-734d-4d05-bf68-f888d680c5ba',
    },
    'payments_types': {
        'advance_for_materials': 'f0f25486-f0e2-4c0a-99d3-068508d13eaf',
        'advance_payments': '700ab7dd-72ae-4f01-a7e2-1dbc341ed4c2',
        'purchase_of_materials': '951faee9-8883-4aef-8cb2-11aac0a245e0',
        'repayment_of_credit': 'ac03d0b4-8060-4e8d-bef2-6b2382500dd0',
    },
}
LOG_LEVEL = logging.DEBUG
SERVER = os.getenv('MSSQL_SERVER', '.')
DATABASE = os.getenv('MSSQL_DATABASE', 'PaymentData')
USER = os.getenv('MSSQL_USER', 'user')
PASSWORD = os.getenv('MSSQL_PASSWORD', 'password')

# setting up logger
logging.basicConfig(
    filename='test_balance.log',
    filemode='w',
    format='%(asctime)s,%(msecs)d %(levelname)s %(message)s',
    datefmt='%H:%M:%S',
    level=LOG_LEVEL,
)
logger = logging.getLogger()


def get_new_oid(conn):
    '''generate new id for object'''
    db_cursor = conn.cursor()
    db_cursor.execute('SELECT NEWID()')
    return db_cursor.fetchone()[0]


def insert_participant(conn, oid, number, object_type):
    '''insert test participant into database'''
    db_cursor = conn.cursor()
    query_format = """INSERT INTO [dbo].[PaymentParticipant]
        VALUES ('%s', %d, '%s', %d, Null, %d, '%s', '%s', '%s', %d, %d)"""
    values = (oid, 0, f'Participant Test Name {number}', 0, object_type,
              '2020-01-01 00:00:00.000', '2022-01-01 00:00:00.000',
              f'Test Details {number}', 0, 0)
    db_cursor.execute(query_format % values)
    # conn.commit()


def setup_participants(conn):
    '''insert test participants and participants info into database'''
    participants_oids = {
        'bank': get_new_oid(conn),
        'cashbox': get_new_oid(conn),
        'client': get_new_oid(conn),
        'supplier': get_new_oid(conn),
        'manager': get_new_oid(conn),
        'foreman': get_new_oid(conn),
    }

    db_cursor = conn.cursor()

    insert_participant(conn, participants_oids['bank'], 0, 0)
    query_format = "INSERT INTO [dbo].[Bank] VALUES ('%s', '%s')"
    values = (participants_oids['bank'],
              TYPES_OIDS['account_types']['advance'])
    db_cursor.execute(query_format % values)

    insert_participant(conn, participants_oids['cashbox'], 1, 1)
    query_format = "INSERT INTO [dbo].[Cashbox] VALUES ('%s', '%s')"
    values = (participants_oids['cashbox'],
              TYPES_OIDS['account_types']['material'])
    db_cursor.execute(query_format % values)

    insert_participant(conn, participants_oids['client'], 2, 3)
    query_format = "INSERT INTO [dbo].[Client] VALUES ('%s', '%s', '%s', '%s')"
    values = (participants_oids['client'], 'TestFirstName', 'TestSurname',
              '(465)584-3077')
    db_cursor.execute(query_format % values)

    insert_participant(conn, participants_oids['supplier'], 3, 4)
    query_format = """INSERT INTO [dbo].[Supplier]
        VALUES ('%s', '%s', %d, %d, %d)"""
    values = (participants_oids['supplier'], 'Test Contact', 0, 0, 0)
    db_cursor.execute(query_format % values)

    insert_participant(conn, participants_oids['manager'], 4, 2)
    query_format = """INSERT INTO [dbo].[Employee]
        VALUES ('%s', '%s', '%s', %d, %d, '%s', %d, Null, '%s')"""
    values = (participants_oids['manager'], '2021-02-01 00:00:00.000',
              'TestSurname', 0, 0, 'TestPatronymic', 0, 'TestValue')
    db_cursor.execute(query_format % values)

    insert_participant(conn, participants_oids['foreman'], 5, 2)
    query_format = """INSERT INTO [dbo].[Employee]
        VALUES ('%s', '%s', '%s', %d, %d, '%s', %d, Null, '%s')"""
    values = (participants_oids['foreman'], '2021-02-01 00:00:00.000',
              'TestSurname', 0, 0, 'TestPatronymic', 0, 'TestValue')
    db_cursor.execute(query_format % values)

    # conn.commit()
    return participants_oids


def setup_project(conn, participants_oids):
    '''insert test project into database'''
    project_oid = get_new_oid(conn)
    query_format = """INSERT INTO [dbo].[Project]
        VALUES ('%s', '%s', '%s', '%s', '%s', '%s', %d, Null, %d, %d, %d, '%s',
        %d, '%s', %d, %d, %d, %d, '%s', '%s', %d)"""
    values = (project_oid, 'Test Project Name', 'Test Address',
              participants_oids['client'], participants_oids['manager'],
              participants_oids['foreman'], 0, 0, 0, 0,
              '2021-01-01 00:00:00.000', 0, '2021-02-01 00:00:00.000', 0, 0, 0,
              0, 'Test Task', 'Test Request Task', 0)
    db_cursor = conn.cursor()
    db_cursor.execute(query_format % values)

    # conn.commit()
    return project_oid


def make_payment(conn, amount, category_oid, project_oid, date, payer_oid,
                 payee_oid):
    '''insert test payment into database'''
    payment_oid = get_new_oid(conn)
    query_format = """INSERT INTO [dbo].[Payment] VALUES ('%s', %d, '%s',
        '%s', '%s', '%s', '%s', '%s', '%s', %d, Null, '%s', '%s', %d, '%s')"""
    values = (payment_oid, amount, category_oid, project_oid, 'Test Text',
              'Test Text', date, payer_oid, payee_oid, 0, date, 0, 0, 0)
    db_cursor = conn.cursor()
    db_cursor.execute(query_format % values)

    # conn.commit()
    return payment_oid


def show_balances(conn, oids):
    '''print balances of participants'''
    balances = {}
    db_cursor = conn.cursor()

    for key in oids.keys():
        query = """SELECT Balance FROM [dbo].[PaymentParticipant]
            WHERE Oid = '%s'"""
        db_cursor.execute(query % oids[key])
        balances[key] = db_cursor.fetchone()[0]

    logger.info(balances)


def get_balances(conn, oids):
    '''return a list of participants balances'''
    balances = []
    db_cursor = conn.cursor()

    for key in oids.keys():
        query = """SELECT Balance FROM [dbo].[PaymentParticipant]
            WHERE Oid = '%s'"""
        db_cursor.execute(query % oids[key])
        balances.append(db_cursor.fetchone()[0])

    return balances


def calculate_balances(conn, payments_amounts):
    '''
    setup test participants and return their balances
    after multiple payments
    '''
    logger.info('Start of a new payment group')

    # setup participants and project
    participants_oids = setup_participants(conn)
    project_oid = setup_project(conn, participants_oids)

    # check opening balances of participants
    show_balances(conn, participants_oids)
    # 1st payment
    make_payment(conn, payments_amounts[0],
                 TYPES_OIDS['payments_types']['advance_for_materials'],
                 project_oid, '2021-01-02 00:00:00.000',
                 participants_oids['bank'], participants_oids['supplier'])
    show_balances(conn, participants_oids)
    # 2nd payment
    make_payment(conn, payments_amounts[1],
                 TYPES_OIDS['payments_types']['purchase_of_materials'],
                 project_oid, '2021-01-03 00:00:00.000',
                 participants_oids['supplier'], participants_oids['client'])
    show_balances(conn, participants_oids)
    # 3rd payment
    make_payment(conn, payments_amounts[2],
                 TYPES_OIDS['payments_types']['purchase_of_materials'],
                 project_oid, '2021-01-04 00:00:00.000',
                 participants_oids['client'], participants_oids['cashbox'])
    show_balances(conn, participants_oids)
    # 4th payment
    make_payment(conn, payments_amounts[3],
                 TYPES_OIDS['payments_types']['repayment_of_credit'],
                 project_oid, '2021-01-05 00:00:00.000',
                 participants_oids['cashbox'], participants_oids['bank'])
    show_balances(conn, participants_oids)

    return get_balances(conn, participants_oids)


class TestBalance(unittest.TestCase):
    '''simple balance tests'''

    def setUp(self):
        self.db_connection = pymssql.connect(
            server=SERVER,
            user=USER,
            password=PASSWORD,
            database=DATABASE,
        )

        self.test_balance_data = [
            {
                'closing_balances': [-300000, 50000, -50000, 300000, 0, 0],
                'payments_amounts': [400000, 100000, 150000, 100000],
            },
            {
                'closing_balances': [0, 0, 0, 0, 0, 0],
                'payments_amounts': [100000, 100000, 100000, 100000],
            },
        ]

    def tearDown(self):
        if self.db_connection:
            # rollback changes
            self.db_connection.rollback()
            # close connection
            self.db_connection.close()

    def test_balance(self):
        '''make payments and check balances'''
        for data in self.test_balance_data:
            balances = calculate_balances(
                conn=self.db_connection,
                payments_amounts=data['payments_amounts'],
            )

            self.assertListEqual(balances, data['closing_balances'])


if __name__ == '__main__':
    unittest.main()
