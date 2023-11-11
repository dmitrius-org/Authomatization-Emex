if OBJECT_ID('tCurrencyRate') is null
--drop table tCurrencyRate
/* 
tCurrencyRate - курсы
*/
create table tCurrencyRate
(
 NumCode           nvarchar(3)    --
,CharCode	       nvarchar(3)  
,Nominal	       float
,Name	           nvarchar(255) 
,Value	           float
,OnDate            date --default getdate()
)
go
create unique index ao1 on tCurrencyRate(NumCode, OnDate)
go
create unique index ao2 on tCurrencyRate(CharCode, OnDate)
go
grant all on tCurrencyRate to public
go
exec dbo.sys_setTableDescription @table = 'tCurrencyRate', @desc = 'Таблица курсов'