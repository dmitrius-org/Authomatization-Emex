drop table if exists pOrdersFinIn
/* **********************************************************
pOrdersFinIn - Расчет финансовых показателей
               Список заказов для расчета фин. показателей
********************************************************** */
go
create table pOrdersFinIn
(
  Spid             numeric(18,0)  
 ,OrderID          numeric(18,0) 
)
go
grant all on pOrdersFinIn to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pOrdersFinIn', @desc = 'Расчет финансовых показателей. Список заказов для расчета фин. показателей'
go
drop table if exists pOrdersFin
/* **********************************************************
pOrdersFin - Расчет финансовых показателей
             Результат расчтеа фин. показателей
********************************************************** */
go
create table pOrdersFin
(
  Spid             numeric(18,0)  
 ,OrderDate        datetime
 ,OrderID          numeric(18,0) 
 ,ClientID         numeric(18,0) 
 ,PriceName        nvarchar(64)     -- прайс клиента
 ,Quantity	       int              -- количество
 ,Taxes	           float            -- Комиссия + Налоги
 ,Commission	   float            -- Комиссия за оплату
 ,Margin           float            -- Наценка
 ,ExtraKurs        float            -- Комиссия на курс
 ,Course           float            -- Курс
 ,CourseExt        float            -- Курс с комиссией
 ,PdWeightKG       float            -- Стоимость кг	
 ,PdVolumeKG       float            -- Стоимость vкг
 ,Price            float            -- Продажа	
 ,PricePurchase    float            -- Закупка
 ,PriceCommission  float            -- Комиссия от продажи	
 ,WeightKG         float            -- Вес физический
 ,VolumeKG         float            -- Вес объемный	
 ,WeightKGF        float            -- Вес физический
 ,VolumeKGF        float            -- Вес объемный	
 ,Purchase         float            -- Закупка c комиссией	
 ,Deliveryfkg      float            -- Доставка fkg	
 ,Deliveryvkg      float            -- Доставка vkg	
 ,Delivery         float            -- Доставка итого	
 ,CostPrice        float            -- Себестоимость	
 ,Income           decimal(18, 2)   -- Доход	
 ,IncomePrc        decimal(18, 2)   -- Доход в процентах	
 ,MarginF          decimal(18, 2)   -- Наценка	
 ,Profit           decimal(18, 2)   -- Рентабельность
)
go
grant all on pOrdersFin to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pOrdersFin', @desc = 'Расчет финансовых показателей. Результат расчтеа фин. показателей'
