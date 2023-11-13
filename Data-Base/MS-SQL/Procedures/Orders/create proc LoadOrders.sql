if OBJECT_ID('LoadOrders') is not null
    drop proc LoadOrders
/*
  LoadOrders - загрузка заказов в БД


  pOrders - входящий набор данных

  -- 20.10.2023 - добавлен расчет финансовых показателей
*/
go

Create proc [LoadOrders]
           
as
  declare @r int = 0
         ,@ObjectTypeID numeric(18,0)  -- ид объекта системы для которого используется модель
         ,@StatusID     numeric(18,0)  -- Ид начального состояния 
         ,@Brief	    nvarchar(128)  -- Сокращение состояния 
         ,@Name   	    nvarchar(256)  -- Наименование состояния

  Select @ObjectTypeID = ObjectTypeID
    from tObjectType (nolock)
   where Brief = 'Заказы'

  if isnull(@ObjectTypeID, 0) = 0
  begin
    set @r =310 -- '[LoadOrders] Не определен идентификатор объекта системы для которго настроена модель состояния!'
	goto exit_
  end

  exec GetStartNode
         @ObjectTypeID = @ObjectTypeID
		,@StatusID     = @StatusID out
		 
  if isnull(@StatusID, 0) = 0
  begin
    set @r = 320-- '[LoadOrders] Не определен идентификатор начального состояния!'
	goto exit_
  end	

  declare @ID as table (OrderID numeric(18, 0))
  insert tOrders
        (ClientID
        ,Manufacturer
        ,DetailNumber
        ,Quantity
        ,DetailID
        ,Price
        ,Amount
        ,OrderNum
        ,OrderDate
        ,CustomerPriceLogo 
        ,PriceLogo
        ,ProfilesDeliveryID
        --,StatusID
        ,isCancel
        ,Margin
		,Discount
		,PriceID
		,MakeLogo
		,DetailName
        ,FileDate                
        )
  output inserted.OrderID into @ID (OrderID)
  select o.ClientID
        ,o.Manufacturer
        ,o.DetailNumber
        ,o.Quantity
        ,o.DetailID
        ,o.Price
        ,o.Amount
        ,o.OrderNum
        ,cast(o.OrderDate as date)
        ,o.PriceNum             -- CustomerPriceLogo
        ,pc.UploadPriceName     -- PriceLogo
        ,pc.ProfilesDeliveryID  --
       -- ,@StatusID              -- StatusID
        ,0                      -- isCancel
        ,pc.Margin              -- Наценка из прайса
		,pc.Discount            -- Скидка
		,p.PriceID              -- 
		,p.MakeLogo				-- 
		,o.DetailName           -- наименование детали
        ,o.FileDate  
    from pOrders o (nolock)
   -- - - -
   outer apply (select top 1 
                       pc.UploadPriceName,
                       pc.ProfilesDeliveryID,
                       pc.Margin,
					   pc.Discount
                  from tProfilesCustomer pc (nolock)
                 where pc.ClientPriceLogo = o.PriceNum
                 order by pc.ProfilesCustomerID) pc
   -- - - -
   outer apply (select top 1 *
                  from tPrice p (nolock) 
                 where p.DetailNum= o.DetailNumber
                 order by case
				            when p.Brand = o.Manufacturer then 0
							else 1
				          end
                         ,case
				            when p.PriceLogo= pc.UploadPriceName then 0
							else 1
                          end
						 ,p.DetailPrice 
			    ) p
   where o.Spid = @@Spid
     and not exists (select 1
                       from tOrders t (nolock)
                      where t.ClientID          = o.ClientID
                        and t.CustomerPriceLogo = o.PriceNum
                        and t.OrderNum          = o.OrderNum
                        )

  Update o
     set o.PricePurchase    = round(p.DetailPrice - (p.DetailPrice * (o.Discount / 100)), 2)-- Цена закупки с учетом скидки	
	    ,o.PricePurchaseOrg = round(p.DetailPrice, 2) 
        ,o.WeightKG         = p.WeightKG -- Вес Физический из прайса	
        ,o.VolumeKG         = p.VolumeKG -- Вес Объемный из прайса	
    from @ID i
   inner join tOrders o with (updlock)
           on o.OrderID = i.OrderID
   inner join tPrice p (nolock) 
           on p.PriceID = o.PriceID
                        
  Update o
     set o.AmountPurchase  = o.PricePurchase * o.Quantity  -- Сумма закупки	   
    from @ID i
   inner join tOrders o with (updlock)
           on o.OrderID = i.OrderID

  -- проставляем поля Reference и CustomerSubID
  exec OrdersReferenceCalc

  -- Протокол
  declare @ToNew numeric(18, 0)
  select @ToNew = NodeID
    from tNodes (nolock)
   Where Brief = 'ToNew'

  delete pAccrualAction from pAccrualAction (rowlock) where spid = @@spid
  insert into pAccrualAction
        (Spid,
		 ObjectID,
		 ActionID,
		 StateID,
		 NewStateID)
  Select @@Spid,
         i.OrderID ,
		 isnull(@ToNew, 0),
		 0, -- текущее состояние
		 @StatusID
    from @ID i

  exec ProtocolAdd


-- расчет финнасовых показателей
delete pOrdersFinIn from pOrdersFinIn where spid = @@Spid
insert pOrdersFinIn
      (Spid
      ,OrderID)
Select @@spid
      ,OrderID
  from @ID

exec OrdersFinCalc @IsSave = 1

exit_:

return @r
GO
grant exec on LoadOrders to public
go