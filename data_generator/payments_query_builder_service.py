import datetime
import random
from base_query_builder_service import BaseQueryBuilderService

class PaymentsQueryBuilderService(BaseQueryBuilderService):
    def generate_query(self, category_ids, participant_ids, project_ids):   
            category = random.choice(category_ids)
            project = random.choice(project_ids)
            payee, payer = random.sample(participant_ids, 2)
            return "INSERT INTO [dbo].[Payment] ([Oid], [Amount], [Category], [Project], [Justification], [Comment], [Date], [Payer], [Payee], " \
                   "[OptimisticLockField], [GCRecord], [CreateDate], [CheckNumber], [IsAuthorized], [Number]) " \
                   f"VALUES (NEWID(), {self.amount()}, '{category}', '{project}', '{self.justificaton()}', '{self.comment()}', " \
                   f"'{self.date()}', '{payer}', '{payee}', {self.optimistic_lock_field()}, Null, '{self.created_date()}', " \
                   f"'{self.check_number()}', {random.randint(0, 1)}, '{self.number()}')"

    def amount(self):
        return random.randint(1, 100000)

    def justificaton(self):
        return BaseQueryBuilderService.fake.text(30)

    def comment(self):
        return BaseQueryBuilderService.fake.text(100)

    def optimistic_lock_field(self):
        return random.randint(1, 3)

    def check_number(self):
        return random.randint(10000, 99999)

    def number(self):
        return random.randint(10000, 99999)

    def date(self):
        return BaseQueryBuilderService.generate_date().isoformat()

    def created_date(self):
        return datetime.datetime.fromtimestamp(int(datetime.datetime.now().timestamp())).isoformat()
