if OBJECT_ID('tPriceTermProfile') is null
--  drop table tPriceTermProfile
/* **********************************************************
tPriceTermProfile - Профиль цены и срока
********************************************************** */
create table tPriceTermProfile
(
 PriceTermProfileID     int  identity --  
,PriceLogo              varchar(30)    --
,Term	                int    -- 
)
go
create unique index ao1 on tPriceTermProfile(PriceTermProfileID)
go
create unique index ao2 on tPriceTermProfile(PriceLogo)
go
grant all on tPriceTermProfile to public
go
exec dbo.sys_setTableDescription @table = 'tPriceTermProfile', @desc = 'Таблица соответствия прайса и срока доставки'