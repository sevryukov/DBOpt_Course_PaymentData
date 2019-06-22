# Описание проекта
## Описание файлов
- `data-gen` - файлы касающиеся генерации данных
    - `insert_one_row.sql` - добавление одной записи в таблицу `Payment`
    - `insert_thousand_rows.sql` - добавление тысячи записей в таблицу `Payment`
    - `fake-data-generation-report.pdf` - отчёт о генерации начальных данных для
    - `detailed_insert.sql` - выполнение операции `INSERT` с непосредственным вызовом вложенных функций
- `exec-plans` - планы выполнения запросов
    - `function_CalculatePaymentParticipantBalance.sqlplan`
    - `insert_payment.sqlplan` - план запроса добавления одной строки в таблицу `Payment`
- `insertion-test` - тест на корректность расчёта баланса
- `indices` - создание индексов
- `queue-insert` - создание очереди и триггера для неё
    - `payment_insert_trigger.sql` - триггер для добавления нового `Payment`
    - `queue_table_creation.sql` - создание таблицы очереди
- Исходные файлы

## Использованные инструменты
- Redgate - генерация данных
- Docker - развёртывание СУБД
- Microsoft SQL Server Management Studio - отправка запросов, генерация планов выполнения, просмотр статистик и пр.

# Результаты
## Начальные действия
- [x] Ознакомиться с документом, описывающим формулы расчёта баланса и примером его изменения
- [x] Ознакомиться со скриптом создания базы данных
- [x] Ознакомиться с программными компонентами (функции, триггера)
- [x] Разработать и применить генератор тестовых данных
- [x] Разработать простой тест на корректность расчёта баланса

С помощью Redgate было сгенерировано 1000 записей для каждой таблицы. Тест на корректность расчёта баланса реализован в файле `insertion-test/SimpleTest.sql`

## Задачи I уровня
- [x] Реализовать индексы, повышающие производительность операций вставки и изменения платежей без модификации программных компонент

Было добавлено 7 индексов (реализация находится в файле `indices\indices_creation.sql`). До их создания добавление 5000 записей в таблицу занимало 38 секунд. После этого такой же запрос выполнялся уже за 28 секунд. Таким образом удалось достигнуть повышения производительности на ~26%. Индексация происходила по тем столбцам, которые используются в функциях.

## Задачи II уровня
- [x] Дать оценку затрат на выполнения операций расчёта балансов в рамках транзакций создания и изменения платежа. Желательно представить количественную оценку, но допустимо и относительную (к примеру, "90% ресурсов и времени уходит на расчёт баланса"). Чем детальнее, тем лучше.
- [x] Предложить сценарий оптимизации механизмов расчёта. Сценарий должен допускать максимизацию скорости целевых изменений и допускать отложенное вычисление балансов (балансы и данные платежей должны быть согласованы в конечном счёте).
- [x] Оценить недостатки предлагаемого сценария с точки зрения потенциальных пользователей.

**Оценка затрат:**
- 4% вычисление баланса плательщика
- 17% обновление баланса плательщика
- 4% вычисление баланса получателя
- 17% обновление баланса получателя
- 5% вычисление баланса по материалам (выполняется дважды)
- 3% вычисление баланса по работе (выполняется дважды)
- 1% вычисление баланса проекта
- 40% обновление баланса у новых объектов (`Project`)

Повторный расчёт баланса по материалам и работе связан с тем, что это необходимо для расчёта баланса проекта и для вставки новой записи. Данные оценки взяты из плана запроса, который отправляется каждый раз, когда вызывается триггер таблицы `Payment`. Запрос сохранён в отдельном файле `data-gen\detailed_insert.sql`.

**Сценарий отложенного платежа.** *Для решения задачи этого уровня рассмотрим абстрактное решение. Детали реализации последуют в следующем разделе, посвящённом задачам III уровня.* 

Исходя из оценки затрат можно сделать вывод, что вычисления требуют немало времени. При этом можно повысить производительность за счёт того, что балансы будут высчитываться с некоторой периодичностью, а не после каждого платежа. Для этого необходимо добавление двух компонент:
- Очередь платежей, на основе которых требуется расчитать баланс
- Компонента, которая сигнализирует о необходимости провести перерасчёт баланса

Есть два критерия, которые позволят выявить эту необходимость: размер очереди или время с прошлой проверки. СУБД не обладают инструментами, которые позволяют проводить запросы с периодичностью, однако оценка объёма данных после их изменения возможна. Таким образом для мониторинга очереди по первому критерию достаточно триггера, но для второго понадобится создание внешней по отношению к СУБД компоненты. При этом обязанности триггера тоже можно положить на внешнюю компоненту.

Путь, который включает создание триггера на очереди, кажется менее привлекательным: триггеры СУБД могут приводить к взаимоблокировкам. Несмотря на это, в рамках этой задачи мы решили сделать именно так, чтобы не создавать лишнюю работу себе и проверяющему.

**Недостатки сценария.**
1. Отложенный вывод баланса пользователю
2. Взаимоблокировки (сценарий с триггером) или дополнительные компоненты (сценарий с внешним сервисом)
3. Становится невозможным создание проверки достаточности средств на счету во время проведения платежа (в формулировке задачи таких условий нет, однако такое требование может возникнуть в будущем)
4. Дополнительные расходы памяти серверного оборудования

## Задачи III уровня
- [x] Реализовать предложенный сценарий отложенного вычисления.
- [x] Дать оценку затрат на выполнение операций расчёта балансов в рамках транзакций создания и изменения платежа. Дать заключение о полученном росте производительности, если таковое будет наблюдаться.
- [x] Дать оценку возникшим проблемам и недостаткам, сравнить их с оценками, сделанными при проектировании сценария оптимизации (указать, что сбылось, что неожиданно проявилось и т.д.).
- [x] Дать заключение о преимуществах и недостатках выполненной оптимизации (превосходят ли полученные преимущества те недостатки, которые возникли после оптимизации).

**Реализация.** Для реализации сценария был заменён триггер `[dbo].[T_Payment_AI] ON [dbo].[Payment]` на `[dbo].[T_Payment_AI_Queue] ON [dbo].[Payment]` (файл создания этого триггера находится в `queue-insert\payment_insert_trigger.sql`). Триггер кладёт сведения о новых платежах в очередь, которая реализуется таблицей `PaymentQueue ` (файл создания находится в `queue-insert\queue_table_creation.sql`). Если в очереди больше 1000 значений, то происходит перерасчёт балансов и очистка очереди. Эту цифру, конечно, можно изменить (для этого необходимо знать статистику отправки запросов на вставку платежей).

**Оценка затрат.** До замены триггера на созданный в данном проекте 5000 запросов на вставку с постоянным расчётом баланса выполнялись за 28 секунд. После замены этот процесс занимает всего 9 секунд. Таким образом удалось достичь повышения производительности на ~67%. При этом затраты на такой способ составляют всего 1000 записей в таблице, что при современных ценах на память нельзя считать существенным ограничением.

**Оценка недостатков.** Отображение баланса для клиентов будет происходить с задержкой, что потенциально быть недостатком. В выполненной реализации существует недостаток, при котором пересчёт баланса зависит от постоянности проводимых транзакций. Если в какой-то момент транзакций проходит так мало, что в очереди не набирается должное количество записей за небольшое время, то пользователям придётся ждать дольше, чем при высокой нагрузке системы. Так или иначе, это решается сбором статистики и установкой разных значений максимального размера очереди для разного времени суток и для разных дней. Помимо этого не пропадает проблема проверки достаточности средств для создания нового платежа. В данной реализации пользователь может потратить слишком много средств, полагая, что его баланс позволяет это сделать. Это ограничение не заявлено в формулировке задачи, однако оно имеет место быть (при уточнении или развитии проекта).

**Преимущества и недостатки.** В задаче II уровня были выявлены 4 проблемы. Проблемы 2 и 4 в данном подходе не существены: один триггер заменился на другой, вероятность взаимоблокировок осталась такой же или понизилась (новый триггер срабатывает как минимум реже, чем старый). Расходы на память минимальны. Проблемы 1 и 3 сохраняются, но их ущерб можно минимизировать сбором статистики.

#### Над проектом работают: Орлов Антон, Доржиев Зоригто
#### Преподаватель: Севрюков Сергей Юрьевич