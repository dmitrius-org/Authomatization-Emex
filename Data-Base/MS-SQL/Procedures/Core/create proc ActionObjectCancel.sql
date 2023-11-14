if OBJECT_ID('ActionObjectCancel') is not null
    drop proc ActionObjectCancel
go
/* 						
ActionObjectCancel - процедура проставляет данные для выполнения автоматического отказа детали при добавлении в корзину детали с замечаниями
                     работает при включенной настройки ActionObjectCancel
 */
create proc ActionObjectCancel
as

  Update p --
     set p.ActionID   = n2.NodeID
		,p.NewStateID = m.TargetStateID
		,p.ord        = 0
    from pAccrualAction p (updlock)
   inner join tOrders o (nolock)
           on o.OrderID  = p.ObjectID
		  and (o.Flag&1>0 or o.Flag&2>0)
   inner join tModel m (nolock)
           on m.StateID = p.StateID
   --       and m.ActionID= p.ActionID
   inner join tNodes n2 (nolock)
           on n2.NodeID = m.ActionID
		  and n2.Brief = 'ToCancel'	-- Отказать
  where p.Spid = @@spid

go
grant execute on ActionObjectCancel to public

