
import datetime
from faker import Faker
import random

OBJECT_TYPES = ["cashless", "cash", "client", "employee", "supplier"]
START_DATE = datetime.datetime(2019, 1, 1)
END_DATE = datetime.datetime.now()

class BaseQueryBuilderService:
    fake = Faker()

    @staticmethod
    def generate_date(start=START_DATE, end=END_DATE):
        return datetime.datetime.fromtimestamp(random.randint(int(start.timestamp()), int(end.timestamp())))
