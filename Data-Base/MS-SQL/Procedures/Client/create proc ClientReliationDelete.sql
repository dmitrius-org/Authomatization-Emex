if OBJECT_ID('ClientReliationDelete') is not null
    drop proc ClientReliationDelete
/*
  ClientReliationDelete - Удаление связи
*/
go
create proc ClientReliationDelete
              --@OrderFileFormatID   numeric(18,0) -- 
              @ClientID            numeric(18,0) 
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

  --delete tRetMessage from tRetMessage (rowlock) where spid=@@spid

  delete tClientReliation
    from tClientReliation (rowlock)
   where ClientID = @ClientID   

exit_:
return @r
go
grant exec on ClientReliationDelete to public
go