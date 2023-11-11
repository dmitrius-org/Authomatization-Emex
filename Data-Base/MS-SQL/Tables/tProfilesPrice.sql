if OBJECT_ID('tProfilesPrice') is null
--drop table tProfilesPrice
/* **********************************************************
tProfilesPrice - профили управления загрузкой
********************************************************** */
create table tProfilesPrice
(
 ProfilesPriceID      int  identity --  
,isActive             bit
,PriceName            varchar(10)
,UpdateDate           datetime
)
go
create unique index ao1 on tProfilesPrice(ProfilesPriceID)
go
create unique index ao2 on tProfilesPrice(PriceName)
go
grant all on tProfilesPrice to public
go
exec dbo.sys_setTableDescription @table = 'tProfilesPrice', @desc = 'Профили управления загрузкой'