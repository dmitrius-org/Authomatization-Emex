if OBJECT_ID('tClientReliation') is null
--drop table tClientReliation
/* **********************************************************
tClientReliation - связь с клиентами
********************************************************** */
create table tClientReliation
(
 ClientReliationID    numeric(18,0)  identity --  
,ClientID             numeric(18,0)  not null --
,LinkID	              numeric(18,0)  not null -- 
,LinkType             numeric(18,0)  not null --tObjectType.ObjectTypeID   
--
,UserID               numeric(18,0) default dbo.GetUserID()
,inDatetime           datetime      default GetDate()      --
,updDatetime          datetime      default GetDate()      --
)
go
create unique index ao1 on tClientReliation(ClientReliationID)
go
create unique index ao2 on tClientReliation(LinkType, ClientID, LinkID)
go
grant all on tClientReliation to public
go
exec dbo.sys_setTableDescription @table = 'tClientReliation', @desc = 'Связь с клиентами'
