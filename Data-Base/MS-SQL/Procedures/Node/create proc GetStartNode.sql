drop proc if exists GetStartNode
/*
  GetStartNode - получение идентификатора начального состояния
*/
go
create proc GetStartNode
              @ModelID          numeric(18,0) = null -- ид модели состояния
			 ,@ObjectTypeID     numeric(18,0) = null -- ид объекта системы для которого используется модель
			 --,@NodeID           numeric(18,0) = null output -- Ид статуса tNode.NodeID 
			 ,@StatusID         numeric(18,0) = null output -- Ид начального состояния, данный ид пишется в tOrders.StatusID
			 --,@Brief	        nvarchar(128) = null output -- Сокращение состояния 
            -- ,@Name   	        nvarchar(256) = null output -- Наименование состояния
	 
as
  declare @r int = 0



Select top 1 @StatusID =  m.StateID --, t.Flag
  from [tInstrument] t (nolock)
 inner join tModel m (nolock)
         on m.InstrumentID = t.InstrumentID
		and m.Flag&1=1
 where t.ObjectTypeID = @ObjectTypeID
    or m.ModelID = @ModelID
 order by m.ModelID


 exit_:
 return @r
go
grant exec on GetStartNode to public
go
