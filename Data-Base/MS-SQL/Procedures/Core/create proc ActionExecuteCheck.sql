if OBJECT_ID('ActionExecuteCheck') is not null
    drop proc ActionExecuteCheck
/*
  ActionExecuteCheck - Проверка возможности выполнения действия
                     - заполнение главной таблицы для выполнения действия: pAccrualAction
*/
go
create proc ActionExecuteCheck
              @ActionID     numeric(18,0)  -- Ид начального состояния 
as
  declare @r          int = 0        
		 ,@NodeBrief  nvarchar(256)

  --
  -- проверки
  if not exists (select 1
                   from tMarks (nolock)
				  where Spid = @@spid
				    and Type = 3)
  begin
    set @r = 500 -- 'Отсутствуют объекты для выполнения операции!'
	goto exit_
  end

  select @NodeBrief = Brief
    from tNodes (nolock)
   where NodeID = @ActionID 

  if @NodeBrief = 'InBasket'
  begin
    if not exists (select 1
	                 from tSettings (nolock)
					where Brief = 'CoeffMaxAgree')
    begin
	  set @r = 502 -- 'Отсутствует настройка [CoeffMaxAgree] Максимальный коэффициент превышения цены продажи для клиента над ценой!'
	  goto exit_
	end

    if not exists (select 1
	                 from tSettings (nolock)
					where Brief = 'CoeffMaxAgree'
					  and val = '')
    begin
	  set @r = 503-- 'Необходимо проставить значение настройки [CoeffMaxAgree]. Максимальный коэффициент превышения цены продажи для клиента над ценой!'
	  goto exit_
	end
  end

 -- if exists (select 1
 --              from tMarks m (nolock)
 --             inner join tOrders o (nolock)
 --                     on o.OrderID = m.ID
	--          where m.Spid = @@spid
	--		    and m.Type = 3
	--		  group by o.ClientID 
	--		  Having count(distinct o.ClientID)  > 1
	--        )
 -- begin
 --   set @r = 516 -- 'Необходимо выделить заказы только одного клиента!'
	--goto exit_
 -- end

  --
  -- отбор объектов к выполнению действия
  Delete pAccrualAction from pAccrualAction (rowlock) where spid = @@spid

  insert into pAccrualAction
        (Spid,
		 ObjectID,
		 ActionID,
		 StateID,
		 NewStateID)
  Select @@Spid,
         o.OrderID ,
		 @ActionID,
		 o.StatusID, -- текущее состояние
		 mo.TargetStateID
    from tMarks m (nolock)
   inner join tOrders o (nolock)
           on o.OrderID = m.ID
   inner join tModel mo (nolock)
	       on mo.StateID = o.StatusID
		  and mo.ActionID= @ActionID
  where m.Spid = @@spid
	and m.Type = 3

  insert into pAccrualAction -- если размещаем заказ необходимо докинуть все детали в статусе "В корзине", т.к апи emex формирует заказ на основе всей корзины
        (Spid,
		 ObjectID,
		 ActionID,
		 StateID,
		 NewStateID)
  Select @@Spid,
         o.OrderID ,
		 p.ActionID,
		 o.StatusID, -- текущее состояние
		 p.NewStateID
    from tNodes n (nolock)
   inner join pAccrualAction p (nolock)
           on p.Spid = @@spid
		  and p.NewStateID = n.NodeID
   inner join tOrders op (nolock)
           on op.OrderID = p.ObjectID 
   inner join tClients cp (nolock)
           on cp.ClientID = op.ClientID

   inner join tNodes n2 (nolock)
           on n2.NodeID = p.StateID
		  and n2.Brief = 'InBasket'	-- В корзине
   inner join tOrders o (nolock)
           on o.StatusID = n2.NodeID 
   inner join tClients c (nolock)
           on c.ClientID = o.ClientID
          and c.SuppliersID = cp.SuppliersID

  where n.Brief = 'InWork'	-- В работе
    and not exists (select 1
	                  from pAccrualAction pp (nolock)
					 where pp.Spid     = @@spid
					   and pp.ObjectID = o.OrderID)

                         
  if exists (select count(distinct cp.SuppliersID)
               from pAccrualAction p (nolock)
              inner join tNodes n2 (nolock)
                      on n2.NodeID = p.NewStateID
	                 and n2.Brief = 'InWork'	-- В корзине
              inner join tOrders o (nolock)
                      on o.OrderID = p.ObjectID
              inner join tClients cp (nolock)
                      on cp.ClientID = o.ClientID
	          where p.Spid = @@spid
			 Having count(distinct cp.SuppliersID)  > 1
	        )
  begin
    set @r = 526 -- невозможно разместить заказы так как выбраны детали разных клиентов
	goto exit_
  end

  --
  Update pAccrualAction
     set RetVal = 501 -- 'Не удалось определить целевое состояние!'
    from pAccrualAction p (nolock)
   where p.Spid = @@SPID
     and isnull(p.NewStateID, 0) = 0

  Update pAccrualAction
     set RetVal = case 
	                when (isnull(o.PricePurchase, 0) = 0  or isnull(o.AmountPurchase, 0) = 0) then 504-- 'Необходимо заполнить обязательные поля "Цена закупки" и "Сумма закупки"!'
					when isnull(o.Reference, '') = ''     then 513 -- 'Необходимо заполнить обязательное поле "Reference"!'
					when isnull(o.CustomerSubId, '') = '' then 514 -- 'Необходимо заполнить обязательное поле "CustomerSubId"!'
					else 0
                  end
    from pAccrualAction p (nolock)
   inner join tNodes n2 (nolock)
           on n2.NodeID = p.ActionID
		  and n2.Brief <> 'ToCancel'	-- Отказать
   inner join tOrders o(nolock)
           on o.OrderID = p.ObjectID
   where p.Spid   = @@SPID
     and p.RetVal = 0

  Update pAccrualAction
     set RetVal = case 
	                when isnull(pd.DestinationLogo, '') = '' then 518 -- 'Необходимо заполнить обязательное поле "DestinationLogo"!'
					else RetVal
                  end
    from pAccrualAction p (nolock)
   inner join tNodes n2 (nolock)
           on n2.NodeID = p.ActionID
		  and n2.Brief  = 'ToBasket' -- Добавить к корзину
   inner join tOrders o(nolock)
           on o.OrderID = p.ObjectID
 inner join tProfilesCustomer pc (nolock)
         on pc.ClientPriceLogo = o.CustomerPriceLogo
 inner join tProfilesDelivery pd (nolock)
         on pd.ProfilesDeliveryID = pc.ProfilesDeliveryID
   where p.Spid   = @@SPID
     and p.RetVal = 0
	

   if exists (select 1
                from pAccrualAction (nolock)
               where Spid   = @@SPID
                 and RetVal <> 0)
     set @r = 506 -- 'Ошибка!'

 exit_:
 return @r
go
grant exec on ActionExecuteCheck to public
go
 