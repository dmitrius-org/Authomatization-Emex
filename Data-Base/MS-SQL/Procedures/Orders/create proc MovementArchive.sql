if OBJECT_ID('MovementArchive') is not null
    drop proc MovementArchive
/*
  MovementArchive - Архив синхронизационных данных по заказу.
                    Сведения о заказе полученные от emex
*/
go

Create proc MovementArchive
as
 declare @r int = 0

delete t
  from pMovement p (nolock)
 inner join tMovement t (rowlock)
         on p.OrderNumber      = t.OrderNumber
        and p.DetailNum        = t.DetailNum
        and p.CustomerSubId    = t.CustomerSubId
      --  and p.OrderDetailSubId = t.OrderDetailSubId 
 where p.spid = @@spid


 insert tMovement
      (
       OrderID                
      ,OrderNumber            
      ,Comment                
      ,OrderDetailSubId       
      ,DocumentDate           
      ,PriceOrdered           
      ,PriceSale              
      ,MakeLogo               
      ,DetailNum              
      ,Quantity               
      ,Condition              
      ,Reference              
      ,DetailNameRus          
      ,DetailNameEng          
      ,CustomerSubId          
      ,DestinationLogo        
      ,PriceLogo              
      ,ReplacementMakeLogo    
      ,ReplacementDetailNumber
      ,StatusId               
      ,StateText              
      ,Flag                   
      ,Tag                    
      )
select
       p.OrderID                
      ,p.OrderNumber            
      ,p.Comment                
      ,p.OrderDetailSubId       
      ,p.DocumentDate           
      ,p.PriceOrdered           
      ,p.PriceSale              
      ,p.MakeLogo               
      ,p.DetailNum              
      ,p.Quantity               
      ,p.Condition              
      ,p.Reference              
      ,p.DetailNameRus          
      ,p.DetailNameEng          
      ,p.CustomerSubId          
      ,p.DestinationLogo        
      ,p.PriceLogo              
      ,p.ReplacementMakeLogo    
      ,p.ReplacementDetailNumber
      ,p.StatusId               
      ,p.StateText              
      ,0                   
      ,p.Tag 
  from pMovement p (nolock)
 where spid = @@spid
   --and not exists (select 1
   --                  from tMovement pp (nolock)
   --                 where p.OrderNumber      = pp.OrderNumber
   --                   and p.DetailNum        = pp.DetailNum
   --                   and p.CustomerSubId    = pp.CustomerSubId
   --                   and p.OrderDetailSubId = pp.OrderDetailSubId  )

--Update t
--   set t.OrderID                =p.OrderID   
--      ,t.Comment                =p.Comment  
--      ,t.DocumentDate           =p.DocumentDate 
--      ,t.PriceOrdered           =p.PriceOrdered  
--      ,t.PriceSale              =p.PriceSale 
--      ,t.MakeLogo               =p.MakeLogo 
--      ,t.Quantity               =p.Quantity
--      ,t.Condition              =p.Condition
--      ,t.Reference              =p.Reference 
--      ,t.DetailNameRus          =p.DetailNameRus 
--      ,t.DetailNameEng          =p.DetailNameEng 
--      ,t.CustomerSubId          =p.CustomerSubId 
--      ,t.DestinationLogo        =p.DestinationLogo
--      ,t.ReplacementMakeLogo    =p.ReplacementMakeLogo 
--      ,t.ReplacementDetailNumber=p.ReplacementDetailNumber
--      ,t.StatusId               =p.StatusId   
--      ,t.StateText              =p.StateText 
--      ,t.Tag                    =p.Tag 
--  from pMovement p (nolock)
-- inner join tMovement t (updlock)
--         on p.OrderNumber      = t.OrderNumber
--        and p.DetailNum        = t.DetailNum
--        and p.CustomerSubId    = t.CustomerSubId
--        and p.OrderDetailSubId = t.OrderDetailSubId 


  exit_:

  return @r


GO
grant exec on MovementArchive to public
go