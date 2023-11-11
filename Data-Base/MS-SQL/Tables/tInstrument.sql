if OBJECT_ID('tInstrument') is null
/* **********************************************************
tInstrument - инструменты
********************************************************** */
create table tInstrument
(
 InstrumentID      numeric(18,0)  identity -- Ид инструмента 
,PID               numeric(18,0)  not null -- родитель
,Brief             nvarchar(64)   not null -- сокращение
,Name	           nvarchar(128)  not null -- Наименование
,InstrumentTypeID  numeric(18,0)  not null -- типы объект tInstrumentType.InstrumentTypeID 
,ObjectTypeID      numeric(18, 0) -- тип объекта системы. TObjectType.ObjectTypeID
,Flag              int -- 1
--
,UserID            numeric(18,0) default dbo.GetUserID()
,inDatetime        datetime      default GetDate()      --
,updDatetime       datetime      default GetDate()      --
)
go
create unique index ao1 on tInstrument(InstrumentID, InstrumentTypeID)
go
create unique index ao2 on tInstrument(Brief, InstrumentTypeID)
go
grant select on tInstrument to public
go
exec dbo.sys_setTableDescription @table = 'tInstrument', @desc = 'Интсрументы'
go
exec dbo.sys_setTableDescription 'tInstrument', 'Flag'                 ,'Дополнительные признаки: 1 - начальное состояние '
