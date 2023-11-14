if OBJECT_ID('OrderFileFormat_load') is not null
    drop proc OrderFileFormat_load
/*
  OrderFileFormat_load - 

  @Direction - 0 - с постоянной во временную
               1 - с временной в постоянную
*/
go
create proc OrderFileFormat_load
              @ClientID  numeric(18, 0)      
             ,@Direction int 
as
  set nocount on
  declare @r int

  if @Direction = 0
  begin
	  delete pOrderFileFormat from pOrderFileFormat (rowlock) where spid = @@spid
	  insert pOrderFileFormat  
			 (
			 Spid                  
			,OrderFileFormatID     
			,ClientID              
			,Folder                
			,Firstline             
			,Manufacturer          
			,DetailNumber          
			,Quantity              
			,DetailID              
			,DetailName            
			,Price                 
			,Amount                
			,OrderNum              
			,OrderDate             
			,PriceNum              
			,Commission            
			,IsActive              
			,CustomerSubID         
			,Reference             
			)
	  select
			 @@Spid                  
			,OrderFileFormatID     
			,ClientID              
			,Folder                
			,Firstline             
			,Manufacturer          
			,DetailNumber          
			,Quantity              
			,DetailID              
			,DetailName            
			,Price                 
			,Amount                
			,OrderNum              
			,OrderDate             
			,PriceNum              
			,Commission            
			,IsActive              
			,CustomerSubID         
			,Reference 
	   from tOrderFileFormat (nolock)
	  where ClientID = @ClientID
  end
  else
  begin
     --Update p
     --   set p.ClientID = @ClientID    
     --  from pOrderFileFormat p (nolock)
     -- where p.Spid                = @@Spid 
  	  --  and isnull(p.ClientID, 0) = 0

    delete tOrderFileFormat
	  from tOrderFileFormat t  (rowlock)
	 where t.ClientID = @ClientID
	   and not exists ( select 1
	                      from pOrderFileFormat p (nolock)
						 where p.Spid              = @@spid
						   and p.OrderFileFormatID = t.OrderFileFormatID
						   and isnull(p.OrderFileFormatID, 0) <> 0   )

	  insert tOrderFileFormat  
			 (              
			 ClientID              
			,Folder                
			,Firstline             
			,Manufacturer          
			,DetailNumber          
			,Quantity              
			,DetailID              
			,DetailName            
			,Price                 
			,Amount                
			,OrderNum              
			,OrderDate             
			,PriceNum              
			,Commission            
			,IsActive              
			,CustomerSubID         
			,Reference             
			)
	  select isnull(nullif(ClientID, 0), @ClientID)
			,Folder                
			,Firstline             
			,Manufacturer          
			,DetailNumber          
			,Quantity              
			,DetailID              
			,DetailName            
			,Price                 
			,Amount                
			,OrderNum              
			,OrderDate             
			,PriceNum              
			,Commission            
			,IsActive              
			,CustomerSubID         
			,Reference 
	   from pOrderFileFormat (nolock)
	  where Spid     = @@Spid 
	    and isnull(OrderFileFormatID, 0) = 0

     Update t
        set t.Folder        = p.Folder      
           ,t.Firstline     = p.Firstline   
           ,t.Manufacturer  = p.Manufacturer
           ,t.DetailNumber  = p.DetailNumber 
           ,t.Quantity      = p.Quantity    
           ,t.DetailID      = p.DetailID         
           ,t.DetailName    = p.DetailName   
           ,t.Price         = p.Price       
           ,t.Amount        = p.Amount      
           ,t.OrderNum      = p.OrderNum    
           ,t.OrderDate     = p.OrderDate   
           ,t.PriceNum      = p.PriceNum    
           ,t.Commission    = p.Commission  
           ,t.CustomerSubID = p.CustomerSubID 
           ,t.Reference     = p.Reference 
           ,t.IsActive      = p.IsActive
       from pOrderFileFormat p (nolock)
      inner join tOrderFileFormat t (updlock)
              on t.OrderFileFormatID = p.OrderFileFormatID
      where p.Spid     = @@Spid 

  end


exit_:
return @r
go
grant exec on OrderFileFormat_load to public
go
