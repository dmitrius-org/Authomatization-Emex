if OBJECT_ID('tUser') is not null
  drop table tUser
go
/* **********************************************************
tUser - пользователи
********************************************************** */
create table tUser
(
 UserID            numeric(18,0)  identity --  
,Brief             nvarchar(512)  not null --
,Name	           nvarchar(512)  null  -- 
--,isAdmin	       bit      default 0  --
,isBlock	       bit      default 0  --
,DateBlock         datetime       null

,Login             nvarchar(512) 

,inDatetime        datetime default GetDate()      --
,updDatetime       datetime default GetDate()      --

--CONSTRAINT pk1 PRIMARY KEY  nonclustered  (UserID)
)
go
create unique index ao1 on tUser(UserID)
go
create unique index ao2 on tUser(Brief)
go
grant all on tUser to public
go
