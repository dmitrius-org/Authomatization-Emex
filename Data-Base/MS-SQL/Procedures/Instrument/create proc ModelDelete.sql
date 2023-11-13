drop proc if exists ModelDelete
/*
  ModelDelete - 
*/
go
create proc ModelDelete
              @ModelID  numeric(18,0)  --  
as
  declare @r int = 0
         ,@StateID          numeric(18,0)
         ,@ITypeID          numeric(18,0)
         ,@IBrief           nvarchar(128)


  select @StateID = m.StateID,
         @ITypeID = m.InstrumentTypeID,
         @IBrief  = it.Brief
    from tModel m (nolock)
   inner join tInstrumentType it (nolock)
           on it.InstrumentTypeID=m.InstrumentTypeID
   inner join tNodes n (nolock)
           on n.NodeID = m.StateID
   where m.ModelID  = @ModelID 


  if @IBrief = 'Action'
  begin
    if exists (select 1 
                 from tModelMetod (nolock)
                where ModelID = @ModelID
               )
    begin
      set @r = 307-- 'Удаление запрещено, под действием настроены связанные объекты "Процедуры"!'
      goto exit_
    end
  end

  if @IBrief = 'State'
  begin
    if exists (select 1 
                 from tOrders (nolock)
                where StatusID = @StateID
               )
    begin
      set @r = 331 -- 'Статус с заданным сокращением используется в таблице заказов!'
      goto exit_
    end

    if exists (select 1 
                 from tModel (nolock)
                where TargetStateID = @StateID
               )
    begin
      set @r =  306-- 'Удаление запрещено, на состояние имеются переходы!'

      goto exit_
    end
  end
    
    --select * from tModel
  --select * from tInstrumentType

  delete tModel
   where ModelID = @ModelID

 exit_:
 return @r
go
grant exec on ModelDelete to public
go
