import random
from base_query_builder_service import BaseQueryBuilderService, END_DATE

class PaymentParticipantsQueryBuilderService(BaseQueryBuilderService):
    def generate_query(self):
        active_from, inactive_from = self.active_and_inactive_from()
        return "INSERT INTO [dbo].[PaymentParticipant] ([Oid], [Balance], [Name], [OptimisticLockField], [GCRecord], " \
               "[ObjectType], [ActiveFrom], [InactiveFrom], [BankDetails], [Balance2], [Balance3]) " \
               f"VALUES (NEWID(), 0, '{self.name()}', Null, Null, {self.object_type()}, '{active_from}', " \
               f"'{inactive_from}', '{self.bank_details()}', 0, 0)"

    def name(self):
        return BaseQueryBuilderService.fake.name()

    def object_type(self):
        return random.randint(0, 4) # Тип платильщика. Допустимы следующие типы платильщиков: Безналичный счёт, наличный счёт, клиент, сотрудник, поставщик

    def bank_details(self):
        return BaseQueryBuilderService.fake.bban()

    def active_and_inactive_from(self):
        active_from = BaseQueryBuilderService.generate_date()
        inactive_from = BaseQueryBuilderService.generate_date(active_from, END_DATE)
        return active_from.isoformat(), inactive_from.isoformat()
