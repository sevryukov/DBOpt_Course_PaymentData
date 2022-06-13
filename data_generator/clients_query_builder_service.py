from base_query_builder_service import BaseQueryBuilderService

class ClientsQueryBuilderService(BaseQueryBuilderService):
    def generate_query(self, participant):  
        oid, name = participant
        first_name, second_name = name.split(maxsplit=1)
        return "INSERT INTO [dbo].[Client] ([Oid], [FirstName], [SecondName], [Phone]) "\
               f"VALUES ('{oid}', '{first_name}', '{second_name}', '{self.phone_number()}')"

    def phone_number(self):
        return BaseQueryBuilderService.fake.phone_number()
