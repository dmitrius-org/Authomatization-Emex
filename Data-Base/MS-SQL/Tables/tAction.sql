if OBJECT_ID('tAction') is null
--drop table tAction
/* **********************************************************
tAction - типы действие TFormAction
********************************************************** */
create table tAction
(
 ActionID     numeric(18, 0) --
,Brief        nvarchar(32)   -- 
,Name         nvarchar(512)
 PRIMARY KEY (ActionID)
)
go
create unique index ao2 on tAction(Brief)
go
grant all on tAction to public
go