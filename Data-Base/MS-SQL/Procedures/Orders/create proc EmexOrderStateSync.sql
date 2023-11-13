if OBJECT_ID('EmexOrderStateSync') is not null
    drop proc EmexOrderStateSync
/*
  EmexOrderStateSync - 
*/
go
create proc EmexOrderStateSync
as

set nocount on;

declare @SNode numeric(18, 0) -- начальное состояние
       ,@r     int 

exec GetStartNode
       @ObjectTypeID = 3-- ид объекта системы для которого используется модель
      ,@StatusID    = @SNode output -- Ид начального состояния, данный ид пишется в tOrders.StatusID

delete pAccrualAction from pAccrualAction (rowlock) where spid = @@spid

Update pMovement
   set pMovement.N = p.N
  from (Select ID,
               ROW_NUMBER() over(partition by OrderNumber, DetailNum, CustomerSubId order by StatusID) N
          from pMovement p (nolock)
         where p.Spid = @@Spid
        ) p
  where p.ID = pMovement.ID

-- 1. По идентификатору OrderDetailSubId
Update p
   set p.OrderID = o.OrderID
      ,p.Tag     = 1 
    --  ,p.Flag    = isnull(p.Flag, 0)|1 --однозначно определили заказ
  from pMovement p (updlock) 
 cross apply (select top 1 *
                from tOrders o (nolock) 
               where o.EmexOrderID      = p.OrderNumber
                 and o.OrderDetailSubId = p.OrderDetailSubId
                 and p.OrderDetailSubId<> '' ) o 
where p.Spid = @@SPID

declare @N int 
--объявляем курсор
DECLARE my_cur CURSOR FOR 
 SELECT distinct N
   FROM pMovement (nolock)
  where spid = @@spid
  order by N

--открываем курсор
OPEN my_cur
--считываем данные первой строки в наши переменные
FETCH NEXT FROM my_cur INTO @N
--если данные в курсоре есть, то заходим в цикл
--и крутимся там до тех пор, пока не закончатся строки в курсоре
WHILE @@FETCH_STATUS = 0
BEGIN
    --2. Количество
    Update p
       set p.OrderID = o.OrderID
          ,p.Tag     = 2 
      from pMovement p (updlock) 
      left join tNodes n (nolock)
             on n.EID = p.StatusId
     cross apply (select top 1 *
                    from tOrders o (nolock) 
                   where o.EmexOrderID   = p.OrderNumber
                     and o.DetailNumber  = p.DetailNum            
                     and o.CustomerSubId = p.CustomerSubId
                     and o.Reference     = p.Reference 
                     and o.Quantity      = p.Quantity
                     and o.StatusID      = n.NodeID 
                     and not exists (select 1
                                       from pMovement m (nolock)
                                      where m.Spid        = @@spid
                                        and m.OrderID     = o.OrderID
                                        and m.OrderNumber = o.EmexOrderID 
                                     )
                  ) o   
    where p.Spid = @@SPID
      and isnull(p.OrderID, 0) = 0
      and p.N = @N

    --3. Все остальное
    Update p
       set p.OrderID = o.OrderID
          ,p.Tag     = 3
      from pMovement p (updlock) 
      left join tNodes n (nolock)
             on n.EID = p.StatusId
     cross apply (select top 1 o.*
                    from tOrders o (nolock) 
                   inner join tNodes nn (nolock)
                           on nn.NodeID = o.StatusID
                         -- and nn.EID   <= p.StatusId
                   where o.EmexOrderID   = p.OrderNumber 
                     and o.DetailNumber  = p.DetailNum               
                     and o.CustomerSubId = p.CustomerSubId
                     and o.Reference     = p.Reference 
                     and not exists (select 1
                                       from pMovement m (nolock)
                                      where m.Spid        = @@spid
                                        and m.OrderID     = o.OrderID
                                        and m.OrderNumber = o.EmexOrderID 
                                     )
                   order by  
                             case when p.Quantity         = o.Quantity         then 0 else 1 end
                            ,case when p.MakeLogo         = o.MakeLogo         then 0 else 1 end
                            ,case when n.NodeID           = o.StatusID         then 0 else 1 end
                            ,case when p.PriceSale        = o.ReplacementPrice then 0 else 1 end
                            ,case when nn.EID            <= p.StatusId         then 0 else 1 end
                            ,nn.EID desc
                  ) o  
    where p.Spid     = @@SPID
      and p.OrderID is null
      and p.N = @N

     --считываем следующую строку курсора
     FETCH NEXT FROM my_cur INTO @N
END

--закрываем курсор
CLOSE my_cur
DEALLOCATE my_cur



 Update p
    set p.Flag    = case
                      when p.Quantity<>o.Quantity then isnull(p.Flag, 0)|4 -- изменилось количество
                      else isnull(p.Flag, 0) 
                    end
   from pMovement p (nolock)
  inner join tOrders o (updlock) 
          on o.OrderID = p.OrderID
  where p.Spid = @@SPID

 exec CloneOrders2 -- разбиение заказа

 insert pAccrualAction 
       (Spid,   ObjectID,  StateID, ord)
 select @@Spid, p.OrderID, o.StatusID, 0
   from pMovement p (nolock)
  inner join tOrders o (updlock) 
          on o.OrderID = p.OrderID
  where p.Spid = @@SPID
 --   and isnull(p.Flag, 0)&4=0

 ---- для добавления протокола
 Update pAccrualAction
    set ActionID   = n.NodeID
       ,NewStateID = isnull(s.NodeID, p.StateID)
       ,Retval     = case
                       when isnull(s.NodeID, p.StateID) = p.StateID then 1 -- в случае если состояние не меняется не добавляем протокол
                       else 0
                     end  
       ,Message   = m.StateText 
       ,OperDate  = m.DocumentDate
   from pAccrualAction p (updlock)
  inner join pMovement m (nolock)
          on m.spid    = @@spid
         and m.OrderID = p.ObjectID
  inner join tNodes s (nolock)
          on s.EID = m.StatusId
  inner join tNodes n (nolock)  
          on n.Brief = 'AutomaticSynchronization'
  where p.Spid = @@Spid


 Update o
    set o.StatusID = n.NodeID
       ,o.isCancel = case
                       --При отказе по причине "Нет в наличии", если отказ по всему количеству, изменять статус на "Нет в наличии", в столбец отказ проставлять True
                       when p.StatusId  = 6 /*NotAvailable*/ /*and p.Quantity = o.Quantity*/  then 1
                       --При отказе по причине "Изменение цены" проставлять отказ "Изменение цены" и подтягивать новую цену в столбец "Цена фактическая", в столбец отказ проставлять True
                       when p.StatusId  = 7 /*AGREE*/  then 1
                       else 0
                     end
       ,o.Warning  = case
                       when n.Brief  = 'Sent' then p.Comment
                       else o.Warning
                     end
       ,o.Flag     = case
                       when n.Brief  = 'Sent' then ((o.Flag&~1) &~2)
                       else o.Flag 
                     end
       ,o.updDatetime = GetDate()
       ,o.ReplacementMakeLogo     = p.ReplacementMakeLogo
       ,o.ReplacementDetailNumber = p.ReplacementDetailNumber
       ,o.ReplacementPrice        = case 
                                      when isnull(p.PriceSale, 0) > 0 and p.PriceSale <> o.PricePurchase then p.PriceSale
                                      else null
                                    end
       
       ,o.OrderDetailSubId = p.OrderDetailSubId
       ,o.Invoice          = case 
	                           when CHARINDEX('#', StateText) > 0 
	                           then SUBSTRING(StateText, CHARINDEX('#', StateText) +1, CHARINDEX(',', StateText) - CHARINDEX('#', StateText)-1 )
                               else o.Invoice
                             end



   from pMovement p (nolock)
  inner join pAccrualAction aa (nolock)
          on aa.Spid     = @@spid
         and aa.ObjectID = p.OrderID
         and aa.Retval   = 0
  inner join tOrders o (updlock) 
          on o.OrderID = p.OrderID
   left join tNodes n (nolock)
          on n.EID = p.StatusId
 where p.Spid = @@SPID


exec ProtocolAdd

exec MovementArchive

 exit_:
 return @r
go
grant exec on EmexOrderStateSync to public
go
 