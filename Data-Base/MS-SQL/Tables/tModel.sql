if OBJECT_ID('tModel') is null
/* **********************************************************
tInstrument - инструменты
********************************************************** */
create table tModel
(ModelID           numeric(18, 0) identity
,InstrumentID      numeric(18,0)  not null -- Ид модели tInstrument.InstrumentID
,StateID           numeric(18,0)  not null -- ИД состояния
,ActionID          nvarchar(64)            -- ИД действия
,TargetStateID     nvarchar(128)           -- ИД состояния
,InstrumentTypeID  numeric(18,0)  not null -- типы объект tInstrumentType.InstrumentTypeID 
,Flag              int                     -- Флаги
--
,UserID            numeric(18,0) default dbo.GetUserID()
,inDatetime        datetime      default GetDate()      --
,updDatetime       datetime      default GetDate()      --
)
go
create unique index ao1 on tModel(ModelID)
go
go
grant select on tModel to public
go
exec dbo.sys_setTableDescription @table = 'tModel', @desc = 'Модель состояния'
go
exec dbo.sys_setTableDescription 'tModel', 'Flag'                 ,'Дополнительные признаки: 1 - начальное состояние '
go
/*
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  1,  0,  6, 1
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  2,  0,  6, 0 
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  3,  0,  6, 0  --В корзине
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  4,  0,  6, 0  --В работе
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  5,  0,  6, 0  --Закуплено
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  6,  0,  6, 0  --Получено на склад
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  7,  0,  6, 0  --Готово к выдаче
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  8,  0,  6, 0  --Отправлено
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4,  9,  0,  6, 0  --Нет в наличии
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4, 10,  0,  6, 0  --Меньше минимальной партии
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4, 11,  0,  6, 0  --Изменение цены
insert tModel (InstrumentID, StateID, ActionID, InstrumentTypeID, Flag) select 4, 12,  0,  6, 0  --Отказан
*/