if OBJECT_ID('CloneOrders') is not null
    drop proc CloneOrders
/*
  CloneOrders - 
*/
go

Create proc CloneOrders
as
 declare @r int = 0
 declare @ID as table (OrderID  numeric(18, 0)
                      ,ParentID numeric(18, 0)
					  ,StateID  numeric(18, 0)
					  ,ID       numeric(18, 0)
					  )

INSERT INTO [tOrders]
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
           ,[Invoice]
           ,[FileDate]
		   ,[ParentID]
		   ,[DestinationLogo]
           ,[Commission]          -- Комиссия от продажи	 
		   ,[ID])
      OUTPUT  INSERTED.OrderID, INSERTED.ParentID, INSERTED.StatusID, inserted.ID
	    INTO  @ID (OrderID, ParentID, StateID, ID)
     select
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
           ,p.[Quantity]
           ,o.[Price]
           ,o.[Price]*p.[Quantity]
           ,o.[PricePurchase]
           ,o.[PricePurchaseOrg]
           ,o.[PricePurchase]*p.[Quantity] -- [AmountPurchase]
           ,o.[Discount]
           ,o.[PricePurchaseF]
           ,o.[PricePurchaseF]*p.[Quantity] -- [AmountPurchaseF]
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
           ,dbo.GetUserID()
           ,GetDate()
           ,GetDate()
           ,o.[ReplacementPrice]
           ,o.[Invoice]
           ,o.[FileDate]
		   ,o.[OrderID]
		   ,o.[DestinationLogo]
           ,o.[Commission]          -- Комиссия от продажи	
		   ,p.[ID]
       from pMovement as p (nolock)
      inner join tOrders o (nolock) 
              on o.OrderID = p.OrderID
      where p.Spid = @@SPID
        and isnull(p.Flag, 0)&4=4

-- добавляем данные для протокола
insert pAccrualAction 
      (Spid, ObjectID,  StateID)
select @@Spid, p.OrderID, p.StateID
  from @ID p 

Update p
   set p.OrderID = o.OrderID
  from pMovement p (updlock)
 inner join @ID i
         on i.ID = p.ID
 inner join tOrders o (nolock) 
         on o.OrderID = i.OrderID
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

--копирование протоколов
insert tProtocol 
      (
       ObjectID
      ,StateID
      ,NewStateID
      ,ActionID
      ,OperDate
      ,Comment
      ,UserID
	  ,InDateTime
	  )
Select
       i.OrderID
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

delete o
  from @ID i
 inner join tOrders o (rowlock) 
         on o.OrderID=i.ParentID

  exit_:

  return @r


GO
grant exec on CloneOrders to public
go