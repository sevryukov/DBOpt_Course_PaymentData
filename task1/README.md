## Задачи I уровня
1. Реализовать индексы, повышающие производительность операций вставки и изменения платежей без модификации программных компонент

##  Процесс реализации
Для реализации индексов были проанализированы функции, вызываемые при операции вставки или изменения платежа, и рассмотрены поля, для которых можно создать индекс. На часть из рассмотренных полей в базе данных уже существовали индексы, а для оставшихся были созданы некластерные индексы. В итоге дополнительно было создано 8 индексов (```CreateIndexes.sql```).

Для тестирования полученных индексов с помощью скрипта ```generate_payment_queries.py``` были сгенерированы скрипты для вставки 100 и 500 записей соответственно (данные скрипты выполняют вставку записей в таблицу ```Payment```, замеряют время потраченное на вставку всех записей и возвращают его в качестве результата, после этого внесенные изменения отменяются). Отличие ```InsertByBatchedQueries``` от ```InsertBySingleQueries``` в том, что в первом случае оператор ```INSERT``` вставляет несколько строк в таблицу, а во втором по одной.

Тестирование производилось путем многократного запуска соответствующих скриптов (```InsertByBatchedQueries``` и ```InsertBySingleQueries```) и усреднением полученных результатов. Для этого использовался ПК со следующей конфигурацией: AMD Ryzen 7 2700X Eight-Core 3.70 GHz, 16GB RAM, HDD 128GB, Windows 11 x64.

## Результаты

| Inserted Rows Count (by batched queries) | ExecTime (ms) | ExecTime per Row (ms) | ExecTime Indexes (ms) | ExecTime Indexes per Row (ms) | Profit (%)  |
| --------------------------------- | ------------- | ----------------- | --------------------- | ------------------------- | ----------- |
| 100                               | 334           | 3,34              | 330                   | 3,3                       | 1,19760479  |
| 500                               | 1796          | 3,592             | 1570                  | 3,14                      | 12,58351893 |


| Inserted Rows Count (by single queries) | ExecTime (ms) | ExecTime per Row (ms) | ExecTime Indexes (ms) | ExecTime Indexes per Row (ms) | Profit (%)  |
| --------------------------------- | ------------- | ----------------- | --------------------- | ------------------------- | ----------- |
| 100                               | 370           | 3,7               | 363                   | 3,63                      | 1,891891892 |
| 500                               | 2480          | 4,96              | 2293                  | 4,586                     | 7,540322581 |

По полученным данным видно, что добавление индексов особо не повлияло на операцию вставки 100 записей, но можно наблюдать прирост производительности при вставке 500 записей (12,5% и 7,5% соответственно). Также стоить отметить, что использование оператора ```INSERT``` со вставкой сразу нескольких строк значительно снижает время вставки в таблицу отдельной строки.
