delete from tRetCode
-- tUsers
insert tRetCode (RetCode, Message) select 1, 'Пользователь с заданным логином существует!'
insert tRetCode (RetCode, Message) select 2, 'Пользователь должен иметь права [sysadmin]!'
insert tRetCode (RetCode, Message) select 3, 'Ошибка при добавлении пользователя!'
insert tRetCode (RetCode, Message) select 4, 'Ошибка при удалении пользователя!'
insert tRetCode (RetCode, Message) select 5, 'Старый и новый пароли не должны совподать!'
insert tRetCode (RetCode, Message) select 6, 'Удаление запрещено, пользователь используется в таблице заказов!'

-- tClients
insert tRetCode (RetCode, Message) select 100, 'Клиент с заданным наименованием существует!'
insert tRetCode (RetCode, Message) select 101, 'Удаление запрещено, Клиент используется в таблице заказов!'
insert tRetCode (RetCode, Message) select 102, 'В системе уже зарегистрирован клиент с заданной почтой!'
insert tRetCode (RetCode, Message) select 103, 'Нет данных!'

--tClientType
insert tRetCode (RetCode, Message) select 120, 'Тип клиент с заданным наименованием существует!'
insert tRetCode (RetCode, Message) select 121, 'Удаление запрещено, тип клиента используется в справочнике "Клиенты"!'
-- tSuppliers
insert tRetCode (RetCode, Message) select 200, 'Поставщик с заданным наименованием!'
insert tRetCode (RetCode, Message) select 201, 'Удаление запрещено, поставщик используется в справочнике "Клиенты"!'

-- tInstrument
insert tRetCode (RetCode, Message) select 300, 'Состояние с заданным сокращением существует!'
insert tRetCode (RetCode, Message) select 301, 'Группа с заданным сокращением существует!'
insert tRetCode (RetCode, Message) select 302, 'Действие с заданным сокращением существует!'
insert tRetCode (RetCode, Message) select 303, 'Удаление запрещено, под группой имеются связанные настройки!'
insert tRetCode (RetCode, Message) select 304, 'Удаление запрещено, под объектом имеются связанные элементы!'
insert tRetCode (RetCode, Message) select 305, 'Модель состояния с заданным сокращением существует!'
insert tRetCode (RetCode, Message) select 306, 'Удаление запрещено, на состояние имеются переходы!'
insert tRetCode (RetCode, Message) select 307, 'Удаление запрещено, под действием настроены связанные объекты "Процедуры"!'

insert tRetCode (RetCode, Message) select 310, '[LoadOrders] Не определен идентификатор объекта системы для которго настроена модель состояния!'

insert tRetCode (RetCode, Message) select 320, '[LoadOrders] Не определен идентификатор начального состояния!'

insert tRetCode (RetCode, Message) select 331, 'Статус с заданным сокращением используется в таблице заказов!'
insert tRetCode (RetCode, Message) select 332, 'Статус с заданным сокращением используется в модели состояния!'
insert tRetCode (RetCode, Message) select 333, 'Действие с заданным сокращением используется в модели состояния!'

-- tEmployees
insert tRetCode (RetCode, Message) select 450, 'Сотрудник с заданным наименованием!'


-- tOrders 500 - 600
insert tRetCode (RetCode, Message) select 500, 'Отсутствуют объекты для выполнения операции!'
insert tRetCode (RetCode, Message) select 501, 'Не удалось отпределить целевое состояние!'
insert tRetCode (RetCode, Message) select 502, 'Отсутствует настройка [CoeffMaxAgree]. Максимальный коэффициент превышения цены продажи для клиента над ценой!'
insert tRetCode (RetCode, Message) select 503, 'Необходимо проставить значение настройки [CoeffMaxAgree]. Максимальный коэффициент превышения цены продажи для клиента над ценой!'
insert tRetCode (RetCode, Message) select 504, 'Необходимо заполнить обязательные поля "Цена закупки" и "Сумма закупки"!'
insert tRetCode (RetCode, Message) select 505, 'Ошибка удаления товара из корзины, требуется ручная проверка!'
insert tRetCode (RetCode, Message) select 506, 'Ошибка!'
insert tRetCode (RetCode, Message) select 507, 'Клиенту запрещено создавать заказ!'
insert tRetCode (RetCode, Message) select 508, 'Недостаточно средств на балансе клиента!'
insert tRetCode (RetCode, Message) select 509, 'Ошибка с типом отгрузки!'
insert tRetCode (RetCode, Message) select 510, 'Нет позиций для заказа!'
insert tRetCode (RetCode, Message) select 511, 'Неизвестная ошибка!'
insert tRetCode (RetCode, Message) select 512, 'Состояние "В работе" запрещено откатывать!'
insert tRetCode (RetCode, Message) select 513, 'Необходимо заполнить обязательное поле "Reference"!'
insert tRetCode (RetCode, Message) select 514, 'Необходимо заполнить обязательное поле "CustomerSubId"!'
insert tRetCode (RetCode, Message) select 515, 'Состояние "Отказан" запрещено откатывать!'
insert tRetCode (RetCode, Message) select 516, 'Необходимо выделить заказы только одного клиента!'
insert tRetCode (RetCode, Message) select 517, 'Неизвестная ошибка, деталь не добалена в корзину!'
insert tRetCode (RetCode, Message) select 518, 'Необходимо заполнить обязательное поле "DestinationLogo"!'
insert tRetCode (RetCode, Message) select 519, 'Не задан шаблон Excel для экспорта отказов!'
insert tRetCode (RetCode, Message) select 520, 'Не задан каталог для сохранения файлов отказов!'
insert tRetCode (RetCode, Message) select 521, 'Не задан скрипт для выгрузки отказов!'
insert tRetCode (RetCode, Message) select 522, 'Не найден шаблон Excel для экспорта отказов!'
insert tRetCode (RetCode, Message) select 523, 'Не найден каталог для сохранения файлов отказов!'
insert tRetCode (RetCode, Message) select 524, 'Не найден скрипт для выгрузки отказов!'
insert tRetCode (RetCode, Message) select 525, 'Данный файл уже в обработке!'
insert tRetCode (RetCode, Message) select 526, 'Невозможно разместить заказы так как выбраны детали разных клиентов (кабинетов EMEX)!'
--