import datetime
import random
from base_query_builder_service import BaseQueryBuilderService

class ProjectsQueryBuilderService(BaseQueryBuilderService):
    def generate_query(self, employee_ids, client_ids):
        manager, foreman = random.sample(employee_ids, 2)
        client = random.choice(client_ids)
        start_date, finish_date = self.start_and_finish_dates()

        return "INSERT INTO [dbo].[Project] ([Oid], [Name], [Address], [Client], [Manager], [Foreman], [OptimisticLockField], [GCRecord], " \
               "[Balance], [BalanceByMaterial], [BalanceByWork], [PlaningStartDate], [Status], [FinishDate], [Area], [WorkPriceRate], " \
               "[WorkersPriceRate], [RemainderTheAdvance], [PlanfixWorkTask], [PlanfixChangeRequestTask], [UseAnalytics]) " \
               f"VALUES (NEWID(), '{self.name()}', '{self.address()}', '{client}', '{manager}', '{foreman}', {self.optimistic_lock_field()}, " \
               f"Null, 0, 0, 0, '{start_date}', {self.status()}, '{finish_date}', " \
               f"{self.area()}, {self.work_price_rate()}, {self.workers_price_rate()}, 0, '{self.plan_fix_work_task()}', " \
               f"'{self.plan_fix_change_request_task()}', {self.use_analytics()})"

    def name(self):
        return BaseQueryBuilderService.fake.bs()

    def address(self):
        return BaseQueryBuilderService.fake.address()

    def optimistic_lock_field(self):
        return random.randint(1, 3)

    def start_and_finish_dates(self):
        start_date = BaseQueryBuilderService.generate_date()
        finish_date = BaseQueryBuilderService.generate_date(start_date + datetime.timedelta(365),
                                                            start_date + datetime.timedelta(365*3))
        return start_date.isoformat(), finish_date.isoformat()

    def status(self):
        return random.randint(0, 4)

    def area(self):
         return random.randint(1, 1000000)

    def work_price_rate(self):
        return random.uniform(250000, 100000000)

    def workers_price_rate(self):
        return random.uniform(50000, 500000)

    def plan_fix_work_task(self):
        return BaseQueryBuilderService.fake.text(70)

    def plan_fix_change_request_task(self):
        return BaseQueryBuilderService.fake.text(70)

    def use_analytics(self):
        return random.randint(0, 1)
