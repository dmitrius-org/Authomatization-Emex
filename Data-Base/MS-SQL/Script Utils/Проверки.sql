-- сумма не сходится с количнством и ценой
Select o.OrderID, Quantity, o.PricePurchaseF * o.Quantity 'calc sum',PricePurchaseF,  o.AmountPurchaseF, PricePurchase, AmountPurchase
  from tOrders o (nolock)
 where o.PricePurchaseF * o.Quantity <> o.AmountPurchaseF

/* -- исправление
  update o 
     set o.AmountPurchaseF = o.Quantity * o.PricePurchaseF
    from tOrders o 
   where o.PricePurchaseF * o.Quantity <> o.AmountPurchaseF
  */


-- не проставлен признак отказан и статус нет в наличи
select *
  from tOrders
 where StatusID = 9	--NotAvailable
   and isCancel = 0

/* -- исправление
update tOrders
   set isCancel = 1
  from tOrders
 where StatusID = 9	--NotAvailable
   and isCancel = 0
  */

-- проставлен признак отказан ...
select *
  from tOrders
 where StatusID in (1	--New
                   ,2	--InChecked
                   ,3	--InBasket
                   ,4	--InWork
                   ,5	--Purchased
                   ,6	--ReceivedOnStock
                   ,7	--ReadyToSend
                   ,8	--Send
                    )
   and isCancel = 1

/* -- исправление
update tOrders
   set isCancel = 0
  from tOrders
 where StatusID in (1	--New
                   ,2	--InChecked
                   ,3	--InBasket
                   ,4	--InWork
                   ,5	--Purchased
                   ,6	--ReceivedOnStock
                   ,7	--ReadyToSend
                   ,8	--Send
                    )
   and isCancel = 1
  */

-- Протоколы без заказа
Select 'Протоколы без заказа', *
  from tProtocol p (nolock)
 where not exists (select 1
                    from tOrders o (nolock)
				   where o.OrderID = p.ObjectID
				   )
--
/* -- исправление
delete p
  from tProtocol p
 where not exists (select 1
                    from tOrders o (nolock)
				   where o.OrderID = p.ObjectID
				   )
*/


--
select 'Заказы, которые не удалось разбить на части', *
  from tMovement (nolock)
 where OrderID is null

-- заказы, которых нет в emex
Select 'Заказы, которых нет в emex', *
  from tOrders p
 where not exists (select 1
                    from tMovement m (nolock)
				   where m.OrderID = p.OrderID
				   )
   --and p.isCancel = 0
   and StatusID in (--1	--New
                   --,2	--InChecked
                    3	--InBasket
                   ,4	--InWork
                   ,5	--Purchased
                   ,6	--ReceivedOnStock
                   ,7	--ReadyToSend
                   ,8	--Send
				   ,9	--NotAvailable
                    )
/* -- исправление
delete p
  from tOrders p
 where not exists (select 1
                    from tMovement m (nolock)
				   where m.OrderID = p.OrderID
				   )
   --and p.isCancel = 0
   and StatusID in (--1	--New
                   --,2	--InChecked
                    3	--InBasket
                   ,4	--InWork
                   ,5	--Purchased
                   ,6	--ReceivedOnStock
                   ,7	--ReadyToSend
                   ,8	--Send
				   ,9	--NotAvailable
                    )
*/


--
select *
  from tMovement m (nolock)
  inner join tOrders o (nolock)
          on o.OrderID = m.OrderID
where m.Quantity <> o.Quantity

/* -- исправление
*/
