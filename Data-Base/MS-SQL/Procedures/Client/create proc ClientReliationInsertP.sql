if OBJECT_ID('ClientReliatioInsertP') is not null
    drop proc ClientReliatioInsertP
/*
  ClientReliatioInsertP - добавление связи c клиентом во временную таблицу
*/
go
create proc ClientReliatioInsertP
              @ID                  numeric(18,0) output -- 
             ,@ClientID            numeric(18,0) 
             ,@LinkID              numeric(18,0) 	
             ,@LinkType            numeric(18,0) 

             --

as
  declare @r int = 0

  DECLARE @tID TABLE (ID numeric(18,0));

  delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
  insert pClientReliation  
        (               
         Spid                
        ,ClientID            
        ,LinkID	             
        ,LinkType                       
        )
  OUTPUT INSERTED.ID INTO @tID
  select @@SPID      
        ,@ClientID           
        ,@LinkID        
        ,@LinkType     

  Select @ID = ID from @tID

exit_:
return @r
go
grant exec on ClientReliatioInsertP to public
go