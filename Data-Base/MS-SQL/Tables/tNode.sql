if OBJECT_ID('tNodes') is null
/* **********************************************************
tNodes - 
********************************************************** */
create table tNodes
(
 NodeID            numeric(18,0)  identity --  
,Brief             nvarchar(32)   not null --
,Name              nvarchar(256)  not null --
,Comment           nvarchar(512)  null     --
,Flag              int            default 0--
,ColorID           nvarchar(32)   null     -- 
,Type              int -- 0 - состояние 
                       -- 1 - действие
,EID               int --  
,EBrief            nvarchar(32)  not null  --
,EName             nvarchar(256) not null  --
)
go
create unique index ao1 on tNodes(NodeID)
go
create unique index ao2 on tNodes(Brief)
go
grant select on tNodes to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tNodes', @desc = 'Справочник состояний и действий'
go
-- !!! проливать под пользователем admin
--delete from tNodes
/*
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'New',                       'Новый'                       ,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'InChecked',                 'Проверено'					,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'InBasket',                  'В корзине'					,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'InWork',                    'В работе'					,1   ,'InWork'            ,'В работе'
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'Purchased',                 'Закуплено'					,2   ,'Purchased'         ,'Закуплено'
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'ReceivedOnStock',           'Получено на склад'			,3   ,'ReceivedOnStock'   ,'Получено на склад'
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'ReadyToSend',               'Готово к выдаче'	            ,4   ,'ReadyToSend'       ,'Готово к выдаче'
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'Send',                      'Отправлено'					,5   ,'Sent'              ,'Отправлено'
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'NotAvailable',              'Нет в наличии'				,6   ,'NOT AVAILABLE'     ,'НЕТ В НАЛИЧИИ'
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'LessMinLot',                'Меньше минимальной партии'	,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'PriceChange',               'Изменение цены'				,7   ,'AGREE'             ,'Изменение цены'
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 0, 'InCancel',                  'Отказан'	  			        ,0   ,''                  ,''
	
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 1, 'ToChecked',                 'Проверка выполнена'			,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 1, 'ToBasket',                  'Добавить в корзину'			,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 1, 'ToInWork',                  'Создать заказ'	  			,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 1, 'ToCancel',                  'Отказать'	  	    		,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 1, 'ToNew',                     'Добавление нового заказа'	,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 1, 'ToReNew',                   'Вернуть в работу'	        ,0   ,''                  ,''
insert tNodes (Flag, Type, Brief, Name, EID, EBrief, EName) select 1, 1, 'AutomaticSynchronization',  'Синхронизация статусов'	    ,0   ,''                  ,''
--*/