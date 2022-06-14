'''TODO: doc 🔫, logging'''
import os
import pymssql
from dotenv import load_dotenv

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


def get_new_oid(con):
    db_cursor = con.cursor()
    db_cursor.execute('SELECT NEWID()')
    return db_cursor.fetchone()[0]


def insert_participant(con, oid, balance, number, object_type):
    db_cursor = con.cursor()
    query_format = """INSERT INTO [dbo].[PaymentParticipant]
        VALUES ('%s', %d, '%s', %d, Null, %d, '%s', '%s', '%s', %d, %d)"""
    values = (oid, balance, f'Participant Test Name {number}', 0, object_type,
              '2020-01-01 00:00:00.000', '2022-01-01 00:00:00.000',
              f'Test Details {number}', 0, 0)
    db_cursor.execute(query_format % values)
    con.commit()


def setup_participants(con, balances):
    oids = {
        'bank': get_new_oid(con),
        'cashbox': get_new_oid(con),
        'client': get_new_oid(con),
        'supplier': get_new_oid(con),
        'manager': get_new_oid(con),
        'foreman': get_new_oid(con),
    }

    db_cursor = con.cursor()

    insert_participant(con, oids['bank'], balances[0], 0, 0)
    query_format = "INSERT INTO [dbo].[Bank] VALUES ('%s', '%s')"
    values = (oids['bank'], TYPES_OIDS['account_types']['advance'])
    db_cursor.execute(query_format % values)

    insert_participant(con, oids['cashbox'], balances[1], 1, 1)
    query_format = "INSERT INTO [dbo].[Cashbox] VALUES ('%s', '%s')"
    values = (oids['cashbox'], TYPES_OIDS['account_types']['material'])
    db_cursor.execute(query_format % values)

    insert_participant(con, oids['client'], balances[2], 2, 3)
    query_format = "INSERT INTO [dbo].[Client] VALUES ('%s', '%s', '%s', '%s')"
    values = (oids['client'], 'TestFirstName', 'TestSurname', '(465)584-3077')
    db_cursor.execute(query_format % values)

    insert_participant(con, oids['supplier'], balances[3], 3, 4)
    query_format = "INSERT INTO [dbo].[Supplier] VALUES ('%s', '%s', %d, %d, %d)"
    values = (oids['supplier'], 'Test Contact', 0, 0, 0)
    db_cursor.execute(query_format % values)

    insert_participant(con, oids['manager'], balances[4], 4, 2)
    query_format = """INSERT INTO [dbo].[Employee] VALUES ('%s', '%s', '%s',
        %d, %d, '%s', %d, Null, '%s')"""
    values = (oids['manager'], '2021-02-01 00:00:00.000', 'TestSurname', 0, 0,
              'TestPatronymic', 0, 'TestValue')
    db_cursor.execute(query_format % values)

    insert_participant(con, oids['foreman'], balances[5], 5, 2)
    query_format = """INSERT INTO [dbo].[Employee] VALUES ('%s', '%s', '%s',
        %d, %d, '%s', %d, Null, '%s')"""
    values = (oids['foreman'], '2021-02-01 00:00:00.000', 'TestSurname', 0, 0,
              'TestPatronymic', 0, 'TestValue')
    db_cursor.execute(query_format % values)

    con.commit()
    return oids


def setup_project(con, participants_oids):
    project_oid = get_new_oid(con)
    query_format = """INSERT INTO [dbo].[Project]
        VALUES ('%s', '%s', '%s', '%s', '%s', '%s', %d, Null, %d, %d, %d, '%s',
        %d, '%s', %d, %d, %d, %d, '%s', '%s', %d)"""
    values = (project_oid, 'Test Project Name', 'Test Address',
              participants_oids['client'], participants_oids['manager'],
              participants_oids['foreman'], 0, 0, 0, 0,
              '2021-01-01 00:00:00.000', 0, '2021-02-01 00:00:00.000', 0, 0, 0,
              0, 'Test Task', 'Test Request Task', 0)
    db_cursor = con.cursor()
    db_cursor.execute(query_format % values)

    con.commit()
    return project_oid


def show_balances(con, oids):
    balances = {}
    db_cursor = con.cursor()

    for key in oids.keys():
        query = """SELECT Balance FROM [dbo].[PaymentParticipant]
            WHERE Oid = '%s'"""
        db_cursor.execute(query % oids[key])
        balances[key] = db_cursor.fetchone()[0]

    print(balances)


def get_balances(con, oids):
    balances = []
    db_cursor = con.cursor()

    for key in oids.keys():
        query = """SELECT Balance FROM [dbo].[PaymentParticipant]
            WHERE Oid = '%s'"""
        db_cursor.execute(query % oids[key])
        balances.append(db_cursor.fetchone()[0])

    return balances


def test_balance(con, opening_balances, closing_balances):
    # setup participants
    participants_oids = setup_participants(con, opening_balances)
    project_oid = setup_project(con, participants_oids)

    db_cursor = con.cursor()
    query_format = """INSERT INTO [dbo].[Payment] VALUES (NEWID(), %d, '%s',
        '%s', '%s', '%s', '%s', '%s', '%s', %d, Null, '%s', '%s', %d, '%s')"""
    show_balances(con, participants_oids)

    # TODO: make_payment()
    # 1st payment
    values = (400000, TYPES_OIDS['payments_types']['advance_for_materials'],
              project_oid, 'Test Text', 'Test Text', '2021-01-02 00:00:00.000',
              participants_oids['bank'], participants_oids['supplier'], 0,
              '2021-01-02 00:00:00.000', 0, 0, 0)
    db_cursor.execute(query_format % values)
    show_balances(con, participants_oids)
    # 2nd payment
    values = (100000, TYPES_OIDS['payments_types']['purchase_of_materials'],
              project_oid, 'Test Text', 'Test Text', '2021-01-03 00:00:00.000',
              participants_oids['supplier'], participants_oids['client'], 0,
              '2021-01-03 00:00:00.000', 0, 0, 0)
    db_cursor.execute(query_format % values)
    show_balances(con, participants_oids)
    # 3rd payment
    values = (150000, TYPES_OIDS['payments_types']['purchase_of_materials'],
              project_oid, 'Test Text', 'Test Text', '2021-01-04 00:00:00.000',
              participants_oids['client'], participants_oids['cashbox'], 0,
              '2021-01-04 00:00:00.000', 0, 0, 0)
    db_cursor.execute(query_format % values)
    show_balances(con, participants_oids)
    # 4th payment
    values = (100000, TYPES_OIDS['payments_types']['repayment_of_credit'],
              project_oid, 'Test Text', 'Test Text', '2021-01-05 00:00:00.000',
              participants_oids['cashbox'], participants_oids['bank'], 0,
              '2021-01-05 00:00:00.000', 0, 0, 0)
    db_cursor.execute(query_format % values)
    show_balances(con, participants_oids)

    con.commit()

    assert closing_balances == get_balances(con, participants_oids)


if __name__ == '__main__':
    load_dotenv()

    server = os.getenv('MSSQL_SERVER', '.')
    database = os.getenv('MSSQL_DATABASE', 'PaymentData')
    user = os.getenv('MSSQL_USER', 'user')
    password = os.getenv('MSSQL_PASSWORD', 'password')

    db_connection = pymssql.connect(
        server=server,
        user=user,
        password=password,
        database=database,
    )

    opening_balances = [0, 0, 0, 0, 0, 0]
    closing_balances = [-300000, 50000, -50000, 300000, 0, 0]
    test_balance(db_connection, opening_balances, closing_balances)

    db_connection.close()
