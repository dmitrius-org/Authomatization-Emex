if OBJECT_ID('tTaskProperties') is null
--drop table tTaskProperties
/* **********************************************************
********************************************************** */
create table tTaskProperties
(
  Brief                nvarchar(64),
  IsActive             bit --
)
go
create unique index ao2 on tTaskProperties(Brief)
go
grant all on tTaskProperties to public
go
insert tTaskProperties (Brief, IsActive) select 'Task', 0
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tTaskProperties', @desc = 'Параметры задачи'