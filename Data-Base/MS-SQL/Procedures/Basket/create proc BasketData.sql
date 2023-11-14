drop proc if exists BasketData
/*
  BasketData - агригирующие данные по корзине
*/
go

create proc BasketData
             @ClientID numeric(18, 0)
           
as
declare @r int = 0

select isnull(sum(t.Quantity * t.Price), 0) Amount
      ,Count(*)                  Cnt
      ,isnull(Sum(WeightGr)/1000, 0)        WeightGr
  from tBasket t (nolock)
 where t.ClientID  = @ClientID

                       
  exit_:

  return @r
GO
grant exec on BasketData to public
go


exec BasketData @ClientID=26