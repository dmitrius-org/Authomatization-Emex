
if OBJECT_ID('PriceUpdate') is not null
  drop proc PriceUpdate
go

/* **********************************************************
 PriceUpdate  - добавление/обновление данных по прайсам в БД
********************************************************** */
create proc PriceUpdate
as
declare @PriceLogo         varchar(30)    -- Название прайса 

declare @ID as table (ID numeric(18, 0) primary key)

select top 1
       @PriceLogo = PriceLogo
  from #Price with (nolock index=ao3)

if isnull(@PriceLogo, '') = ''
  goto exit_

update t
   set 	t.DetailPrice  = p.DetailPrice
	   ,t.DetailName   = p.DetailName  
	   ,t.PriceLogo    = rtrim(p.PriceLogo)
	   ,t.Quantity     = iif(p.Quantity = 0, 999, p.Quantity)  
	   ,t.PackQuantity = p.PackQuantity
	   ,t.Reliability  = p.Reliability -- Вероятность поставки 
	   ,t.WeightKG     = p.WeightKG
  	   ,t.VolumeKG	   = p.VolumeKG
	   ,t.MOSA         = p.MOSA
	   ,t.Restrictions = nullif(p.Restrictions, '')
       ,t.updDatetime  = GetDate()
OUTPUT INSERTED.PriceID INTO @ID(ID)      
  from #Price p with (nolock index=ao3)       
 inner join tPrice t with (updlock index=ao3) 
         on t.PriceLogo = @PriceLogo--p.PriceLogo
	    and t.DetailNum = p.DetailNum
	    and t.MakeLogo  = p.MakeLogo

insert into tPrice with (rowlock)
      (     
       MakeLogo 
	  ,Brand    
      ,DetailNum	  
      ,DetailPrice  
      ,DetailName	  
      ,PriceLogo    
      ,Quantity     
      ,PackQuantity 
      ,Reliability  -- Вероятность поставки
      ,WeightKG     
      ,VolumeKG 
	  ,MOSA  
	  ,Restrictions
       ) 
OUTPUT INSERTED.PriceID INTO @ID(ID)
select p.MakeLogo 
	  ,m.Name      -- наименование бренда     
	  ,p.DetailNum	  
	  ,p.DetailPrice  
	  ,p.DetailName	  
	  ,rtrim(p.PriceLogo)
	  ,iif(p.Quantity = 0, 999, p.Quantity)    -- если количество равно 0, то ставим 999
	  ,p.PackQuantity 
	  ,p.Reliability  -- Вероятность поставки
	  ,p.WeightKG     
  	  ,p.VolumeKG 
	  ,p.MOSA  
	  ,nullif(p.Restrictions, '')
  from tMakes m with (nolock index=ao2)  
 inner join #Price p with (nolock index=ao2) 
         on p.MakeLogo = m.Code  
 where not exists (select 1
                     from tPrice t with (nolock index=ao3)
                    where t.PriceLogo = @PriceLogo--p.PriceLogo
					  and t.DetailNum = p.DetailNum
					  and t.MakeLogo  = p.MakeLogo
				   )

delete p
  from tPrice p with (rowlock index=ao3)
 where p.PriceLogo = @PriceLogo    
   and isnull(p.WeightKGF  , '') = ''
   and isnull(p.VolumeKGf  , '') = ''
   and isnull(p.DetailNameF, '') = ''
   and not exists (select 1
                     from @ID t
					where t.ID = p.PriceID)	

Update p
   set p.Reliability  = 0 
  from tPrice p with (rowlock index=ao3)
 where p.PriceLogo = @PriceLogo    
   and (isnull(p.WeightKGF  , '') <> ''
     or isnull(p.VolumeKGf  , '') <> ''
     or isnull(p.DetailNameF, '') <> ''
	 )
   and not exists (select 1
                     from @ID t
					where t.ID = p.PriceID)	
					

if not exists (select 1
                 from tProfilesPrice (nolock)
                where PriceName = @PriceLogo
		       )
begin
  insert tProfilesPrice with (rowlock)
        (isActive, PriceName, UpdateDate)
  select 1, @PriceLogo, GetDate()
end
begin
  update tProfilesPrice
     set UpdateDate=GetDate()
   where PriceName=@PriceLogo
     and isActive = 1
end


exit_:
go
grant execute on PriceUpdate to public
