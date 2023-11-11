if OBJECT_ID('tProperty') is null
  drop table tProperty
/* **********************************************************
tProperty - 
********************************************************** */
create table tProperty
(
 PropertyID       numeric(18, 0)  --
,ObjectTypeID     numeric(18, 0) 
,Brief            nvarchar(128)   -- 
,Name             nvarchar(512)

--,Flag             int -- 1 - поддерживает модель сосотояния
                        -- 2 - Активна
)
go
create unique index ao1 on tProperty(PropertyID)
go
create unique index ao2 on tProperty(Brief)
go
grant select on tProperty to public
go
exec dbo.sys_setTableDescription @table = 'tProperty', @desc = 'Типы объектов системы'
go
exec dbo.sys_setTableDescription 'tProperty', 'PropertyID'                 ,'Идентификатор'
go
insert tProperty (PropertyID, ObjectTypeID, Brief, Name) select 1, 101, 'EmexOrderStateSync', 'Синхронизация статусов заказов' 
