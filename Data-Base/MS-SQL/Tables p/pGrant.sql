drop table if exists pGrant
go
/* **********************************************************
pGrant - Временная таблица прав
********************************************************** */
create table pGrant
(
 Spid              numeric(18, 0) 
,GrantID           numeric(18, 0)   --
,ObjectID          numeric(18, 0)   -- 
,ParentID          numeric(18, 0)   -- 
,MenuID            numeric(18, 0)   --
,N                 int
,Caption           nvarchar(512)    -- 
,Type              int
,Value             bit              -- Индивидуальное право объекта
,GroupValue        bit              -- Право группы/роли
,IsGroup           bit              -- Входит в группу  
,Groups            nvarchar(512)    -- Наименовния групп
)
go
create unique index ao1 on pGrant(Spid, ObjectID, MenuID)
go
create index ao2 on pGrant(GrantID)
go
grant all on pGrant to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pGrant', @desc = 'Временная таблица прав'
