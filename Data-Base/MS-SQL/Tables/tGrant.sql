if OBJECT_ID('tGrant') is null
--drop table tGrant
/* **********************************************************
tGrant - Права 
********************************************************** */
create table tGrant
(
 GrantID           numeric(18, 0) identity  --
,UserID            numeric(18, 0)   -- 
,MenuID            numeric(18, 0)   --  
)
go
create unique index ao1 on tGrant(UserID, MenuID)
go
grant all on tGrant to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tGrant', @desc = 'Права доступа пользователя к приложению'
