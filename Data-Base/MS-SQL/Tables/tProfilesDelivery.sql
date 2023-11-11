if OBJECT_ID('tProfilesDelivery') is null
--drop table tProfilesDelivery
/* **********************************************************
tProfilesDelivery - расширение профилей управлениявыгрузкой 
********************************************************** */
create table tProfilesDelivery
(
 ProfilesDeliveryID int  identity       -- Идентификатор 
,Name               varchar(60)         -- Наименование
,WeightKG           float               -- Вес физический кг 
,VolumeKG           float               -- Вес объемный кг  
,PDelivery1         int                 -- Срок поставки до поставщика
,PDelivery2         int                 -- Максимальный срок задержки поставщика
,PDelivery3         int                 -- срок доставки до Москвы (из новой таблицы tDelivery)
,DenVyleta          int                 -- день вылета, начиная с понедельника
,VolumeKG_Rate1     decimal(10, 2) null -- Коэффициент на детали у которых [VolumeKG] строго меньше 10 кг
,VolumeKG_Rate2     decimal(10, 2) null -- Коэффициент на детали у которых [VolumeKG] от 10 кг включительно, но строго меньше 20 кг
,VolumeKG_Rate3     decimal(10, 2) null -- Коэффициент на детали у которых [VolumeKG] от 20 кг включительно, но строго меньше 25 кг
,VolumeKG_Rate4     decimal(10, 2) null -- Коэффициент на детали у которых [VolumeKG] от 25 кг включительно
,DestinationLogo    nvarchar(10)        -- Направление
,Restrictions       bit                 -- Признак выгружать детали с ограничениями или нет
)
go
create unique index ao1 on tProfilesDelivery(ProfilesDeliveryID)
go
grant all on tProfilesDelivery to public
go

-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tProfilesDelivery', @desc = 'Расширение профилей управления выгрузкой'
-- Описание полей
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'ProfilesDeliveryID'    ,'Уникальный идентификатор '
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'Name'                  ,'Наименование' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'WeightKG'              ,'Вес физический кг ' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'VolumeKG'              ,'Вес объемный кг ' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'PDelivery1'            ,'Срок поставки до поставщика' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'PDelivery2    '        ,'Максимальный срок задержки поставщика' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'PDelivery3    '        ,'Срок доставки до Москвы (из новой таблицы tDelivery)' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'DenVyleta     '        ,'День вылета, начиная с понедельника' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'VolumeKG_Rate1'        ,'Коэффициент на детали у которых [VolumeKG] строго меньше 10 кг' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'VolumeKG_Rate2'        ,'Коэффициент на детали у которых [VolumeKG] от 10 кг включительно, но строго меньше 20 кг' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'VolumeKG_Rate3'        ,'Коэффициент на детали у которых [VolumeKG] от 20 кг включительно, но строго меньше 25 кг' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'VolumeKG_Rate4'        ,'Коэффициент на детали у которых [VolumeKG] от 25 кг включительно' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'DestinationLogo'       ,'Направление заказа. Передается в emex при добалении детали в корзину' 
exec dbo.sys_setTableDescription 'tProfilesDelivery', 'Restrictions'          ,'Признак выгружать детали с ограничениями или нет' 
go
/*
update tProfilesDelivery
   set DestinationLogo = '0001'
where  Name= 'ADQ-Express'

update tProfilesDelivery
   set DestinationLogo = '0002'
where  Name= 'ADQ-Charter'

update tProfilesDelivery
   set DestinationLogo = '0003'
where  Name= 'ADQ-Container'
--*/