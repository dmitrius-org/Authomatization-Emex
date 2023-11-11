delete from tObjectType
/*
Flag  -- 1 - поддерживает модель сосотояния
      -- 2 - Активна

*/
go
insert tObjectType (ObjectTypeID, Brief, Name)       select   1, 'Авторизация',   'Авторизация пользователя'
insert tObjectType (ObjectTypeID, Brief, Name)       select   2, 'Пользователи',  'Пользователи' -- otUser
insert tObjectType (ObjectTypeID, Brief, Name, Flag) select   3, 'Заказы',        'Заказы', 1
insert tObjectType (ObjectTypeID, Brief, Name, Flag) select   4, 'Поиск деталей', 'Поиск деталей', 0

insert tObjectType (ObjectTypeID, Brief, Name, Flag) select 101, 'TaskProc',      'Процедуры автоматических заданий', 0

insert tObjectType (ObjectTypeID, Brief, Name, Flag) select   5, 'Связь клиентов и сотрудников', 'Связь клиентов и сотрудников', 0
