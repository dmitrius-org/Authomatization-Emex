if OBJECT_ID('pGrantObject') is not null
  drop table pGrantObject
go
/* **********************************************************
pGrantObject - Временная таблица объектов учета
********************************************************** */
create table pGrantObject
(
 Spid              numeric(18, 0) 
,GrantObjectID     numeric(18, 0)   --
,ObjectType        int -- 0 -- пользователь
                       -- 1 -- группа
,ObjectID          numeric(18, 0)   -- 

,LinkType          int   -- 
,LinkID            numeric(18, 0)   
--
)
go
create unique index ao1 on pGrantObject(Spid, ObjectType, ObjectID, LinkType, LinkID)
go
grant all on pGrantObject to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pGrantObject', @desc = 'Права доступа пользователя к объектам системы'





 