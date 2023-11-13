if OBJECT_ID('CloneOrders2') is not null
    drop proc CloneOrders2
/*
  CloneOrders2 - 
*/
go

create proc CloneOrders2
as
 declare @r int = 0
 declare @ID as table (OrderID  numeric(18, 0)
                      ,ParentID numeric(18, 0)
					  ,StateID  numeric(18, 0)
					  ,ID       numeric(18, 0)
					  )

INSERT INTO [tOrders]
      (
       ClientID
      ,OrderDate
      ,OrderNum
      ,StatusID
      ,isCancel
      ,isCancelToClient
      ,Manufacturer
      ,CustomerPriceLogo
      ,PriceLogo
      ,DetailNumber
      ,DetailName
      ,MakeLogo
      ,DetailID
      ,Quantity
      ,Price
      ,Amount
      ,PricePurchase
      ,PricePurchaseOrg
      ,AmountPurchase
      ,Discount
      ,PricePurchaseF
      ,AmountPurchaseF
      ,WeightKG
      ,VolumeKG
      ,Margin
      ,MarginF
      ,Profit
      ,Income
	  ,IncomePRC -- Доход %	
      ,PlanDate
      ,Rest
      ,DateDeliveredToSupplier
      ,ProfilesDeliveryID
      ,DaysReserveDeparture
      ,NextDateDeparture
      ,DateDeliveryToCustomer
      ,TermDeliveryToCustomer
      ,RestDeliveryToCustomer
      ,ReplacementMakeLogo
      ,ReplacementDetailNumber
      ,PriceID
      ,BasketId
      ,EmexOrderID
      ,CustomerSubId
      ,OrderDetailSubId
      ,Reference
      ,EmexQuantity
      ,OverPricing
      ,Warning
      ,Flag
      ,UserID
      ,inDatetime
      ,updDatetime
      ,ReplacementPrice
      ,ParentID
      ,Invoice
      ,FileDate      
      ,DestinationLogo
      ,Commission-- Комиссия от продажи	 
	  ,ID)	  
OUTPUT INSERTED.OrderID, INSERTED.ParentID, INSERTED.StatusID, inserted.ID
  INTO  @ID (OrderID, ParentID, StateID, ID)
select o.ClientID
      ,o.OrderDate
      ,o.OrderNum
      ,o.StatusID -- проставляем состояние разбиваемого заказа, состояние измениться в процедуре синхронизации
      ,o.isCancel
      ,o.isCancelToClient
      ,o.Manufacturer
      ,o.CustomerPriceLogo
      ,o.PriceLogo
      ,o.DetailNumber
      ,o.DetailName
      ,o.MakeLogo
      ,o.DetailID
      ,p.Quantity-- o.Quantity
      ,o.Price
      ,p.Quantity * o.Price --o.Amount
      ,o.PricePurchase
      ,o.PricePurchaseOrg
      ,p.Quantity * o.PricePurchase -- o.AmountPurchase
      ,o.Discount
      ,o.PricePurchaseF
      ,p.Quantity * o.PricePurchaseF --o.AmountPurchaseF
      ,o.WeightKG
      ,o.VolumeKG
      ,o.Margin
      ,o.MarginF
      ,o.Profit
      ,o.Income
	  ,o.IncomePRC
      ,o.PlanDate
      ,o.Rest
      ,o.DateDeliveredToSupplier
      ,o.ProfilesDeliveryID
      ,o.DaysReserveDeparture
      ,o.NextDateDeparture
      ,o.DateDeliveryToCustomer
      ,o.TermDeliveryToCustomer
      ,o.RestDeliveryToCustomer
      ,p.ReplacementMakeLogo-- ReplacementMakeLogo
      ,p.ReplacementDetailNumber-- ReplacementDetailNumber
      ,o.PriceID
      ,o.BasketId
      ,o.EmexOrderID
      ,o.CustomerSubId
      ,p.OrderDetailSubId-- OrderDetailSubId
      ,o.Reference
      ,o.EmexQuantity
      ,o.OverPricing
      ,o.Warning
      ,isnull(o.Flag, 0)|8 -- Запись добавлена в результате дробления заказа 
      ,dbo.GetUserID()
      ,isnull(o.inDatetime, GetDate())
      ,GetDate()
      ,p.PriceSale-- o.ReplacementPrice
      ,o.OrderID
      ,o.Invoice
      ,o.FileDate      
      ,o.DestinationLogo
      ,o.Commission-- Комиссия от продажи	
	  ,p.ID
  from pMovement p (nolock)
 inner join pMovement pp (nolock)
         on pp.Spid          = @@Spid
		and pp.OrderNumber   = p.OrderNumber
        and pp.CustomerSubId = p.CustomerSubId
        and pp.orderid  is not null
        and pp.N             = 1
 inner join tOrders o  (nolock)
         on o.OrderID = pp.OrderID
 inner join tNodes n (nolock)
         on n.EID = p.StatusId
where p.Spid    = @@SPID
  and p.orderid is null
order by p.DetailNum
        --and isnull(p.Flag, 0)&4=4

---- добавляем данные для протокола
--insert pAccrualAction 
--      (Spid, ObjectID,  StateID)
--select @@Spid, p.OrderID, p.StateID
--  from @ID p 

Update p
   set p.OrderID = i.OrderID
  from pMovement p (updlock)
 inner join @ID i
         on i.ID = p.ID
 --inner join tOrders o (nolock) 
 --        on o.OrderID = i.OrderID
 where p.Spid = @@SPID

--сохранение в архив
INSERT INTO [hOrders]
      ([ClientID]
      ,[OrderDate]
      ,[OrderNum]
      ,[StatusID]
      ,[isCancel]
      ,[isCancelToClient]
      ,[Manufacturer]
      ,[CustomerPriceLogo]
      ,[PriceLogo]
      ,[DetailNumber]
      ,[DetailName]
      ,[MakeLogo]
      ,[DetailID]
      ,[Quantity]
      ,[Price]
      ,[Amount]
      ,[PricePurchase]
      ,[PricePurchaseOrg]
      ,[AmountPurchase]
      ,[Discount]
      ,[PricePurchaseF]
      ,[AmountPurchaseF]
      ,[WeightKG]
      ,[VolumeKG]
      ,[Margin]
      ,[MarginF]
      ,[Profit]
      ,[Income]
      ,[IncomePRC]
      ,[PlanDate]
      ,[Rest]
      ,[DateDeliveredToSupplier]
      ,[ProfilesDeliveryID]
      ,[DaysReserveDeparture]
      ,[NextDateDeparture]
      ,[DateDeliveryToCustomer]
      ,[TermDeliveryToCustomer]
      ,[RestDeliveryToCustomer]
      ,[ReplacementMakeLogo]
      ,[ReplacementDetailNumber]
      ,[PriceID]
      ,[BasketId]
      ,[EmexOrderID]
      ,[CustomerSubId]
      ,[OrderDetailSubId]
      ,[Reference]
      ,[EmexQuantity]
      ,[OverPricing]
      ,[Warning]
      ,[Flag]
      ,[UserID]
      ,[inDatetime]
      ,[updDatetime]
      ,[ReplacementPrice]
      ,[ParentID]
      ,[OrderID]
      ,[Invoice]      
	  ,[FileDate]
	  ,[DestinationLogo]
      ,[Commission]          -- Комиссия от продажи	
      )
-- output inserted.OrderID, inserted.ParentID, inserted.StatusID into @ID (OrderID, ParentID, StateID)
select distinct
       o.[ClientID]
      ,o.[OrderDate]
      ,o.[OrderNum]
      ,o.[StatusID]
      ,o.[isCancel]
      ,o.[isCancelToClient]
      ,o.[Manufacturer]
      ,o.[CustomerPriceLogo]
      ,o.[PriceLogo]
      ,o.[DetailNumber]
      ,o.[DetailName]
      ,o.[MakeLogo]
      ,o.[DetailID]
      ,o.[Quantity]
      ,o.[Price]
      ,o.[Amount]
      ,o.[PricePurchase]
      ,o.[PricePurchaseOrg]
      ,o.[AmountPurchase]
      ,o.[Discount]
      ,o.[PricePurchaseF]
      ,o.[AmountPurchaseF]
      ,o.[WeightKG]
      ,o.[VolumeKG]
      ,o.[Margin]
      ,o.[MarginF]
      ,o.[Profit]
      ,o.[Income]
      ,o.[IncomePRC]
      ,o.[PlanDate]
      ,o.[Rest]
      ,o.[DateDeliveredToSupplier]
      ,o.[ProfilesDeliveryID]
      ,o.[DaysReserveDeparture]
      ,o.[NextDateDeparture]
      ,o.[DateDeliveryToCustomer]
      ,o.[TermDeliveryToCustomer]
      ,o.[RestDeliveryToCustomer]
      ,o.[ReplacementMakeLogo]
      ,o.[ReplacementDetailNumber]
      ,o.[PriceID]
      ,o.[BasketId]
      ,o.[EmexOrderID]
      ,o.[CustomerSubId]
      ,o.[OrderDetailSubId]
      ,o.[Reference]
      ,o.[EmexQuantity]
      ,o.[OverPricing]
      ,o.[Warning]
      ,o.[Flag]
      ,o.[UserID]
      ,o.[inDatetime]
      ,o.[updDatetime]
      ,o.[ReplacementPrice]
      ,o.[ParentID]
      ,o.[OrderID]
      ,o.[Invoice]
      ,o.[FileDate]
	  ,o.[DestinationLogo]
      ,o.[Commission]          -- Комиссия от продажи	
  from @ID i
 inner join tOrders o (rowlock) 
         on o.OrderID=i.ParentID

--копирование протоколов для новых записей
insert tProtocol 
      (ObjectID
      ,StateID
      ,NewStateID
      ,ActionID
      ,OperDate
      ,Comment
      ,UserID
	  ,InDateTime)
Select i.OrderID
      ,p.StateID
      ,p.NewStateID
      ,p.ActionID
      ,p.OperDate
      ,p.Comment
      ,p.UserID
	  ,p.InDateTime
  from @ID i
 inner join tProtocol p (nolock)
         on p.ObjectID=i.ParentID
 order by p.ProtocolID

-- меняем данные по заказу, который был разбит на части
Update o
   set o.Quantity       = p.Quantity
      ,o.Amount         = p.Quantity * o.Price  
	  ,o.AmountPurchase	= p.Quantity * o.PricePurchase
	  ,o.AmountPurchaseF= p.Quantity * o.PricePurchaseF
  from @ID i
 inner join tOrders o (rowlock) 
         on o.OrderID = i.ParentID
 inner join pMovement p (nolock)
         on p.Spid    = @@Spid
		and p.OrderID = o.OrderID
  exit_:

  return @r
GO
grant exec on CloneOrders2 to public
go