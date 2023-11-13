drop proc if exists InstrumentUpdate
/*
  InstrumentUpdate - 
*/
go
create proc InstrumentUpdate
              @InstrumentID     numeric(18,0)  --  
            -- ,@PID              numeric(18,0) = null  -- родитель
             ,@Brief            nvarchar(512) = null
             ,@Name                nvarchar(512) = null 
             ,@ObjectTypeID     numeric(18, 0)= null 
             --,@StateID          numeric(18, 0)= null 
             --,@ActionID         numeric(18, 0)= null  
             --,@TargetStateID    numeric(18, 0)= null
             ,@Flag             int 
as
  declare @r int = 0
         ,@InstrumentTypeID numeric(18,0)
         ,@PID              numeric(18,0)


  select @InstrumentTypeID = InstrumentTypeID
        ,@PID              = PID
    from tInstrument (nolock)
   where InstrumentID  = @InstrumentID 

  if @InstrumentTypeID in (3,4,5) and
     exists (select 1 
               from tInstrument (nolock)
              where Brief             = @Brief
                and InstrumentTypeID  = @InstrumentTypeID
                and PID               = @PID
                and InstrumentID     <> @InstrumentID)
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

  Update tInstrument
     set Brief         = @Brief,
         Name          = @Name,
         ObjectTypeID  = @ObjectTypeID,
        -- StateID       = @StateID,
        -- ActionID      = @ActionID,
         --TargetStateID = @TargetStateID,
         Flag          = @Flag,
         updDatetime   = GetDate()
   where InstrumentID  = @InstrumentID

 exit_:
 return @r
go
grant exec on InstrumentUpdate to public
go
