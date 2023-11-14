if OBJECT_ID('ClientReliationUpdateP') is not null
    drop proc ClientReliationUpdateP
/*
  ClientReliationUpdateP - Обновление/изменение связи c клиентом во временной таблиц
*/
go
create proc ClientReliationUpdateP
              @ID                  numeric(18,0)  
             ,@ClientID            numeric(18,0) 
             ,@LinkID              numeric(18,0) 	
             ,@LinkType            numeric(18,0) 
             --

as
  declare @r int = 0
  --if exists (select 1 
  --             from tOrderFileFormat u (nolock)
  --            where u.ClientID = @ClientID)
  --begin
  --  set @r = 0
  --  goto exit_
  --end

  delete tRetMessage from tRetMessage (rowlock) where spid=@@spid

  Update pClientReliation
     set 
          ClientID            = @ClientID
         ,LinkID              =	@LinkID
         ,LinkType            = @LinkType
    from pClientReliation (updlock)
   where ID = @ID

exit_:
return @r
go
grant exec on ClientReliationUpdateP to public
go