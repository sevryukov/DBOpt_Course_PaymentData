import random
from base_query_builder_service import BaseQueryBuilderService

class EmployeesQueryBuilderService(BaseQueryBuilderService):
    def generate_query(self, participant):  
        oid, name = participant
        first_name, second_name = name.split(maxsplit=1)

        return "INSERT INTO [dbo].[Employee] ([Oid], [BusyUntil], [SecondName], [Stuff], [HourPrice], [Patronymic], " \
               "[PlanfixId], [Head], [PlanfixMoneyRequestTask]) " \
               f"VALUES ('{oid}', '{self.busy_until()}', '{second_name}', {self.stuff()}, {self.hour_price()}, '{first_name}', " \
               f"{self.plan_fix_id()}, Null, '{self.plan_fix_money_request_task()}')"

    def busy_until(self):
        return BaseQueryBuilderService.generate_date().isoformat()

    def stuff(self):
        return random.randint(0, 100000)

    def hour_price(self):
        return random.randint(100, 2000)

    def plan_fix_id(self):
        return random.randint(1, 10000)

    def plan_fix_money_request_task(self):
        return BaseQueryBuilderService.fake.text(50)
