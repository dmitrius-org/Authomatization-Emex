if OBJECT_ID('tGrantObject') is null
--drop table tGrantObject
/* **********************************************************
tGrantObject - Права 
********************************************************** */
create table tGrantObject
(
 GrantObjectID     numeric(18, 0) identity  --
,ObjectID          numeric(18, 0)           -- 
,ObjectType        int                      -- 0 - пользователь
                                            -- 1 - группа
,LinkID            numeric(18, 0)           -- 
,LinkType          int                      --                        
)
go
create unique index ao1 on tGrantObject(ObjectType, ObjectID, LinkType, LinkID)
go
grant all on tGrantObject to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tGrantObject', @desc = 'Права доступа пользователя к объектам системы'