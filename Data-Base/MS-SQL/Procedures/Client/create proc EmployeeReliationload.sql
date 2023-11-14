if OBJECT_ID('EmployeeReliationload') is not null
    drop proc EmployeeReliationload
/*
  EmployeeReliationload - 
  @ClientID  - Ид клиента
  @Direction - 0 - с постоянной во временную
               1 - с временной в постоянную
*/
go
create proc EmployeeReliationload
              @ClientID    numeric(18, 0)  
             ,@Direction   int 
as
  set nocount on
  declare @r int

  select @R         = 0
        ,@Direction = isnull(@Direction, 0)

  if @Direction = 0
  begin
	  delete pClientReliation from pClientReliation (rowlock) where spid = @@spid
	  insert pClientReliation  
			 (               
             Spid                
            ,ClientReliationID   
            ,ClientID            
            ,LinkID	             
            ,LinkType                       
			)
	  select @@Spid                                                              
            ,ClientReliationID   
            ,ClientID            
            ,LinkID	             
            ,LinkType  
	   from tClientReliation (nolock)
	  where LinkType = 5
        and ClientID = @ClientID
  end
  else
  begin

    delete tClientReliation
	  from tClientReliation t  (rowlock)
	 where t.LinkType = 5 
       and t.ClientID = @ClientID
	   and not exists ( select 1
	                      from pClientReliation p (nolock)
						 where p.Spid              = @@spid
						   and p.ClientReliationID = t.ClientReliationID
						   and isnull(p.ClientReliationID, 0) <> 0   
                      )

	  insert tClientReliation  
			(ClientID            
            ,LinkID	             
            ,LinkType)
	  select isnull(nullif(ClientID, 0), @ClientID)             
            ,LinkID
            ,LinkType   
	   from pClientReliation (nolock)
	  where Spid     = @@Spid 
        and LinkType = 5
	    and isnull(ClientReliationID, 0) = 0

     Update t
        set t.ClientID = p.ClientID      
           ,t.LinkID   = p.LinkID   
       from pClientReliation p (nolock)
      inner join tClientReliation t (updlock)
              on t.ClientReliationID = p.ClientReliationID
      where p.Spid     = @@Spid 
        and p.LinkType = 5
  end


exit_:
return @r
go
grant exec on EmployeeReliationload to public
go
