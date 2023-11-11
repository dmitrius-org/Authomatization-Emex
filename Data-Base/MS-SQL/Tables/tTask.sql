if OBJECT_ID('tTask') is null
--drop table tTask
/* **********************************************************

********************************************************** */
create table tTask
(
 TaskID           numeric(18,0)  identity --  
,Brief            nvarchar(60)       --
,Name	          nvarchar(128)       -- 
,TaskType         int                -- тип задачи
,PeriodType       int
,DateBegin        datetime
,DateExec         datetime
,TimeBegin        Time
,TimeEnd          Time
,DayPeriod        int
,TimePeriod       Time
,IsActive         bit
,Message          nvarchar(1000)
,LinkID           numeric(18,0)
,Field            nvarchar(max)
,inDatetime       datetime default GetDate()      --
,updDatetime      datetime default GetDate()      --
)
go
create unique index ao1 on tTask(TaskID)
go
create index ao2 on tTask(Brief)
go
grant all on tTask to public
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'tTask', @desc = 'Задачи'