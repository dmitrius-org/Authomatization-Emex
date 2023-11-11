if OBJECT_ID('tRetMessage') is null
--drop table tRetMessage
/* **********************************************************
tRetMessage - коды ошибок
********************************************************** */
create table tRetMessage
(
 Spid              numeric(18, 0) default @@Spid
,RetCode           numeric(18, 0)   --  
,Message           nvarchar(1024)       --
)
go
create index ao1 on tRetMessage(Spid, RetCode)
go
grant all on tRetMessage to public
go