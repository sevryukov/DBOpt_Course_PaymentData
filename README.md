# DBOpt_Course_PaymentData
Задание к курсу Оптимизация баз данных - расчёт балансов

Работа Цепелевой Р.В., группа 21.М11-ПУ.

UPD 11.06: Так как на моем компьютере используется ОС MacOS, пришлось запускать MS SQL Server через докер образ.
По итогу был скачан и запущен докер образ `mcr.microsoft.com/mssql/server:2019-latest`, установлено ПО `Azure Data Studio`,
сгенерирована визуализация БД (см `schema.png`). Также чз python-модуль `pyodbc` было установлено подключение к запущенной БД и сгенерированы тестовые данные.

## Порядок выполнения и взаимодействия
1. Все вопросы оформлять в виде Issue
2. Все изменения и результаты оформлять в виде Pull Request из собственного fork

## Требования к окружению
MS SQL Server любой версии (предпочтительно 2016 и старше).
Допустимо использование иной СУБД при портировании исходного скрипта с учётом конечного диалекта SQL.
## Начальные действия
1. Ознакомиться с документом, описывающим формулы расчёта баланса и примером его изменения
2. Ознакомиться со скриптом создания базы данных
3. Ознакомиться с программными компонентами (функции, триггера)
4. Разработать и применить генератор тестовых данных
5. Разработать простой тест на корректность расчёта баланса

Ожидаемый результат - доступная для оптимизации БД с тестовыми данными

## Задачи I уровня
1. Реализовать индексы, повышающие производительность операций вставки и изменения платежей без модификации программных компонент

## Задачи II уровня
В исходной версии балансы обновляются в рамках транзакции целевого действия над платежом - создания или изменения. Предположим, что требования к производительности не выполняются при такой реализации.

Введём две роли пользователей: бухгалтер-оператор и бухгалтер-аналитик.

**Оператор** - занимается вводом и корректировкой платежей, не имеет доступа к данным о балансах.

**Бухгалтер-аналитик** - отслеживает балансы и заведённые платежи для принятия решения о предпринимаемых финансовых действиях (какие счета использовать, какие образовались долги и т.д.).

1. Дать оценку затрат на выполнения операций расчёта балансов в рамках транзакций создания и изменения платежа. Желательно представить количественную оценку, но допустимо и относительную (к примеру, "90% ресурсов и времени уходит на расчёт баланса"). Чем детальнее, тем лучше.
2. Предложить сценарий оптимизации механизмов расчёта. Сценарий должен допускать максимизацию скорости целевых изменений и допускать отложенное вычисление балансов (балансы и данные платежей должны быть согласованы в конечном счёте).
3. Оценить недостатки предлагаемого сценария с точки зрения потенциальных пользователей.

## Задачи III уровня
1. Реализовать предложенный сценарий отложенного вычисления.
2. Дать оценку затрат на выполнение операций расчёта балансов в рамках транзакций создания и изменения платежа. Дать заключение о полученном росте производительности, если таковое будет наблюдаться.
3. Дать оценку возникшим проблемам и недостаткам, сравнить их с оценками, сделанными при проектировании сценария оптимизации (указать, что сбылось, что неожиданно проявилось и т.д.).
4. Дать заключение о преимуществах и недостатках выполненной оптимизации (превосходят ли полученные преимущества те недостатки, которые возникли после оптимизации).
