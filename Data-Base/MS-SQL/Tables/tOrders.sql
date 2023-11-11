if OBJECT_ID('tOrders') is null
--  drop table tOrders
/* **********************************************************
tOrders - Заказы
********************************************************** */
create table tOrders
(
 OrderID                 numeric(18,0)  identity --
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
--
,Flag                    int
,ParentID                numeric(18,0)  -- Родительский идентификатор заказа. Проставляется при дроблении заказа.
,ID                      numeric(18,0) 
,FileDate                datetime
,Commission              money          -- Комиссия от продажи. Рассчитывается в момент создания заказа и не меняется	
--
,UserID                  numeric(18,0) default dbo.GetUserID()
,inDatetime              datetime      default GetDate()      --
,updDatetime             datetime      default GetDate()      --

)
go
create unique index ao1 on tOrders(OrderID)
go
create index ao2 on tOrders(ClientID, OrderNum)
go
grant select on tOrders to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tOrders', @desc = 'Таблица Заказы'
-- Описание полей
exec dbo.sys_setTableDescription 'tOrders', 'OrderID'                 ,'Уникальный идентификатор '
exec dbo.sys_setTableDescription 'tOrders', 'ClientID'                ,'Идентификатор клиента tClients.ClientID'	
exec dbo.sys_setTableDescription 'tOrders', 'OrderDate'               ,'Дата заказа'
exec dbo.sys_setTableDescription 'tOrders', 'PriceLogo'               ,'Лого прайса клиента'
exec dbo.sys_setTableDescription 'tOrders', 'CustomerPriceLogo'       ,'Наименование прайса клиента по которым заказываются детали'
exec dbo.sys_setTableDescription 'tOrders', 'OrderNum'                ,'Номер заказа'
exec dbo.sys_setTableDescription 'tOrders', 'StatusID'                ,'Статус tStatus.StatusID'
exec dbo.sys_setTableDescription 'tOrders', 'isCancel'                ,'Отказ'
exec dbo.sys_setTableDescription 'tOrders', 'isCancelToClient'        ,'Отказ отправлен клиенту'
exec dbo.sys_setTableDescription 'tOrders', 'Manufacturer'            ,'Производитель'
exec dbo.sys_setTableDescription 'tOrders', 'DetailNumber'            ,'Номер детали'
exec dbo.sys_setTableDescription 'tOrders', 'DetailName'              ,'Название детали'
exec dbo.sys_setTableDescription 'tOrders', 'DetailID'                ,'ID'
exec dbo.sys_setTableDescription 'tOrders', 'Quantity'                ,'Количество'
exec dbo.sys_setTableDescription 'tOrders', 'Price'                   ,'Цена продажи'
exec dbo.sys_setTableDescription 'tOrders', 'Amount'                  ,'Сумма продажи'	
exec dbo.sys_setTableDescription 'tOrders', 'PricePurchase'           ,'Цена закупки	с учетом скидки'
exec dbo.sys_setTableDescription 'tOrders', 'PricePurchaseOrg'        ,'Исходная уена закупки'
exec dbo.sys_setTableDescription 'tOrders', 'AmountPurchase'          ,'Сумма закупки'
exec dbo.sys_setTableDescription 'tOrders', 'Discount'                ,'Скидка поставщика на закупку товара'
exec dbo.sys_setTableDescription 'tOrders', 'PricePurchaseF'          ,'Цена закупки факт'
exec dbo.sys_setTableDescription 'tOrders', 'AmountPurchaseF'         ,'Сумма закупки факт'
exec dbo.sys_setTableDescription 'tOrders', 'WeightKG'                ,'Вес Физический из прайса'
exec dbo.sys_setTableDescription 'tOrders', 'VolumeKG'                ,'Вес Объемный из прайса'
exec dbo.sys_setTableDescription 'tOrders', 'Margin'                  ,'Наценка из прайса'
exec dbo.sys_setTableDescription 'tOrders', 'MarginF'                 ,'Наценка факт'
exec dbo.sys_setTableDescription 'tOrders', 'Profit'                  ,'Рентабельность'
exec dbo.sys_setTableDescription 'tOrders', 'Income'                  ,'Доход'
exec dbo.sys_setTableDescription 'tOrders', 'PlanDate'                ,'Плановая дата поступления поставщику'	
exec dbo.sys_setTableDescription 'tOrders', 'Rest'                    ,'Остаток срока до поступления поставщику'
exec dbo.sys_setTableDescription 'tOrders', 'DateDeliveredToSupplier' ,'Доставлена поставщику'
exec dbo.sys_setTableDescription 'tOrders', 'ProfilesDeliveryID'      ,'tProfilesDelivery.ProfilesDeliveryID - ИД профиля управления выгрузкой'
exec dbo.sys_setTableDescription 'tOrders', 'DaysReserveDeparture'    ,'Дней запаса до вылета'	
exec dbo.sys_setTableDescription 'tOrders', 'NextDateDeparture'       ,'Ближайшая дата вылета'	
exec dbo.sys_setTableDescription 'tOrders', 'DateDeliveryToCustomer'  ,'Дата поставки клиенту'	
exec dbo.sys_setTableDescription 'tOrders', 'TermDeliveryToCustomer'  ,'Срок поставки клиенту'	
exec dbo.sys_setTableDescription 'tOrders', 'RestDeliveryToCustomer'  ,'Остаток срока до поставки клиенту'
exec dbo.sys_setTableDescription 'tOrders', 'ReplacementMakeLogo'     ,'Бренд замены'
exec dbo.sys_setTableDescription 'tOrders', 'ReplacementDetailNumber' ,'Номер замены'
exec dbo.sys_setTableDescription 'tOrders', 'ReplacementPrice'        ,'Цена замены'
exec dbo.sys_setTableDescription 'tOrders', 'PriceID'                 ,'Ид детали tPrice.PriceID'
exec dbo.sys_setTableDescription 'tOrders', 'MakeLogo'                ,'Лого бренда'
exec dbo.sys_setTableDescription 'tOrders', 'BasketId'                ,'Идентификатор строки корзины в emexdwc.ae'
exec dbo.sys_setTableDescription 'tOrders', 'EmexOrderID'             ,'Номер заказ в emexdwc.ae'
exec dbo.sys_setTableDescription 'tOrders', 'EmexQuantity'            ,'Количество в emexdwc.ae'
exec dbo.sys_setTableDescription 'tOrders', 'OrderDetailSubId'        ,'OrderDetailSubId – уникальный идентификатор строки заказа в системе EmEx'
exec dbo.sys_setTableDescription 'tOrders', 'OverPricing'             ,'Превышение Цены'
exec dbo.sys_setTableDescription 'tOrders', 'Warning'                 ,'Предупреждение'
exec dbo.sys_setTableDescription 'tOrders', 'CustomerSubId'           ,'Идентификатор запчасти клиента'
exec dbo.sys_setTableDescription 'tOrders', 'Reference'               ,'Текстовая информация, позволяющая клиенту идентифицировать запчасть. Часть этой информации может быть распечатана в виде штрих-кода на стикере запчасти'
exec dbo.sys_setTableDescription 'tOrders', 'ParentID'                ,'Родительский идентификатор заказа. Проставляется при дроблении заказа.'
exec dbo.sys_setTableDescription 'tOrders', 'Invoice'                 ,'Инвойс, номер отправки'
exec dbo.sys_setTableDescription 'tOrders', 'FileDate'                ,'Дата файла'
exec dbo.sys_setTableDescription 'tOrders', 'DestinationLogo'         ,'Направление отгрузки'
exec dbo.sys_setTableDescription 'tOrders', 'Commission'              ,'Комиссия от продажи. Рассчитывается в момент создания заказа и не меняется	'
 