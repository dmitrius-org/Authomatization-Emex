drop proc if exists InstrumentDelete
/*
  InstrumentDelete - 
*/
go
create proc InstrumentDelete
              @InstrumentID  numeric(18,0)  --  
as
  declare @r int = 0
         ,@Brief            nvarchar(512)  --
         ,@InstrumentTypeID numeric(18,0)
         ,@PID              numeric(18,0)


  select --@Brief            = Brief 
         @InstrumentTypeID = InstrumentTypeID
        --,@PID              = PID
    from tInstrument (nolock)
   where InstrumentID  = @InstrumentID 

  if exists (select 1 
               from tSettings (nolock)
              where GroupID = @InstrumentID
                and @InstrumentTypeID = 4)
  begin
    set @r = 303-- 'Удаление запрещено, под группой имеются связанные настройки!'
    goto exit_
  end

  if exists (select 1 
               from tInstrument (nolock)
              where PID = @InstrumentID
             )
  begin
    set @r = 304 -- 'Удаление запрещено, под объектом имеются связанные элементы!'
    goto exit_
  end

  if exists (select 1 
               from tOrders (nolock)
              where StatusID = @InstrumentID
             )
  begin
    set @r = 331 -- 'Статус с заданным сокращением используется в таблице заказов!'
    goto exit_
  end
    

  delete tInstrument
   where InstrumentID = @InstrumentID

 exit_:
 return @r
go
grant exec on InstrumentDelete to public
go
