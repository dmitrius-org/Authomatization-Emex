if OBJECT_ID('EmexRefusalsCalc') is not null
    drop proc EmexRefusalsCalc
/*
  EmexRefusalsCalc - количество отказанных деталей для отказа
*/
go

create proc [dbo].[EmexRefusalsCalc]
              @Brent         nvarchar(64)
             ,@DetailNumber  nvarchar(64)
             ,@DetailID      numeric(18, 0)
             ,@RefusalsCount int  OUTPUT
as
  set nocount on

  declare @r             int = 0
         

  delete pEmexRefusalsCalc from pEmexRefusalsCalc (rowlock) where spid = @@Spid

  insert pEmexRefusalsCalc
        (Spid, OrderID, isCancel, isCancelToClient, Quantity)
  select @@Spid
        ,o.OrderID
        ,o.isCancel
        ,isnull(o.isCancelToClient, 0)
        ,o.Quantity
    from tOrders o (nolock)
   where o.DetailNumber = @DetailNumber
     and o.Manufacturer = @Brent
     and cast(o.DetailID as numeric(18, 0)) = @DetailID
     and o.ClientID     = 3

  if exists (select 1 
               from pEmexRefusalsCalc (nolock)
              where spid = @@Spid
             )

    select  @RefusalsCount  = isnull((  select sum(Quantity)
                                          from pEmexRefusalsCalc (nolock)
                                         where spid             = @@Spid
                                           and isCancel         = 1
                                           and isCancelToClient = 0
                                         
                                         ), 0)

   else
     select @RefusalsCount = null

  exit_:

  return @r
GO
grant exec on EmexRefusalsCalc to public
go

