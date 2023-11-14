drop proc if exists OrderCreateFromBasket
/*
  OrderCreateFromBasket - создание заказа на основе корзины


  @ClientID  - ид клиента
  @PartID    - ид детали с формы поиска детали
*/
go

create proc OrderCreateFromBasket
         --    @ClientID numeric(18, 0)
          --  ,@PartID   numeric(18, 0)
           
as
declare @r int = 0
      -- ,@ObjectTypeID numeric(18,0)  -- ид объекта системы для которого используется модель
       ,@StatusID     numeric(18,0)  -- Ид начального состояния 
       ,@Brief	    nvarchar(128)  -- Сокращение состояния 
       ,@Name   	    nvarchar(256)  -- Наименование состояния

  --Select @ObjectTypeID = ObjectTypeID
  --  from tObjectType (nolock)
  -- where Brief = 'Заказы'

 -- if isnull(@ObjectTypeID, 0) = 0
 -- begin
 --   set @r =310 -- '[LoadOrders] Не определен идентификатор объекта системы для которго настроена модель состояния!'
	--goto exit_
 -- end

select @StatusID = NodeID
  from tNodes (nolock)
 where Brief = 'Preparation'


  --exec GetStartNode
  --       @ObjectTypeID = @ObjectTypeID
		--,@StatusID     = @StatusID out

delete pOrders from pOrders (rowlock) where spid = @@spid

insert pOrders
      (
       Spid
      ,ClientID
      ,Manufacturer
      ,DetailNumber
      ,Quantity
      --,DetailID
      ,DetailName
      ,Price
      ,Amount
      ,OrderNum
      ,OrderDate
      ,PriceNum
      --,FileDate
      )
select @@Spid
      ,b.ClientID
      ,b.MakeName
      ,b.DetailNum
      ,b.Quantity
      --,''--DetailID
      ,b.PartNameRus
      ,b.Price
      ,b.Amount
      ,''--OrderNum
      ,null--OrderDate
      ,b.PriceLogo

  from tMarks m (nolock)
 inner join tBasket b (nolock)
         on b.BasketID = m.ID
 where m.spid = @@spid   
   and m.Type = 6--Корзина
   


if not exists (select 1
                 from pOrders (nolock)
                where spid = @@spid)
begin
  set @r = 527 -- 'Не выбраны позиции для заказа!'
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
        ,cast(getdate() as date)
        ,o.PriceNum             -- CustomerPriceLogo
        ,o.PriceNum--pc.UploadPriceName     -- PriceLogo
        ,0--pc.ProfilesDeliveryID  --
       -- ,@StatusID              -- StatusID
        ,0                      -- isCancel
        ,0--pc.Margin              -- Наценка из прайса
		,0--pc.Discount            -- Скидка
		,0--p.PriceID              -- 
		,o.PriceNum				-- 
		,o.DetailName           -- наименование детали
        ,o.FileDate  
    from pOrders o (nolock)
   -- - - -
   --outer apply (select top 1 
   --                    pc.UploadPriceName,
   --                    pc.ProfilesDeliveryID,
   --                    pc.Margin,
			--		   pc.Discount
   --               from tProfilesCustomer pc (nolock)
   --              where pc.ClientPriceLogo = o.PriceNum
   --              order by pc.ProfilesCustomerID) pc
   -- - - -
   --outer apply (select top 1 *
   --               from tPrice p (nolock) 
   --              where p.DetailNum= o.DetailNumber
   --              order by case
			--	            when p.Brand = o.Manufacturer then 0
			--				else 1
			--	          end
   --                      ,case
			--	            when p.PriceLogo= pc.UploadPriceName then 0
			--				else 1
   --                       end
			--			 ,p.DetailPrice 
			--    ) p
   where o.Spid = @@Spid
     --and not exists (select 1
     --                  from tOrders t (nolock)
     --                 where t.ClientID          = o.ClientID
     --                   and t.CustomerPriceLogo = o.PriceNum
     --                   and t.OrderNum          = o.OrderNum
     --                   )


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
		 @StatusID, -- текущее состояние
		 @StatusID
    from @ID i

  exec ProtocolAdd


---- расчет финнасовых показателей
--delete pOrdersFinIn from pOrdersFinIn where spid = @@Spid
--insert pOrdersFinIn
--      (Spid
--      ,OrderID)
--Select @@spid
--      ,OrderID
--  from @ID

--exec OrdersFinCalc @IsSave = 1

  exit_:

  return @r
GO
grant exec on OrderCreateFromBasket to public
go


select * from tOrders where ClientID = 15


select * from tProfilesCustomer
select * from pOrders
select * from tBasket