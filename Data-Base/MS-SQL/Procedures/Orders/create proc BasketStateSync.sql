if OBJECT_ID('BasketStateSync') is not null
    drop proc BasketStateSync
/*
  BasketStateSync - синхронизация данных после добавления детали в корзину


  -- 20.10.2023 - добавлен расчет финансовых показателей
*/
go
create proc BasketStateSync
as
 declare @r int = 0
 declare @CoeffMaxAgree money

 Update p
    set p.OrderID = o.OrderID
   from pBasketDetails p (updlock)
  inner join tOrders o (nolock) 
          on o.BasketId = p.BasketId   
 where p.Spid   = @@SPID

 Update p
    set p.OrderID = o.OrderID
   from pBasketDetails p (updlock) 
  cross apply (select top 1 *
                 from tOrders o (nolock) 
                where o.DetailNumber = p.DetailNum
                 order by case 
				            when o.CustomerSubId = p.CustomerSubId 
							  then 1
                              else 2
						  end
                         ,case 
				            when o.MakeLogo = p.MakeLogo 
							  then 1
                              else 2
						  end
						 ,case 
				            when o.PriceLogo = p.PriceLogo
							  then 1
                              else 2
						  end
						 ,case 
				            when o.Reference = p.Reference 
							  then 1
                              else 2
						  end

               ) o   
 where p.Spid               = @@SPID
   and isnull(p.OrderID, 0) = 0
 
 select @CoeffMaxAgree = convert(money, isnull(s.Val, 0))
   from tSettings s (nolock)
  where s.Brief = 'CoeffMaxAgree' 

 Update o
    set o.BasketId        = p.BasketId
   from pBasketDetails p (nolock)        
  inner join tOrders o (Updlock) 
          on o.OrderID = p.OrderID     
 where p.Spid   = @@SPID

 Update o
    set o.PricePurchaseF  = p.Price
	   ,o.AmountPurchaseF = round(p.Price * p.Quantity, 2)
	   ,o.EmexQuantity    = p.Quantity
	   ,o.OverPricing     = case 
	                          when p.Price  > 0 
							 -- then 100 - o.PricePurchaseOrg * 100 / p.Price
							  then 100 - p.UploadedPrice * 100 / p.Price
							  else 0
                            end 
   from pBasketDetails p (nolock)        
  inner join tOrders o (Updlock) 
          on o.OrderID = p.OrderID     
 where p.Spid   = @@SPID
   
 -- превышение цены
 Update o
    set o.Warning         = case
	                          when @CoeffMaxAgree < o.OverPricing then '+' + convert(varchar(128), o.OverPricing)
							  else ''
	                        end
	   ,o.flag            = case
	                          when @CoeffMaxAgree < o.OverPricing then isnull (o.flag, 0) | 1
							  else isnull(o.flag, 0) &~ 1
	                        end
   from pBasketDetails p (nolock)        
  inner join tOrders o (Updlock) 
          on o.OrderID = p.OrderID     
 where p.Spid   = @@SPID

 -- нет цены
 Update o
    set o.Warning         = case
	                          when p.Price = 0 then 'Нет цены'
							  else o.Warning
	                        end
							
	   ,o.flag            = case
	                          when p.Price = 0 then isnull (o.flag, 0) | 2
							  else isnull(o.flag, 0) &~ 2
	                        end 
       ,o.updDatetime = GetDate()
   from pBasketDetails p (nolock)        
  inner join tOrders o (Updlock) 
          on o.OrderID = p.OrderID     
 where p.Spid   = @@SPID
   --and p.Price  = 0


Update p 
   set p.Retval = 517-- 'Неизвестная ошибка, деталь не добалена в корзину!'
  from pAccrualAction p (Updlock)
 where p.Spid     = @@spid
   and not exists ( select 1 
                      from pBasketDetails bd (nolock)  
                     where bd.Spid = @@SPID 
					   and bd.OrderID = p.ObjectID)


-- расчет финнасовых показателей
delete pOrdersFinIn from pOrdersFinIn where spid = @@Spid
insert pOrdersFinIn
      (Spid
      ,OrderID
      )
Select @@spid
      ,OrderID
  from pBasketDetails p (nolock)         
 where p.Spid    = @@SPID
   and p.OrderID > 0
   and p.UploadedPrice <> p.Price

exec OrdersFinCalc @IsSave = 1
  

 exit_:
 return @r
go
grant exec on BasketStateSync to public
go