if OBJECT_ID('OrdersFinCalc') is not null
    drop proc OrdersFinCalc
/*
  OrdersFinCalc - расчет финансовых показателей

  @IsSave - сохраняет данные в tOrders
            0 - нет
            1 - да

  Входящий набор данных: pOrdersFinIn
  Результат расчета: pOrdersFin
*/
go
create proc OrdersFinCalc
              @IsSave bit =  null
             
as
declare @r int = 0

delete pOrdersFin from pOrdersFin where spid = @@Spid
insert pOrdersFin
      (Spid
      ,OrderID
      ,OrderDate
      ,ClientID
      ,PriceName
      ,Quantity
      ,Price  -- продажа
      ,PricePurchase
      ,WeightKG   
      ,VolumeKG 
      ,WeightKGF
      ,VolumeKGF
      ,Taxes
      ,Commission
      ,Margin     
      ,ExtraKurs  
      ,PdWeightKG 
      ,PdVolumeKG 
      ,PriceCommission -- Комиссия от продажи	
      )
Select @@spid
      ,o.OrderID
      ,o.OrderDate
      ,o.ClientID
      ,o.CustomerPriceLogo
      ,o.Quantity
      ,o.Price             -- цена продажи в рублях
      ,isnull(nullif(o.PricePurchaseF, 0), o.PricePurchase)     --цена закупки в долларах
      ,o.WeightKG   
      ,o.VolumeKG 
      ,p.WeightKGF
      ,p.VolumeKGF
      ,c.Taxes              --Комиссия + Налоги
      ,pc.Commission/100    --Комиссия за оплату 	Comission	ExtraKurs
      ,pc.Margin/100        --Наценка               Margin
      ,pc.ExtraKurs/100     --Комиссия на курс      ExtraKurs
      ,pd.WeightKG          --Стоимость кг	
      ,pd.VolumeKG          --Стоимость vкг
      ,o.Commission         --Комиссия от продажи	 
  from pOrdersFinIn i (nolock)
 inner join tOrders o (nolock)
         on o.OrderID = i.OrderID
 inner join tClients c (nolock)
         on c.ClientID = o.ClientID
 inner join tProfilesCustomer pc (nolock)
         on pc.ClientPriceLogo = o.CustomerPriceLogo
 inner join tProfilesDelivery pd (nolock)
         on pd.ProfilesDeliveryID = pc.ProfilesDeliveryID
  left join tPrice p (nolock)
         on p.PriceID = o.PriceID
 where i.Spid = @@Spid


Update p
   set p.Course    = c.Value
      ,p.CourseExt = c.Value + (c.Value * p.ExtraKurs)
  from pOrdersFin p
 cross apply ( select top 1 Value
                 from tCurrencyRate with (nolock index=ao2)
                where NumCode = '840'
  		          and OnDate <= p.OrderDate
  		        order by OnDate desc) c
 where p.Spid = @@Spid

 
Update p -- Закупка c комиссией	
   set p.Purchase = p.PricePurchase + (p.PricePurchase*p.Commission)
  from pOrdersFin p
 where p.Spid = @@Spid

--=if(OR(t.Orders.WeightKGF=0,t.Orders.WeightKGF=""),t.Orders.WeightKG,t.Orders.WeightKGF)*(t.ProfilesDelivery.WeightKGF+(t.ProfilesDelivery.WeightKGF*t.ProfilesCustomer.Comission))
Update pOrdersFin --Доставка fkg с комиссией
   set Deliveryfkg= isnull(nullif(WeightKGF, 0), WeightKG) * (PdWeightKG + (PdWeightKG*Commission))
 where Spid = @@Spid


--=If(OR(t.Orders.VolumeKGF=0,t.Orders.VolumeKGF=""),
--(if(t.Orders.VolumeKG>t.Orders.WeightKGF,t.Orders.VolumeKG-t.Orders.WeightKG,0)),
--(t.Orders.VolumeKGF-(if(t.Orders.WeightKGF="",t.Orders.WeightKG,t.Orders.WeightKGF))))

--*(t.ProfilesDelivery.VolumeKGF+(t.ProfilesDelivery.VolumeKGF*t.ProfilesCustomer.Comission))
Update pOrdersFin --
   set Deliveryvkg = case 
                       when nullif(VolumeKGF, 0) is null
                       then case 
                              when VolumeKG > WeightKGF
                              then VolumeKG - WeightKG
                              else 0
                            end
                       else VolumeKGF - isnull(nullif(WeightKGF, 0), WeightKG) 
                     end * (PdVolumeKG + (PdVolumeKG*Commission))
 where Spid = @@Spid


Update pOrdersFin --
   set Deliveryvkg = iif(Deliveryvkg > 0, Deliveryvkg, 0) 
 where Spid = @@Spid

Update pOrdersFin --Доставка итого,	G3
   set Delivery = Deliveryfkg + Deliveryvkg
 where Spid = @@Spid

Update pOrdersFin --Себестоимость	
   set CostPrice = Purchase + Delivery
 where Spid = @@Spid

 Update pOrdersFin --	
   set Purchase    = Purchase    * CourseExt -- Закупка c комиссией
      ,Deliveryfkg = Deliveryfkg * CourseExt -- Доставка fkg с комиссией
      ,Deliveryvkg = Deliveryvkg * CourseExt -- Доставка vkg с комиссией
      ,Delivery    = Delivery    * CourseExt -- Доставка
      ,CostPrice   = CostPrice   * CourseExt -- Себестоимость
 where Spid = @@Spid

--=(Продажа*t.Clients.Taxes)-G3*t.Clients.Taxes
Update pOrdersFin --Комиссия от продажи	
   set PriceCommission = Price * Taxes -  Delivery * Taxes
 where Spid = @@Spid
   and PriceCommission is null
 
--=((Продажа-Доставка)/Закупка)-1
Update pOrdersFin --Наценка	 
   set MarginF    = (((Price - Delivery)/Purchase) - 1)*100
 where Spid = @@Spid

--=Продажа-Комиссия-Себестоимость
Update pOrdersFin --Доход	  
   set Income    = (Price-PriceCommission-CostPrice)
 where Spid = @@Spid

--=Доход/Себестоимость
Update pOrdersFin --Доход %	  
   set IncomePrc    = (Income/CostPrice)*100
 where Spid = @@Spid
 
--=Доход/Продажа
Update pOrdersFin --Рентабельность	
   set Profit    = (Income/Price)*100
 where Spid = @@Spid


if isnull(@IsSave, 0) = 1
begin

  Update o
     set o.Margin    = p.Margin*100
	    ,o.MarginF   = p.MarginF
        ,o.Income    = p.Income	
		,o.IncomePrc = p.IncomePrc
        ,o.Profit    = p.Profit -- Рентабельность
        ,o.Commission=isnull(o.Commission, p.PriceCommission) -- Комиссия от продажи
    from pOrdersFin p (nolock)
   inner join tOrders o with (updlock)
           on o.OrderID = p.OrderID
   --inner join tPrice p (nolock) 
   --        on p.PriceID = o.PriceID
   where p.Spid = @@Spid
end

--select Tax, Income, ExtraCharge, Profitability, '|', Purchase, Deliveryfkg, Deliveryvkg, Delivery, CostPrice, '|', * 
--  from pOrdersFin (nolock)
-- where Spid = @@Spid


 exit_:
 return @r
go
  grant exec on OrdersFinCalc to public
go
 