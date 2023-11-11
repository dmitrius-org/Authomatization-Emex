if OBJECT_ID('tRestrictions') is null
--drop table tRestrictions
/* **********************************************************
tRestrictions - список ограничений 
********************************************************** */
create table tRestrictions
(
 Name           varchar(30)
,Flag           int
)
go
create unique index a1 on tRestrictions(Name)
go
grant all on tRestrictions to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tRestrictions', @desc = 'Список ограничений'
-- Описание полей
exec dbo.sys_setTableDescription 'tRestrictions', 'Name',                'Наименование ограничения'
/*
insert tRestrictions
      (Name, Flag)
select 'NOAIR',  1
--union all select '',  1
--*/
