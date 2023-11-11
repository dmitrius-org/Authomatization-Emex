if OBJECT_ID('tRetCode') is null
--drop table tRetCode
/* **********************************************************
tRetCode - коды ошибок
********************************************************** */
create table tRetCode
(
 RetCode           numeric(18,0)   --  
,Message           nvarchar(512)       --
)
go
create unique index ao1 on tRetCode(RetCode)
go
grant all on tRetCode to public
go