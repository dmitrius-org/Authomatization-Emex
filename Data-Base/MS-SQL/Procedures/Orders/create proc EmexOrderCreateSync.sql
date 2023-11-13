if OBJECT_ID('EmexOrderSave') is not null
    drop proc EmexOrderSave

go
if OBJECT_ID('EmexOrderCreateSync') is not null
    drop proc EmexOrderCreateSync

/*
  EmexOrderCreateSync - процедура проставления номера заказа emex после размещения заказа
*/
go
create proc EmexOrderCreateSync
              @EmexOrderID int
as
 declare @r int = 0

 Update p
    set p.OrderID = o.OrderID
   from pMovement p (updlock) 
  cross apply (select top 1 *
                 from tOrders o (nolock) 
                where o.DetailNumber = p.DetailNum
                 order by case 
				            when o.CustomerSubId = p.CustomerSubId 
							  then 1
                              else 2
						  end
                         ,case 
				            when o.MakeLogo      = p.MakeLogo 
							  then 1
                              else 2
						  end
						 ,case 
				            when o.PriceLogo     = p.PriceLogo
							  then 1
                              else 2
						  end
						 ,case 
				            when o.Reference     = p.Reference 
							  then 1
                              else 2
						  end

               ) o   
 where p.Spid               = @@SPID
  -- and isnull(p.OrderID, 0) = 0
  
 -- ошибка нужна для того, чтобы деталь не изменила статус
 Update p
    set p.Retval = 510 -- Нет позиций для заказа!
   from pAccrualAction p (updlock)
  where p.Spid   = @@SPID
    and p.Retval = 0
    and not exists (select 1
	                  from pMovement o (nolock)
  	                 where o.Spid = @@SPID
	                   and o.OrderID = p.ObjectID)

 Update o
    set o.EmexOrderID = @EmexOrderID
       ,o.Flag        = ((o.Flag&~1) &~2)
	   ,o.updDatetime = GetDate()
   from pMovement p (nolock)
  inner join tOrders o (updlock)
          on o.OrderID = p.OrderID
 where p.Spid       = @@SPID
   and p.OrderNumber=@EmexOrderID


/**
И еще момент который мы проговаривали, но еще не реализовали: если деталь попала в статус "в работе", а поля WeightKGF и VolumeKGF пустые, то их нужно заполнять из WeightKG и VolumeKG соответственно*/
 Update pr
    set pr.WeightKGF = isnull(pr.WeightKGF, o.WeightKG)
	   ,pr.VolumeKGf = isnull(pr.VolumeKGf, o.VolumeKG)
   from pMovement p (nolock)
  inner join tOrders o (nolock)
          on o.OrderID = p.OrderID
  inner join tPrice pr (updlock)
          on pr.PriceID = o.PriceID
 where p.Spid       = @@SPID
   and p.OrderNumber=@EmexOrderID

  exit_:
  return @r
go
grant exec on EmexOrderCreateSync to public
go
 