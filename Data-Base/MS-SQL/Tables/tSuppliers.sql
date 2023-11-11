if OBJECT_ID('tSuppliers') is null
--  drop table tSuppliers
/* **********************************************************
tSuppliers - Поставщики
********************************************************** */
create table tSuppliers
(
 SuppliersID       numeric(18,0)  identity --  
,Brief             nvarchar(256)  not null --
,Name	           nvarchar(512)  null  -- 
,PriceName         nvarchar(32)   null  -- 
,EmexUsername      nvarchar(32)   null  --Пользователь для интеграции
,EmexPassword      nvarchar(32)   null  --Пароль для интеграции
--
,UserID            numeric(18,0) default dbo.GetUserID()
,inDatetime        datetime      default GetDate()      --
,updDatetime       datetime      default GetDate()      --

)
go
create unique index ao1 on tSuppliers(SuppliersID)
go
create unique index ao2 on tSuppliers(Brief, PriceName)
go
grant all on tSuppliers to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tSuppliers', @desc = 'Таблица Поставщики'
