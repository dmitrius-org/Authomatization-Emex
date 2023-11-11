if OBJECT_ID('tMakes') is null
--drop table tMakes
/* 

*/
create table tMakes
(
 MakesID           numeric(18,0)  identity --  
,Code              varchar(10)       --
,Name	           varchar(60) null  -- 
,Country	       varchar(60) null  --
,inDatetime        datetime default GetDate()      --
,updDatetime       datetime default GetDate()      --
)
go
create unique index ao1 on tMakes(MakesID)
go
create index ao2 on tMakes(Code)
go
grant all on tMakes to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tMakes', @desc = 'Список марок автозапчастей'