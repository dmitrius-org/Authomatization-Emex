Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  0, 'State',    'Модель состояния',  1
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  0, 'Settings', 'Настройки системы', 2
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  2, 'emexdwc', 'Настройки интеграции с emexdwc', 4--, 'TSettingsT'

insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select 3, 'CoeffMaxAgree', 'Максимальный коэффициент превышения цены продажи для клиента над ценой', 'Максимальный коэффициент превышения цены продажи для клиента над ценой, показанной на сайте (по умолчанию 1.1)', '1.1', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select 3, 'AutomaticRejectionPartsByCreatOrder', 'Автоматический отказ деталей с ошибками при создании заказа', '', '1', 0

Insert tInstrument ( PID, Brief, Name, InstrumentTypeID, ObjectTypeID) Select  1, 'Заказы',    'Заказы',  5, 3

Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  2, 'Orders', 'Заказы', 4--, 'TSettingsT'

go
declare @ID numeric(18, 0)
select @ID = InstrumentID from tInstrument where brief = 'Orders'
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'OrdersGridRowCount', 'Количество строк на странице таблицы заказов', '', '500', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'TemplateOrderRefusals', 'Шаблон Excel для экспорта отказов', '', '', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'UploadingRefusalsCatalog', 'Папка для сохранения файлов отказов', '', '', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'UploadingRefusalsScript', 'Скрипт для выгрузки отказов', '', '', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'EmexdwcClient', 'Клиент для интеграции', '', '3', 0

go
declare @PID numeric(18, 0)
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  0, 'SettingsClientApp', 'Настройки для клиентского приложения', 2

select @PID = InstrumentID from tInstrument where brief = 'SettingsClientApp'
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  @PID, 'ClientAppCommon', 'Общие настройки', 4--, 'TSettingsT'

declare @ID numeric(18, 0)
select @ID = InstrumentID from tInstrument where brief = 'ClientAppCommon'
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'DefaultSuppliers', 'Поставщик по умолчанию', 'Значение данного параметра проставляется в карточку клиента при регистрации на сайте', '', 0

/*
delete
  from tSettings 
 where brief in ('')
*/


select *
  from tInstrument (nolock)
select *
  from tSettings (nolock)
  where brief = 'OrdersGridRowCount'
