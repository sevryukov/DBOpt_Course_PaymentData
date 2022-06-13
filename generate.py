'''fills database with fake data'''
import os
import argparse
from datetime import datetime
from random import randint, choice, sample, getrandbits
import pymssql
from faker import Faker
from dotenv import load_dotenv

financial_objects = {
    'bank': 0,
    'cashbox': 1,
    'employee': 2,
    'client': 3,
    'supplier': 4
}


def rand_datetime(start: datetime, end: datetime):
    '''returns random datetime inside given range'''
    istart = int(start.timestamp())
    iend = int(end.timestamp())
    return datetime.fromtimestamp(randint(istart, iend))


def get_oids_from(dbo_name: str, db_connection):
    '''retrieves ids from table'''
    db_cursor = db_connection.cursor()
    query = f'SELECT Oid FROM {dbo_name}'
    db_cursor.execute(query)
    return [row[0] for row in db_cursor.fetchall()]


def generate_participants(
    db_connection,
    faker: Faker,
    object_types: dict = financial_objects,
    count=1
):
    '''generates fake participants'''
    db_cursor = db_connection.cursor()

    now = datetime.now()

    date_format = '%Y-%m-%d %H:%M:%S'
    active_from_date = rand_datetime(
        datetime(1970, 1, 1), now,
    )
    inactive_from_date = rand_datetime(
        active_from_date, now,
    )

    values = [
        (
            0, faker.name(), 0, choice(list(object_types.values())),
            active_from_date.strftime(date_format),
            inactive_from_date.strftime(date_format),
            faker.iban(), 0, 0
        )
        for _ in range(count)
    ]
    query_format = '''INSERT INTO [dbo].[PaymentParticipant]
                    VALUES (NEWID(), %d, %s, %d, Null, %d, %s, %s, %s, %d, %d)'''
    db_cursor.executemany(query_format, values)
    db_connection.commit()


def setup_connection_through_account_type(
    target_table: str, db_connection,
    object_types: dict = financial_objects
):
    '''generates fake data for table with only oid and account type'''
    account_types = get_oids_from(
        dbo_name='[dbo].[AccountType]', db_connection=db_connection)

    db_cursor = db_connection.cursor()
    query = f'''SELECT Oid FROM [dbo].[PaymentParticipant]
                 WHERE ObjectType = {object_types[target_table.lower()]}'''
    db_cursor.execute(query)
    values = [
        (oid, choice(account_types))
        for (oid,) in db_cursor.fetchall()
    ]
    query_format = f'INSERT INTO [dbo].[{target_table}] VALUES (%s, %s)'
    db_cursor.executemany(query_format, values)
    db_connection.commit()


def setup_employees(
    db_connection,
    faker: Faker,
    max_count: int,
    object_types: dict = financial_objects,
):
    '''generates fake employees'''
    db_cursor = db_connection.cursor()

    query = f'''SELECT Oid, Name FROM [dbo].[PaymentParticipant]
                 WHERE ObjectType = {object_types["employee"]}'''
    db_cursor.execute(query)

    values = []
    for oid, name in db_cursor.fetchall():
        name = name.split(' ')
        busy_until_str = rand_datetime(
            datetime(1970, 1, 1), datetime.now(),
        ).strftime('%Y-%m-%d %H:%M:%S')

        values.append((oid, busy_until_str, name[1], randint(
            1000, 10000), randint(10, 100), name[0], randint(1, max_count), faker.text(255)))

    query_format = 'INSERT INTO [dbo].[Employee] VALUES (%s, %s, %s, %d, %d, %s, %d, Null, %s)'
    db_cursor.executemany(query_format, values)
    db_connection.commit()


def setup_clients(
    db_connection,
    faker: Faker,
    object_types: dict = financial_objects,
):
    '''generates fake clients'''
    db_cursor = db_connection.cursor()

    query = f'''SELECT Oid, Name FROM [dbo].[PaymentParticipant]
                 WHERE ObjectType = {object_types["client"]}'''
    db_cursor.execute(query)

    values = []
    for oid, name in db_cursor.fetchall():
        name = name.split(' ')
        values.append((oid, name[0], name[1], faker.phone_number()))

    query_format = 'INSERT INTO [dbo].[Client] VALUES (%s, %s, %s, %s)'
    db_cursor.executemany(query_format, values)
    db_connection.commit()


def setup_suppliers(
    db_connection,
    object_types: dict = financial_objects,
):
    '''generates fake suppliers'''
    db_cursor = db_connection.cursor()

    query = f'''SELECT Oid, Name FROM [dbo].[PaymentParticipant]
                 WHERE ObjectType = {object_types["supplier"]}'''
    db_cursor.execute(query)
    values = [
        (oid, name, getrandbits(1), getrandbits(1), getrandbits(1))
        for oid, name in db_cursor.fetchall()
    ]

    query_format = 'INSERT INTO [dbo].[Supplier] VALUES (%s, %s, %d, %d, %d)'
    db_cursor.executemany(query_format, values)
    db_connection.commit()


def generate_projects(db_connection, faker: Faker, count: int):
    '''generates fake projects'''
    date_format = '%Y-%m-%d %H:%M:%S'

    client_oids = get_oids_from(
        dbo_name='[dbo].[Client]', db_connection=db_connection)
    employee_oids = get_oids_from(
        dbo_name='[dbo].[Employee]', db_connection=db_connection)

    values = []
    for _ in range(count):
        manager, foreman = sample(employee_oids, 2)
        now = datetime.now()

        start_date = rand_datetime(
            datetime(1970, 1, 1), now,
        )
        finish_date = rand_datetime(
            start_date, now,
        )

        values.append((faker.bs(), faker.address(), choice(client_oids),
                       manager, foreman, 0, 0, 0, 0,
                       start_date.strftime(date_format), randint(0, 10),
                       finish_date.strftime(date_format),
                       0, 0, 0, 0, faker.text(255), faker.text(255), getrandbits(1)))

    query_format = '''INSERT INTO [dbo].[Project] VALUES (NEWID(), %s, %s, %s, %s, %s, %d, Null,
                                                            %d, %d, %d, %s, %d, %s, %d, 
                                                            %d, %d, %d, %s, %s, %d)'''

    db_cursor = db_connection.cursor()
    db_cursor.executemany(query_format, values)
    db_connection.commit()


def generate_payments(db_connection, faker: Faker, count: int):
    '''generates fake payments'''
    date_format = '%Y-%m-%d %H:%M:%S'

    category_oids = get_oids_from(
        dbo_name='[dbo].[PaymentCategory]', db_connection=db_connection)
    participant_oids = get_oids_from(
        dbo_name='[dbo].[PaymentParticipant]', db_connection=db_connection)
    project_oids = get_oids_from(
        dbo_name='[dbo].[Project]', db_connection=db_connection)

    values = []
    for _ in range(count):
        payer, payee = sample(participant_oids, 2)

        now = datetime.now()
        create_date = rand_datetime(
            datetime(1970, 1, 1), now,
        )
        date = rand_datetime(
            create_date, now,
        )

        values.append(
            (randint(100, 10**5), choice(category_oids), choice(project_oids),
             faker.text(60), faker.text(80), date.strftime(date_format),
             payer, payee, 0, create_date.strftime(date_format),
             getrandbits(100), getrandbits(1), getrandbits(10))
        )

    query_format = '''INSERT INTO [dbo].[Payment] VALUES (NEWID(), %d, %s, %s,
                            %s, %s, %s, %s, %s, %d, Null, %s, %s, %d, %s)'''

    db_cursor = db_connection.cursor()
    db_cursor.executemany(query_format, values)
    db_connection.commit()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Script to fill PaymentData database.'
    )

    parser.add_argument(
        '--participants',
        type=int,
        default=1000,
        help='count of participant entries to be generated',
    )

    parser.add_argument(
        '--projects',
        type=int,
        default=1000,
        help='count of project entries to be generated',
    )

    parser.add_argument(
        '--payments',
        type=int,
        default=1000,
        help='count of payment entries to be generated',
    )

    parser.add_argument(
        '--locale',
        type=str,
        default='en_US',
        help='generated text locale',
    )

    args = parser.parse_args()

    load_dotenv()

    server = os.getenv('MSSQL_SERVER', '.')
    database = os.getenv('MSSQL_DATABASE', 'PaymentData')
    user = os.getenv('MSSQL_USER', 'user')
    password = os.getenv('MSSQL_PASSWORD', 'password')

    db_connection = pymssql.connect(
        server=server, user=user, password=password, database=database,
    )

    faker = Faker(args.locale)

    generate_participants(db_connection=db_connection,
                          faker=faker, count=args.participants)

    setup_connection_through_account_type(
        db_connection=db_connection, target_table='Bank')
    setup_connection_through_account_type(
        db_connection=db_connection, target_table='Cashbox')
    setup_employees(db_connection=db_connection, faker=faker,
                    max_count=args.participants)
    setup_clients(db_connection=db_connection, faker=faker)
    setup_suppliers(db_connection=db_connection)

    generate_projects(db_connection=db_connection,
                      faker=faker, count=args.projects)

    generate_payments(db_connection=db_connection,
                      faker=faker, count=args.payments)

    db_connection.close()
