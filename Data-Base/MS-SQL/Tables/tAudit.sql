if OBJECT_ID('tAudit') is null
--drop table tAudit
/* **********************************************************
tAudit - Аудит действий пользователя
********************************************************** */
create table tAudit
(
 AuditID           numeric(18, 0) identity  --
,ObjectTypeID      numeric(18, 0)   -- тип объекта 
,ObjectID          numeric(18, 0)   -- ИД объекта по которому ведется аудит
,ActionID          numeric(18, 0)   -- ИД выполняемое дейстие из tAction
,Comment           nvarchar(1024)
,UserID            numeric(18, 0)   -- 
,HostInfoID        nvarchar(256) null
,InDateTime        DateTime      default getdate()   -- 
)
go
create index ao1 on tAudit(UserID, ObjectID)
go
create index ao2 on tAudit(ObjectTypeID, ObjectID)
go
grant select on tAudit to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tAudit', @desc = 'Таблица аудита'

