drop proc if exists ModelUpdate
/*
  ModelUpdate - 
*/
go
create proc ModelUpdate
              @ModelID          numeric(18, 0) 
             ,@InstrumentID     numeric(18,0) = null -- Ид родительской модели
             ,@StateID          numeric(18,0)  -- 
             ,@ActionID         numeric(18,0) = null
             ,@TargetStateID    numeric(18,0) = null
             ,@InstrumentTypeID numeric(18,0) --тип объекта/инструмента
             ,@Flag             int 
/*
@InstrumentTypeID
 1 - 'StateModels',   'Модель состояния', ''
 2 - 'Settings',      'Настройки',        ''
 3 - 'StateGroups',   'Группа',           '1'
 4 - 'SettingGroups', 'Группа',           '2'
 5 - 'StateModel',    'Модель состояния', '1,3'
 6 - 'State',         'Состояние',        '5,7'
 7 - 'Action',        'Действие',         '6'
*/
             
as
  declare @r int = 0
      --   ,@TargetStateID    numeric(18,0) = null
  --if @InstrumentTypeID in (3,4,5) and
  --   exists (select 1 
  --             from tInstrument (nolock)
  --            where Brief             = @Brief
        --        and InstrumentTypeID  = @InstrumentTypeID
        --        and PID               = @PID)
  --begin
  --  set @r = case @InstrumentTypeID
     --         when 3 /*группа StateGroups*/ then 301 -- 'Группа с заданным сокращением существует!'
        --      when 4 /*группа SettingGroups*/ then 301 -- 'Группа с заданным сокращением существует!'
        --      when 5 then 305-- 'Модель состояния с заданным сокращением существует!'
        --      --when 6 /*Состояние*/ then 300 --Статус с заданным системным наименованием существует!
        --      --when 7 /*Действие*/ then 302  -- 'Действие с заданным сокращением существует!'
     --        end
  --  goto exit_
  --end
 
UPDATE [dbo].[tModel]
   SET [InstrumentID]     = isnull(@InstrumentID, [InstrumentID]) 
      ,[StateID]          = @StateID    
      ,[ActionID]         = @ActionID
      ,[TargetStateID]    = @TargetStateID
      ,[InstrumentTypeID] = @InstrumentTypeID
      ,[Flag]             = @Flag
      ,[updDatetime]      = getdate()
 WHERE ModelID = @ModelID

 exit_:
 return @r
go
grant execute on ModelUpdate to public
go
