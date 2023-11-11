if OBJECT_ID('tSearchPrice') is null
--drop table tSearchPrice
/* **********************************************************						
tSearchPrice - список прайсов для поисковой выдчи клиентам
********************************************************** */
create table tSearchPrice
(
 PriceID           numeric(18,0)  identity --  
,MakeLogo          varchar(30)    -- наименоване прайса
,Synthetic         bit            -- тип: синтетический прайс

)
go
create unique index a1 on tSearchPrice(PriceID)
go
create unique index ao2 on tSearchPrice(MakeLogo)
go
grant all on tSearchPrice to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tSearchPrice', @desc = 'Список прайсов для поисковой выдчи клиентам'
-- Описание полей
exec dbo.sys_setTableDescription 'tSearchPrice', 'PriceID'                 ,'Уникальный идентификатор '
/*
insert tSearchPrice
      (MakeLogo, Synthetic)
          select '24H',  0
union all select '48H',  0
union all select 'FAST', 0
union all select 'EMIR', 0
union all select 'EMIS', 0
union all select 'EMIN', 0
union all select 'EMIL', 0
union all select 'EMIZ', 0
union all select 'OPTA', 0
union all select 'MOTO', 0
--*/