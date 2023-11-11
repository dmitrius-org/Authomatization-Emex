drop table if exists pBasketDetails
go
/* **********************************************************
pBasketDetails -  результат выполнения сервиса GetBasketDetails
********************************************************** */
create table pBasketDetails
(
 Spid                  numeric(18,0) default @@spid--  
,OrderID               numeric(18,0) -- ИД заказа
,ClientID              numeric(18,0) -- ИД Клиента
,Comments              nvarchar(64)  -- комментарий
,UploadedPrice         decimal(18,2) -- цена заданная клиентом
,CoeffMaxAgree         decimal(18,2) -- максимальный коэффициент превышения цены продажи для клиента над ценой, показанной на сайте
,Price                 decimal(18,2) -- цена продажи для клиента, расчитанная по параметрам клиента
,CustomerLogo          nvarchar(32)  -- лого клиента
,bitConfirm            Bit           -- признак, что строчка корзины будет включена в заказ
,bitAgree              Bit           -- признак что клиент созласен на превышение цены свыше коэффициента CoeffMaxAgree
,bitOnlyThisBrand      Bit           -- признак ТОЛЬКО ЭТОТ БРЕНД
,Date_add              datetime      -- дата/время добавления детали в корзину
,BasketId              bigint        -- идентификатор строки корзины
,MakeLogo              nvarchar(32)  -- лого бренда
,DetailNum             nvarchar(32)  -- номер детали
,DestinationLogo       nvarchar(32)  -- тип отгрузки (EMEW – авиа, CNTE – контейнер)
,PriceLogo             nvarchar(32)  -- лого прайслиста
,Quantity              int           -- количество
,bitOnlyThisNumber     Bit           -- признак ТОЛЬКО ЭТОТ НОМЕР
,bitOnlyThisQuantity   Bit           -- признак ТОЛЬКО ЭТО КОЛИЧЕСТВО
,bitWait               Bit           -- признак СОГЛАСЕН ЖДАТЬ 1 месяц
,Reference             nvarchar(32)  -- Текстовая информация, позволяющая клиенту идентифицировать запчасть. Часть этой информации может быть распечатана в виде штрих-кода на стикере запчасти
,CustomerSubId         nvarchar(32)  -- идентификатор запчасти клиента
,TransportPack         nvarchar(100) -- тип упаковки (WOOD – требуется деревянная обрешетка, CARTON – отправка в картонной коробке)
,DetailWeight          decimal(18,2) -- вес детали в кг
,EmExWeight            decimal(18,2) -- последнее изменение веса детали, сделанное на нашем складе
)
go
grant all on pBasketDetails to public
go
create index ao1 on pBasketDetails(Spid, OrderID)
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pBasketDetails', @desc = 'Корзина клиента (подклиента). Результат выполнения сервиса GetBasketDetails'
