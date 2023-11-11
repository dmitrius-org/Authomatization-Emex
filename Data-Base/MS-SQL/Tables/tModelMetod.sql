if OBJECT_ID('tModelMetod') is null
--drop table tModelMetod
/* **********************************************************
tModelExt - Расширение таблицы tModel
            Методы настроенные на действии
********************************************************** */
create table tModelMetod
(
 ModelMetodID      numeric(18,0)  identity  --  
,ModelID           numeric(18,0)  not null  --
,Metod             nvarchar(128)            --
,MetodRollback     nvarchar(128)            --
,Comment           nvarchar(512)  null      --
,Flag              int            default 0 --
,Type              int            not null  --
,N                 int            default 0 --
)
go
create unique index ao1 on tModelMetod(ModelMetodID)
go
create unique index ao2 on tModelMetod(ModelID, Type, Metod)
go
grant all on tModelMetod to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tModelMetod', @desc = 'Расширение таблицы tModel'
