if OBJECT_ID('tPrices') is null
--drop table tPrices
/* **********************************************************						
tPrices - список прайсов 
********************************************************** */
create table tPrices
(
 Name           varchar(30) 
,Flag           int
)
go
create unique index a1 on tPrices (Name)
go
grant all on tPrices to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tPrices', @desc = 'Список прайсов'
-- Описание полей
exec dbo.sys_setTableDescription 'tPrices', 'Name',                'Наименование прайса'
/*
insert tPrices
      (Name, Flag)
          select '24H',  1
union all select '48H',  1
union all select 'FAST', 1
union all select 'EMIR', 1
union all select 'EMIS', 1 
union all select 'EMIN', 1
union all select 'EMIL', 1
union all select 'EMIZ', 1
union all select 'OPTA', 1
union all select 'MOTO', 1

--*/