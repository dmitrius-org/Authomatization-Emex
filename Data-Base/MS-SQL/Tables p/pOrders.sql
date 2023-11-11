drop table if exists pOrders
/*
pOrders - временная таблица для загрузки заказов
*/
go
create table pOrders
(
  Spid             numeric(18,0)  default @@spid--  
 ,ClientID         numeric(18,0) 
 ,Manufacturer     nvarchar(64)   --  2 Производитель	
 ,DetailNumber     nvarchar(32)   --  4 Номер детали
 ,Quantity         float          --  8 Количество
 ,DetailID         nvarchar(32)   --  5 ID
 ,DetailName	   nvarchar(512)  --  6 Название
 ,Price            money          -- 12 Цена продажи	
 ,Amount           money          -- 13 Сумма продажи
 ,OrderNum         nvarchar(64)   -- Номер заказа	
 ,OrderDate        nvarchar(32)   -- Дата заказа	
 ,PriceNum         nvarchar(64)   -- Лого прайса клиента	
 ,FileDate         datetime
)
go
grant all on pOrders to public
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pOrders', @desc = 'Временная таблица заказов. Используется для импорта заказов в базу данных'
