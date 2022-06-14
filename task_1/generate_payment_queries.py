import os
import argparse
from datetime import datetime
from random import randint, choice, sample, getrandbits

import pymssql
from faker import Faker
from dotenv import load_dotenv

# load env variables
load_dotenv()

# constants
SERVER = os.getenv('MSSQL_SERVER', '.')
DATABASE = os.getenv('MSSQL_DATABASE', 'PaymentData')
USER = os.getenv('MSSQL_USER', 'user')
PASSWORD = os.getenv('MSSQL_PASSWORD', 'password')
ENCODING = 'utf-8'


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


def get_new_oid(db_connection):
    '''generate new id for object'''
    db_cursor = db_connection.cursor()
    db_cursor.execute('SELECT NEWID()')
    return db_cursor.fetchone()[0]


def generate_payments_values(db_connection, faker: Faker, count: int):
    '''generates data for fake payments'''
    date_format = '%Y-%d-%m %H:%M:%S'

    category_oids = get_oids_from(dbo_name='[dbo].[PaymentCategory]',
                                  db_connection=db_connection)
    participant_oids = get_oids_from(dbo_name='[dbo].[PaymentParticipant]',
                                     db_connection=db_connection)
    project_oids = get_oids_from(dbo_name='[dbo].[Project]',
                                 db_connection=db_connection)

    values = []
    for _ in range(count):
        payment_oid = get_new_oid(db_connection=db_connection)
        payer_oid, payee_oid = sample(participant_oids, 2)

        now = datetime.now()
        create_date = rand_datetime(datetime(2000, 1, 1), now)
        date = rand_datetime(create_date, now)

        values.append((payment_oid, randint(100, 10**5), choice(category_oids),
                       choice(project_oids), faker.text(60), faker.text(80),
                       date.strftime(date_format), payer_oid, payee_oid, 0,
                       create_date.strftime(date_format), getrandbits(100),
                       getrandbits(1), getrandbits(10)))

    return values


def generate_insert_payments_by_single_queries(values, file_name: str):
    '''DOC'''
    with open(file_name, 'w', encoding=ENCODING) as sql_file:
        sql_file.write(f'USE {DATABASE}\n')
        sql_file.write('GO\n')
        sql_file.write('DECLARE @start DATETIME\n')
        sql_file.write('DECLARE @end DATETIME\n')
        sql_file.write('SET @start = GETDATE()\n')
        sql_file.write('BEGIN TRAN TestPaymentsInsert\n')

        query_format = (
            "INSERT INTO [dbo].[Payment] (Oid, Amount, Category,"
            " Project, Justification, Comment, Date, Payer, Payee,"
            " OptimisticLockField, GCRecord, CreateDate, CheckNumber,"
            " IsAuthorized, Number) VALUES ('%s', %d, '%s', '%s', '%s',"
            " '%s', '%s', '%s', '%s', %d, Null, '%s', '%s', %d, '%s')\n")
        for value in values:
            sql_file.write(query_format % value)

        sql_file.write('SET @end = GETDATE()\n')
        sql_file.write(
            'SELECT DATEDIFF(millisecond, @start, @end) AS ElapsedTimeMs\n')
        sql_file.write('GO\n')
        sql_file.write('ROLLBACK TRAN TestPaymentsInsert\n')
        sql_file.write('GO\n')


def generate_insert_payments_by_batched_queries(values, file_name: str):
    '''DOC'''
    with open(file_name, 'w', encoding=ENCODING) as sql_file:
        sql_file.write(f'USE {DATABASE}\n')
        sql_file.write('GO\n')
        sql_file.write('DECLARE @start DATETIME\n')
        sql_file.write('DECLARE @end DATETIME\n')
        sql_file.write('SET @start = GETDATE()\n')
        sql_file.write('BEGIN TRAN TestPaymentsInsert\n')
        sql_file.write(
            ('INSERT INTO [dbo].[Payment] (Oid, Amount, Category,'
             ' Project, Justification, Comment, Date, Payer, Payee,'
             ' OptimisticLockField, GCRecord, CreateDate, CheckNumber,'
             ' IsAuthorized, Number) VALUES\n'))

        row_format = (
            "('%s', %d, '%s', '%s', '%s', '%s', '%s', '%s', '%s', %d,"
            " Null, '%s', '%s', %d, '%s')")
        rows = ',\n'.join(map(lambda value: row_format % value, values)) + '\n'
        sql_file.write(rows)

        sql_file.write('SET @end = GETDATE()\n')
        sql_file.write(
            'SELECT DATEDIFF(millisecond, @start, @end) AS ElapsedTimeMs\n')
        sql_file.write('GO\n')
        sql_file.write('ROLLBACK TRAN TestPaymentsInsert\n')
        sql_file.write('GO\n')


if __name__ == '__main__':
    faker = Faker('en_US')
    count = 1000

    db_connection = pymssql.connect(
        server=SERVER,
        user=USER,
        password=PASSWORD,
        database=DATABASE,
    )

    values = generate_payments_values(
        db_connection=db_connection,
        faker=faker,
        count=count,
    )

    generate_insert_payments_by_single_queries(
        values=values,
        file_name=f'InsertBySingleQueries{count}.sql',
    )

    generate_insert_payments_by_batched_queries(
        values=values,
        file_name=f'InsertByBatchedQueries{count}.sql',
    )

    db_connection.close()
