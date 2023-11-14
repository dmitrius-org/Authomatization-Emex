if OBJECT_ID('ClientTypeDelete') is not null
    drop proc ClientTypeDelete
/*
  ClientTypeDelete - удаление типа клиента
*/
go
create proc ClientTypeDelete
              @ClientTypeID          numeric(18,0)  --  
as
  declare @r int = 0

  if exists (select 1 
               from tClients u (nolock)
              where u.ClientTypeID = @ClientTypeID)
  begin
    set @r = 121 -- 'Удаление запрещено, тип клиента используется в справочнике "Клиенты"!'
    goto exit_
  end

 Delete tClientType
   from tClientType with (rowlock index=ao1)
  where ClientTypeID  = @ClientTypeID


 exit_:
 return @r

grant exec on ClientTypeDelete to public
go
 