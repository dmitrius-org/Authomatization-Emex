IF OBJECT_ID('tEmployees') is null
--drop table tEmployees
/* **********************************************************
tEmployees - Менеджеры/Сотрудники
********************************************************** */
create table tEmployees
(
 EmployeeID           numeric(18,0)  identity --  
,Brief                nvarchar(256)  not null --
,Name	              nvarchar(512)  null     -- 
--
,UserID               numeric(18,0) default dbo.GetUserID()
,inDatetime           datetime      default GetDate()      --
,updDatetime          datetime      default GetDate()      --
)
go
create unique index ao1 on tEmployees(EmployeeID)
go
create unique index ao2 on tEmployees(Brief)
go
grant all on tClients to public
go
exec dbo.sys_setTableDescription @table = 'tEmployees', @desc = 'Таблица Менеджеры'
