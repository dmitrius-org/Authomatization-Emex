if OBJECT_ID('hOrders') is null
--drop table hOrders
/* **********************************************************
hOrders - Заказы
********************************************************** */
create table hOrders
(
 ID                      numeric(18,0)  identity --
,ParentID                numeric(18,0)  -- Родительский идентификатор заказа. Проставляется при дроблении заказа.
,OrderID                 numeric(18,0)   --
,ClientID                numeric(18,0)  not null-- Клиент	
,OrderDate               datetime       not null-- Дата заказа	
,OrderNum                nvarchar(64)   -- Номер заказа	
,StatusID                numeric(18,0)  -- Статус	
,isCancel                bit            -- Отказ	
,isCancelToClient        bit            -- Отказ отправлен клиенту
,Manufacturer            nvarchar(128)  -- Производитель	
,CustomerPriceLogo       nvarchar(32)   -- Наименование прайса клиента по которым заказываются детали	
,PriceLogo               nvarchar(32)   -- Лого прайса клиента	
,DetailNumber            nvarchar(32)   -- Номер детали	
,DetailName	             nvarchar(512)  -- Название детали
,MakeLogo                nvarchar(30)  
,DetailID                nvarchar(32)   -- ID	
,Quantity                int            -- Количество	
,Price                   money          -- Цена продажи	
,Amount                  money          -- Сумма продажи
,PricePurchase           money          -- Цена закупки	с учетом скидки
,PricePurchaseOrg        money          -- Исходня цена закупки	
,AmountPurchase          money          -- Сумма закупки
,Discount                money          -- Скидка поставщика на закупку товара
,PricePurchaseF          money          -- Цена закупки факт	
,AmountPurchaseF         money          -- Сумма закупки факт	
,WeightKG                money          -- Вес Физический из прайса	
,VolumeKG                money          -- Вес Объемный из прайса	
,Margin                  money          -- Наценка из прайса	
,MarginF                 money          -- Наценка факт	
,Profit                  money          -- Рентабельность	
,Income                  money          -- Доход	
,IncomePRC               money          -- Доход %	
,PlanDate                datetime       -- Плановая дата поступления поставщику	
,Rest                    money          -- Остаток срока до поступления поставщику	
,DateDeliveredToSupplier datetime       -- Доставлена поставщику
,ProfilesDeliveryID      int            -- tProfilesDelivery.ProfilesDeliveryID - ИД профиля управления выгрузкой 
,DaysReserveDeparture    int            -- Дней запаса до вылета	
,NextDateDeparture       datetime       -- Ближайшая дата вылета	
,DateDeliveryToCustomer  datetime       -- Дата поставки клиенту	
,TermDeliveryToCustomer  int            -- Срок поставки клиенту	
,RestDeliveryToCustomer  int            -- Остаток срока до поставки клиенту
,ReplacementMakeLogo     nvarchar(32)   -- Бренд замены
,ReplacementDetailNumber nvarchar(32)   -- Номер замены
,ReplacementPrice        money          -- Цена замены	
,PriceID	             numeric(18, 0) -- Ид детали tPrice.PriceID
,BasketId                bigint         -- Идентификатор строки корзины
,EmexOrderID             integer        -- Номер заказа	
,EmexQuantity            int            -- Количество	
,CustomerSubId           nvarchar(32)   -- идентификатор запчасти клиента
,OrderDetailSubId        nvarchar(128)  -- OrderDetailSubId – уникальный идентификатор строки заказа в системе EmEx
,Reference               nvarchar(32)   -- Текстовая информация, позволяющая клиенту идентифицировать запчасть. Часть этой информации может быть распечатана в виде штрих-кода на стикере запчасти
,OverPricing             money          -- Превышение Цены
,Warning                 nvarchar(128)  -- Предупреждение
,Invoice                 nvarchar(64)   -- Инвойс, номер отправки
,DestinationLogo         nvarchar(20)   -- Направление отгрузки
,FileDate                datetime
,Commission              money          -- Комиссия от продажи	
,ClientOrderNum          int            -- Номер заказа	клиента
--
,Flag                    int
--
,UserID                  numeric(18,0) -- default dbo.GetUserID()
,inDatetime              datetime      -- default GetDate()      --
,updDatetime             datetime      -- default GetDate()      --
)
go
create unique index ao1 on hOrders(ID)
go
create index ao2 on hOrders(ParentID)
go
grant select on hOrders to public
go