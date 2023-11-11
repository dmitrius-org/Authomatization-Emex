if OBJECT_ID('tBasket') is null
--drop table tBasket
/* **********************************************************
tBasket - 
********************************************************** */
create table tBasket
(
 BasketID                numeric(18, 0) identity
,ClientID                numeric(18, 0)
,Make                    nvarchar(10)-- лого бренда детали
,MakeName                nvarchar(64)-- название бренда
,DetailNum               nvarchar(64)-- номер детали
,PartNameRus             nvarchar(256)-- русское название детали
,PartNameEng             nvarchar(256)-- английское название детали
,PriceLogo               nvarchar(64)-- лого прайслиста
,GuaranteedDay           nvarchar(64)-- гарантированный срок поставки детали
,Quantity                int         -- Количество
,Price                   money       -- цена детали
,Amount                  money       -- сумма 
,Reference               nvarchar(32) 
,WeightGr                money-- вес детали в граммах

)
go
grant all on tBasket to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tBasket', @desc = 'Корзина'