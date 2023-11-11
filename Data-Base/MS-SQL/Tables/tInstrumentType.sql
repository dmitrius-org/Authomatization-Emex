if OBJECT_ID('tInstrumentType') is null
--drop table tInstrumentType
/* **********************************************************
tInstrumentType - типы объект tInstrument
********************************************************** */
create table tInstrumentType
(
 InstrumentTypeID numeric(18, 0)  --
,Brief            nvarchar(64)       -- 
,Name             nvarchar(512)
,Filters          nvarchar(512) -- регулирует возможность создания типов элементов на текущем элементе
)
go
create unique index ao1 on tInstrumentType(InstrumentTypeID)
go
create unique index ao2 on tInstrumentType(Brief)
go
grant select on tInstrumentType to public
go
exec dbo.sys_setTableDescription 'tInstrumentType', 'Filters', 'Регулирует возможность создания типов элементов на текущем элементе'

/*
Insert tInstrumentType select 1, 'StateModels',   'Модель состояния', ''
Insert tInstrumentType select 2, 'Settings',      'Настройки',        ''
Insert tInstrumentType select 3, 'StateGroups',   'Группа',           '1'
Insert tInstrumentType select 4, 'SettingGroups', 'Группа',           '2'
Insert tInstrumentType select 5, 'StateModel',    'Модель состояния', '1,3'
Insert tInstrumentType select 6, 'State',         'Состояние',        '5,7'
Insert tInstrumentType select 7, 'Action',        'Действие',         '6'
--*/