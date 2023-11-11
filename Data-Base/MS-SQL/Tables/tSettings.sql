if OBJECT_ID('tSuppliers') is null
--  drop table tSuppliers
/* **********************************************************
tSettings - Настройки приложения
********************************************************** */
create table tSettings
(
 SettingsID        numeric(18,0)  identity -- Ид
,GroupID           numeric(18,0)
,Brief             nvarchar(64)   not null -- сокращение
,Name	           nvarchar(128)  not null -- Наименование
,Comment           nvarchar(256)  not null -- Комментарий
,Val               nvarchar(256)  not null -- Значение
,SettingType       int                     -- Тип данных
)
go
create unique index ao1 on tSettings(SettingsID)
go
create unique index ao2 on tSettings(Brief)
go
grant all on tSettings to public
go
exec dbo.sys_setTableDescription @table = 'tSettings', @desc = 'Настройки приложения'
go
