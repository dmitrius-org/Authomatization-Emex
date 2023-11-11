if OBJECT_ID('tMarks') is not null
  drop table tMarks
go  
/* **********************************************************
tMarks - Таблица для хранения списка выделенных объектов
********************************************************** */
create table tMarks
(
 Spid  numeric(18,0)
,Type  numeric(18,0)  
,ID    numeric(18,0)  
CONSTRAINT pk_tMarks PRIMARY KEY  clustered  (Spid, Type, ID)
)
go
grant all on tMarks to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tMarks', @desc = 'Таблица для хранения списка выделенных объектов'
-- Описание полей
exec dbo.sys_setTableDescription 'tMarks', 'Spid' ,'Сессия'
exec dbo.sys_setTableDescription 'tMarks', 'Type' ,'Тип'	
exec dbo.sys_setTableDescription 'tMarks', 'ID'   ,'Ид объекта'

