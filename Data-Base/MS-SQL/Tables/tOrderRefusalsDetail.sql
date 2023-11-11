if OBJECT_ID('tOrderRefusalsDetail') is null
--drop table tOrderRefusalsDetail
/* **********************************************************

********************************************************** */
create table tOrderRefusalsDetail
(
 ID                   numeric(18,0)  identity -- 
,OrderRefusalsID      numeric(18,0)           --
,OrderID              numeric(18,0)           --
,Flag                 int                     --
)
go
create unique index ao1 on tOrderRefusalsDetail(ID)
go
create index ao2 on tOrderRefusalsDetail(OrderRefusalsID, OrderID)
go
grant all on tOrderRefusalsDetail to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tOrderRefusalsDetail', @desc = 'Таблица детализации по отказам'