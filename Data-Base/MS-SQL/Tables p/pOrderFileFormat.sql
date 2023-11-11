drop table if exists pOrderFileFormat
go
/* **********************************************************
pOrderFileFormat - Формат файла с заказом
********************************************************** */
create table pOrderFileFormat
(
 Spid                       numeric(18,0) 
,ID                         numeric(18,0)  identity 
,OrderFileFormatID          numeric(18,0)  
,ClientID                   numeric(18,0) not null
,Folder                     nvarchar(512) --Папка	
,Firstline                  int           --Первая строка	
,Manufacturer               int           --Столбец Производитель	
,DetailNumber               int           --Столбец Номер детали	
,Quantity                   int           --Столбец Количество	
,DetailID                   int           --Столбец ID	
,DetailName                 int           --Столбец Наименование детали	
,Price                      int           --Столбец Цена	
,Amount                     int           --Столбец Сумма	
,OrderNum                   nvarchar(32)  --Ячейка Заказ	
,OrderDate                  nvarchar(32)  --Ячейка Дата Заказа	
,PriceNum                   nvarchar(32)  --Прайс	
,Commission                 money         --Комиссия
,IsActive                   bit
,CustomerSubID              varchar(32)   --правило формирование поля CustomerSubID
,Reference                  varchar(64)   --правило формирование поля Reference 
--
,inDatetime                 datetime default GetDate()      --
,updDatetime                datetime default GetDate()      --

)
go
create unique index ao1 on pOrderFileFormat(ID)
go
grant all on pOrderFileFormat to public
go
exec dbo.sys_setTableDescription @table = 'pOrderFileFormat', @desc = 'Формат файла с заказом'
go









