if OBJECT_ID('tProfilesCustomer') is null
--drop table tProfilesCustomer
/* **********************************************************
tProfilesCustomer - профили управления выгрузкой
********************************************************** */
create table tProfilesCustomer
(
 ProfilesCustomerID  int  identity --  
,Brief               varchar(60)   --
,ProfilesDeliveryID  int
--,Dest           varchar(60)      -- Выбор типа цены (dest, текстовое поле, по умолчанию установить значение "MOSA")
,Margin              money         -- Наценка в процентах (margin, текстовое поле, по умолчанию установить значение "25", 😵
,Reliability         money         -- Вероятность поставки (reliability, текстовое поле, по умолчанию установить значение "70", 😵
,Discount            money         -- Скидка (discount, текстовое поле, по умолчанию установить значение "5", 😵
                                   -- Discount -- Скидка поставщика на закупку товара
,Commission          money         -- Комиссия эквайера (commission, текстовое поле, по умолчанию установить значение "3,5", 😵
,isMyDelivery        bit           -- Поле для галочки "Считать с учетом доставки"
,isIgnore            bit           -- Поле для галочки "Игнорировать детали без веса"
,UploadFolder        varchar(255)  -- Каталог для сохранения прайс-файлов
,UploadPriceName     varchar(255)  -- 
,UploadFileName      varchar(255)  -- 
,isActive            bit
,ExtraKurs           money
,ClientPriceLogo     nvarchar(32)   -- Наименование прайса клиента по которым заказываются детали
                                    -- по данному полю вымолняем сопоставление с tOrders.CustomerPriceLogo
,UploadDelimiterID   int            -- разделитель 
)
go
create unique index ao1 on tProfilesCustomer(ProfilesCustomerID)
go
create unique index ao2 on tProfilesCustomer(Brief)
go
create index ao3 on tProfilesCustomer(UploadPriceName)
go
grant all on tProfilesCustomer to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tProfilesCustomer', @desc = 'Профили управления выгрузкой прайсов'


/*
update tProfilesCustomer
   set UploadFolder = 'C:\Price\' 
      ,UploadDelimiterID = 2
 where ProfilesCustomerID=1
--*/