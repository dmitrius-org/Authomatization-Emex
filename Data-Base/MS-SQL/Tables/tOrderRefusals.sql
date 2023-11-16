if OBJECT_ID('tOrderRefusals') is null
--  drop table tOrderRefusals
/* **********************************************************
tOrderRefusals - Таблица отказов
********************************************************** */
create table tOrderRefusals
(
 OrderRefusalsID      numeric(18,0)  identity --  
,FileName             nvarchar(256)  
,Flag                 int
,UserID               numeric(18,0) default dbo.GetUserID()
,InDateTime           DateTime default GetDate()
,UpdDateTime          DateTime default GetDate()
)
go
create unique index ao1 on tOrderRefusals(OrderRefusalsID)
go
grant all on tOrderRefusals to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tOrderRefusals', @desc = 'Таблица отказов'