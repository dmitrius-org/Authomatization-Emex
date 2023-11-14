if OBJECT_ID('OrderFileFormatDelete') is not null
    drop proc OrderFileFormatDelete
/*
  OrderFileFormatDelete - Удаление формата файла заказа
*/
go
create proc OrderFileFormatDelete
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

  delete tOrderFileFormat
    from tOrderFileFormat (rowlock)
   where ClientID = @ClientID   

exit_:
return @r
go
grant exec on OrderFileFormatDelete to public
go