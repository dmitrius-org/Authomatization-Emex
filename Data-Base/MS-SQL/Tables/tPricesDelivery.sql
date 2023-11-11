if OBJECT_ID('tPricesDelivery') is null
--drop table tPricesDelivery
/* **********************************************************						
tPricesDelivery - скрок доставки по прайсам
********************************************************** */
begin
    create table tPricesDelivery
    (
     Name               varchar(30) 
    ,ProfilesDeliveryID	int -- способ доставки
    ,DeliveryTime       int -- Срок поставки
    ,Flag               int
    );
    
    create unique index a1 on tPricesDelivery(Name, ProfilesDeliveryID)
end
go
grant all on tPricesDelivery to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tPricesDelivery', @desc = 'Скрок доставки по прайсам'
-- Описание полей
exec dbo.sys_setTableDescription 'tPricesDelivery', 'Name',                'Наименование прайса'

/*
insert tPricesDelivery (Name, ProfilesDeliveryID)
select p.Name
      ,pd.ProfilesDeliveryID
  from tPrices p (nolock)
 inner join tProfilesDelivery pd (nolock) on 1=1
 order by p.Name
 --*/