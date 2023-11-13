if OBJECT_ID('MakesUpdate') is not null
  drop proc MakesUpdate
go

/* **********************************************************

********************************************************** */
create proc MakesUpdate
as

insert tMakes (
       Code   
      ,Name	
      ,Country
      ) 
select Code     
      ,Name	 
      ,Country	 
  from #Makes p (nolock)
 where not exists (select 1
                     from tMakes t (nolock)
					where t.Code  = p.Code
				)

update t
   set t.Code    = p.Code  
      ,t.Name    = p.Name    
      ,t.Country = p.Country
      ,t.updDatetime  = GetDate()     
  from #Makes p (nolock)       
 inner join tMakes t (updlock)        
         on t.Code  = p.Code  

go
grant execute on MakesUpdate to public