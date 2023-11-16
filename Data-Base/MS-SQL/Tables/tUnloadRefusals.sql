if OBJECT_ID('tUnloadRefusals') is null
--  drop table tUnloadRefusals
/* **********************************************************
tUnloadRefusals - Таблица отказов
********************************************************** */
create table tUnloadRefusals
(
 OperDate             datetime -- дата выгрузки ответа
,FileName             nvarchar(256)  
,ClientID             numeric(18, 0)
,ClientName           nvarchar(512)
,OrderNum             nvarchar(128)
,MakeLogo             nvarchar(32)
,DetailNumber         nvarchar(128)
,Reference            nvarchar(128)
,Quantity             int 
,PricePurchase        money
,AmountPurchase       money
,Flag                 int
,InDateTime           DateTime default GetDate()
)
go
create index ao2 on tUnloadRefusals(OperDate)
go
create index ao3 on tUnloadRefusals(ClientID, DetailNumber, Reference, Quantity)
go
grant all on tUnloadRefusals to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tUnloadRefusals', @desc = 'Таблица отказов'