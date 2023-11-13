if OBJECT_ID('ClientEmployeeReliationDelete') is not null
    drop proc ClientEmployeeReliationDelete
/*
  ClientEmployeeReliationDelete - Удаление связи c клиентами
*/
go
create proc ClientEmployeeReliationDelete
              --@OrderFileFormatID   numeric(18,0) -- 
              @LinkID           numeric(18,0) 
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
   where LinkID = @LinkID 
     and LinkType = 5

exit_:
return @r
go
grant exec on ClientEmployeeReliationDelete to public
go