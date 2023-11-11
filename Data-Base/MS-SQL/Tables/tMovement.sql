if OBJECT_ID('tMovement') is null
--drop table tMovement
/* **********************************************************
tMovement - 
********************************************************** */
begin
create table tMovement
(
 OrderID                 numeric(18,0) 
,OrderNumber             numeric(18,0)
,Comment                 nvarchar(256)  -- комментарий
,OrderDetailSubId        nvarchar(64)   -- уникальный идентификатор строки заказа в системе EmEx
,DocumentDate            datetime       -- дата документа
,PriceOrdered            decimal(18,2)  -- обещанна¤ клиенту цена детали (видна насайте)
,PriceSale               decimal(18,2)  -- цена продажи детали дл¤ клиента
,MakeLogo                nvarchar(32)   -- лого бренда
,DetailNum               nvarchar(32)   -- номер детали
,Quantity                int            -- количество
,Condition               nvarchar(32)   -- код статуса детали
,Reference               nvarchar(32)   -- информация, позволяющая клиенту идентифицировать запчасть. Часть этой информации может быть распечатана в виде штрих-кода на стикере запчасти 
,DetailNameRus           nvarchar(256)
,DetailNameEng           nvarchar(256)
,CustomerSubId           nvarchar(32)   -- идентификатор запчасти клиента
,DestinationLogo         nvarchar(32)   -- тип отгрузки (EMEW Ц авиа, CNTE Ц контейнер)
,PriceLogo               nvarchar(32)   -- лого прайслиста
,ReplacementMakeLogo     nvarchar(128)  -- Бренд замены
,ReplacementDetailNumber nvarchar(32)   -- Номер замены
,StatusId                int
,StateText               nvarchar(256)
,Flag                    int
,Tag                     int 
)
end
go
grant all on tMovement to public
go
-- !! индекс не уникальный !! 
create index ao1 on tMovement(OrderNumber, DetailNum, CustomerSubId, OrderDetailSubId)
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tMovement', @desc = 'Движение по номеру заказа.'
