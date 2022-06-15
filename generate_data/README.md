# Использование скрипта
Вывод `python3 generate.py -h`:
```
usage: generate.py [-h] [--participants PARTICIPANTS] [--projects PROJECTS] [--payments PAYMENTS] [--locale LOCALE]

Script to fill PaymentData database.

optional arguments:
  -h, --help            show this help message and exit
  --participants PARTICIPANTS
                        count of participant entries to be generated
  --projects PROJECTS   count of project entries to be generated
  --payments PAYMENTS   count of payment entries to be generated
  --locale LOCALE       generated text locale
```
Простейший вызов скрипта с параметрами по умолчанию(по 1000 объектов): `python3 generate.py`.

В итоге были использованы такие параметры: 1000 participants, 1000 projects и 5000 payments.

# Разработка скрипта
Так как в моём распоряжении есть только машина с ARM-чипом, а `SQL Server` и драйвер `pyodbc` не поддерживают архитектуру ARM, при выполнении заданий я использовал СУБД `Azure SQL Edge` и драйвер `pymssql`. `Azure SQL Edge` поддерживает `TSQL`, так что переписывать исходный скрипт под другой диалект не пришлось. Также для просмотра данных, составления планов запросов и т.п. использовалась `Azure Data Studio`.