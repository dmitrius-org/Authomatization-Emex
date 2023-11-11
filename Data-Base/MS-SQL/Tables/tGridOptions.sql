if OBJECT_ID('tGridOptions') is null
--drop table tGridOptions
/* **********************************************************
tGridOptions - настройки таблиц
********************************************************** */
create table tGridOptions
(
 UserID           numeric(18,0)  not null --  
,Grid             nvarchar(60)   not null --  -- 
,[Column]         nvarchar(60)   not null --  -- 
,Position         int               
,Width            int
,Visible          bit
)
go
create unique index ao1 on tGridOptions(UserID, Grid, [Column])
go
grant all on tGridOptions to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tGridOptions', @desc = 'Настройки таблиц'
