if OBJECT_ID('ProtocolAdd') is not null
    drop proc ProtocolAdd
/*
  ProtocolAdd - добавление протокола

  pAccrualAction - входящий набор данных
*/
go
create proc ProtocolAdd
as
  set nocount on;

  declare @r          int = 0

  declare @ID as table (ID       numeric(18, 0), 
                        ObjectID numeric(18, 0))

  insert into tProtocol with (rowlock)
        (ObjectID    
        ,StateID 
		,NewStateID 
        ,ActionID    
        ,OperDate  
        ,Comment     
        ,UserID      )
  OUTPUT INSERTED.ProtocolID, INSERTED.ObjectID INTO @ID
  Select p.ObjectID
        ,p.StateID
		,p.NewStateID
		,p.ActionID		
		,p.OperDate
		,isnull(p.Message, '')
		,dbo.GetUserID()
    from pAccrualAction p (nolock)
   where p.Spid              = @@spid
     and isnull(p.retval, 0) = 0

  Update p 
     set p.ProtocolID = id.ID
    from @ID id
   inner join pAccrualAction p (Updlock)
	       on p.Spid     = @@spid
	      and p.ObjectID = id.ObjectID

  -- изменение состояния заказа
  Update o 
     set o.StatusID = p.NewStateID
        ,o.isCancel = case
	                    when ns.Brief = 'InCancel' then 1
						when act.Brief = 'ToReNew' then 0 -- вернуть в работу
		                else o.isCancel 
		              end

	    ,o.flag     = case
	                    when ns.Brief = 'InCancel' then isnull (o.flag, 0) | 4 -- признак "Отказан"
						when act.Brief = 'ToReNew' then isnull (o.flag, 0) &~ 4 -- признак "Отказан"
					    else o.flag
	                  end
        ,o.updDatetime = GetDate()
	from @ID id
   inner join pAccrualAction p (nolock)
	       on p.Spid     = @@spid
	      and p.ObjectID = id.ObjectID
		  and p.retval = 0
   inner join tOrders o (updlock)
	       on o.OrderID = id.ObjectID
   inner join tNodes ns (nolock)
           on ns.NodeID = p.NewStateID
   inner join tNodes act (nolock)
           on act.NodeID = p.ActionID

 exit_:
 return @r
go
grant exec on ProtocolAdd to public
go
 