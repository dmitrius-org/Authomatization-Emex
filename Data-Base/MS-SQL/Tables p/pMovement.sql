drop table if exists pMovement
go
/* pMovement
   Движения по номеру заказа. Результат вызова сервиса MovementByOrderNumber
*/
create table pMovement
(
 ID                      numeric(18,0)  identity   
,Spid                    numeric(18,0)  default @@spid--  
,OrderID                 numeric(18,0)  -- идентификатор заказа в системе
--,ClientID	           numeric(18,0)
,OrderNumber             numeric(18,0)  -- номер заказа
,Comment                 nvarchar(256)  -- комментарий
,OrderDetailSubId        nvarchar(64)   -- уникальный идентификатор строки заказа в системе EmEx
,DocumentDate            datetime       -- дата документа
,PriceOrdered            decimal(18,2)  -- обещанная клиенту цена детали (видна насайте)
,PriceSale               decimal(18,2)  -- цена продажи детали для клиента
,MakeLogo                nvarchar(32)   -- лого бренда
,DetailNum               nvarchar(32)   -- номер детали
,Quantity                int            -- количество
,Condition               nvarchar(32)   -- код статуса детали
,Reference               nvarchar(32)   -- Текстовая информация, позволяющая клиенту идентифицировать запчасть. Часть этой информации может быть распечатана в виде штрих-кода на стикере запчасти 
,DetailNameRus           nvarchar(256)  -- описание детали
,DetailNameEng           nvarchar(256)  -- описание детали
,CustomerSubId           nvarchar(32)   -- идентификатор запчасти клиента
,DestinationLogo         nvarchar(32)   -- тип отгрузки (EMEW – авиа, CNTE – контейнер)
,PriceLogo               nvarchar(32)   -- лого прайслиста
,ReplacementMakeLogo     nvarchar(128)  -- Бренд замены
,ReplacementDetailNumber nvarchar(32)   -- Номер замены
,StatusId                int            -- ид статуса
,StateText               nvarchar(256)  -- описание статуса
,Flag                    int            -- технические поля
,Tag                     int            -- технические поля
,N                       int            -- технические поля
)
go
grant all on pMovement to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pMovement', @desc = 'Движения по номеру заказа. Результат вызова сервиса MovementByOrderNumber'
