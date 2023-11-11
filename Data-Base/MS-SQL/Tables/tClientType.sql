if OBJECT_ID('tClientType') is null
--drop table tClientType
/* **********************************************************
tClientType - Типы клиентов
********************************************************** */
create table tClientType
(
 ClientTypeID      numeric(18,0)  identity --  
,Name	           nvarchar(256)           -- Название
,Comment           nvarchar(512)           -- Описание 
,Prepayment        bit                     -- Предоплата 
,PrepaymentAmount  money                   -- Предоплата 
,Margin            money                   -- Наценка
,IsActive          bit                     -- Активен
--
,UserID            numeric(18,0) default dbo.GetUserID()
,inDatetime        datetime      default GetDate()      --
,updDatetime       datetime      default GetDate()      --
)
go
create unique index ao1 on tClientType(ClientTypeID)
go
create unique index ao2 on tClientType(Name)
go
grant all on tClientType to public
go
exec dbo.sys_setTableDescription @table = 'tClientType', @desc = 'Типы клиентов'
go
/*
insert tClientType (Name, Comment, Prepayment, PrepaymentAmount, Margin, IsActive) select 'Физическое лицо', 'Периодические частные заказы', 1, 100, 50, 1
insert tClientType (Name, Comment, Prepayment, PrepaymentAmount, Margin, IsActive) select 'Мелкий опт', 'Постоянные заказы до 1 млн. руб в месяц', 1, 50, 40, 1
insert tClientType (Name, Comment, Prepayment, PrepaymentAmount, Margin, IsActive) select 'Крупный опт', 'Постоянные заказы от 1 млн. руб в месяц', 1, 50, 30, 1
--*/

