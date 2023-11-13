drop proc if exists InstrumentCreate
/*
  InstrumentCreate - 
*/
go
create proc InstrumentCreate
              @InstrumentID     numeric(18,0) output -- 
             ,@InstrumentTypeID numeric(18,0)  -- тип объекта/инструмента
             ,@ObjectTypeID     numeric(18,0) = null
             ,@PID              numeric(18,0)  -- родитель
             ,@Brief            nvarchar(512) = null
             ,@Name             nvarchar(512) = null 
            -- ,@StateID          numeric(18, 0)= null 
            -- ,@ActionID         numeric(18, 0)= null  
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

  if @InstrumentTypeID in (3,4,5) and
     exists (select 1 
               from tInstrument (nolock)
              where Brief             = @Brief
                and InstrumentTypeID  = @InstrumentTypeID
                and PID               = @PID)
  begin
    set @r = case @InstrumentTypeID
              when 3 /*группа StateGroups*/ then 301 -- 'Группа с заданным сокращением существует!'
              when 4 /*группа SettingGroups*/ then 301 -- 'Группа с заданным сокращением существует!'
              when 5 then 305-- 'Модель состояния с заданным сокращением существует!'
              --when 6 /*Состояние*/ then 300 --Статус с заданным системным наименованием существует!
              --when 7 /*Действие*/ then 302  -- 'Действие с заданным сокращением существует!'
             end
    goto exit_
  end

  --  if @InstrumentTypeID in (6 /*Состояние*/) and
  --   exists (select 1 
  --             from tInstrument (nolock)
  --            where Brief             = @Brief
        --        and InstrumentTypeID  = @InstrumentTypeID
        --        and PID               = @Flag)
  --begin
  --  set @r =  0 -- 'Группа с заданным сокращением существует!'
  --  goto exit_
  --end

  --  if @InstrumentTypeID in (6 /*Состояние*/) and
  --   exists (select 1 
  --             from tInstrument (nolock)
  --            where Brief             = @Brief
        --        and InstrumentTypeID  = @InstrumentTypeID
        --        and PID               = @Flag)
  --begin
  --  set @r =  0 -- 'Группа с заданным сокращением существует!'
  --  goto exit_
  --end


  

  declare @ID as table (ID numeric(18, 0))
  insert into tInstrument
         (
          Brief
         ,Name
         ,InstrumentTypeID
         ,PID
         ,ObjectTypeID
        -- ,Form
        -- ,StateID
        -- ,ActionID
        -- ,TargetStateID
         ,Flag
         )
  OUTPUT INSERTED.InstrumentID INTO @ID
  select @Brief     
        ,@Name         
        ,@InstrumentTypeID     
        ,@PID
        ,@ObjectTypeID
        --,case 
        --   when @InstrumentTypeID = 4 /*SettingGroups */ then 'TSettingsT'
        --  -- when @InstrumentTypeID = 5 /*StateModel */ then 'TInstrumentStateT'
        --   --when @InstrumentTypeID = 6 /*State */ then 'TInstrumentActionT'
        --   when @InstrumentTypeID = 7 /*action */ then 'TInstrumentActionT'
        --   else null
        -- end
    --    ,@StateID
---        ,@ActionID
        --,@TargetStateID
        ,@Flag


   Select @InstrumentID = ID from @ID

 exit_:
 return @r
go
grant execute on InstrumentCreate to public
go
