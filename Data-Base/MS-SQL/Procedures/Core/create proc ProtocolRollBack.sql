if OBJECT_ID('ProtocolRollBack') is not null
    drop proc ProtocolRollBack
/*
  ProtocolRollBack - Удаление/откат протокола
*/
go
create proc ProtocolRollBack
as
  declare @r          int = 0
         ,@OldStateID numeric(18,0)  -- ид объекта системы для которого используется модель

   Update o 
      set o.StatusID = p.NewStateID
	     ,o.updDatetime      = GetDate()
	 from pAccrualAction p (nolock)
    inner join tOrders o (updlock)
	        on o.OrderID = p.ObjectID
    where p.Spid        = @@spid
	  and p.retval      = 0
	  and p.NewStateID <> 0

   -- если откатываем действие Добавить в корзину, то нужно затереть BasketId 
   Update o 
      set o.BasketId       = null
	     ,o.EmexQuantity   = null
		 ,o.PricePurchaseF = null
		 ,o.AmountPurchaseF= null
		 ,o.OverPricing    = null
		 ,o.Warning        = ''
		 ,o.Flag           = ((o.Flag&~1) &~2)
		 --,o.updDatetime      = GetDate()
	 from pAccrualAction p (nolock)
    inner join tOrders o (updlock)
	        on o.OrderID = p.ObjectID
    inner join tNodes n (nolock)
	        on n.NodeID = p.ActionID
		   and n.Brief  = 'ToBasket'
    where p.Spid        = @@spid
	  and p.retval      = 0
	
   -- если откатываем действие отказать
   Update o 
      set-- o.BasketId       = null
	    -- ,o.EmexQuantity   = null
		-- ,o.PricePurchaseF = null
		-- ,o.AmountPurchaseF= null
		-- ,o.OverPricing    = null
		 --,o.Warning        = ''
		  o.Flag           = ((o.Flag&~4))
		 ,o.isCancel         = 0
		 --,o.updDatetime      = GetDate()
	 from pAccrualAction p (nolock)
    inner join tOrders o (updlock)
	        on o.OrderID = p.ObjectID
    inner join tNodes n (nolock)
	        on n.NodeID = p.ActionID
		   and n.Brief  = 'ToCancel'
    where p.Spid        = @@spid
	  and p.retval      = 0
	--  select * from tNodes


   delete tProtocol
	 from pAccrualAction p
    inner join tProtocol o (rowlock)
	        on o.ProtocolID = p.ProtocolID
    where p.Spid        = @@spid
	  and p.retval      = 0

 exit_:
 return @r
go
grant exec on ProtocolRollBack to public
go
 