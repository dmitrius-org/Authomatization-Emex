if OBJECT_ID('tProtocol') is null
--  drop table tProtocol
/* **********************************************************
tProtocol - Таблица протокола
********************************************************** */
create table tProtocol
(
 ProtocolID        numeric(18, 0) identity  --
,ObjectID          numeric(18, 0)   -- Объект
,StateID           numeric(18, 0)   -- Предыдущее состояние
,NewStateID        numeric(18, 0)   -- Текущее состояние 
,ActionID          numeric(18, 0)   -- ИД выполняемое дейстие из tAction
,OperDate          DateTime         -- Дата протокола
,Comment           nvarchar(1024)   -- Комментарий
,UserID            numeric(18, 0)   -- Пользователь
,InDateTime        DateTime default getdate()   -- 

)
go
create index ao1 on tProtocol(ProtocolID)
go
create index ao2 on tProtocol(ObjectID)
go
grant select on tProtocol to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tProtocol', @desc = 'Таблица протокола'
-- 

