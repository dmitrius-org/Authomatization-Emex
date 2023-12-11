if OBJECT_ID('GetRetMsg') is not null
    drop function GetRetMsg
/*
  GetRetMsg - 
*/
go

create function dbo.GetRetMsg
              (@RetCode numeric(18,0))
RETURNS nvarchar(1024)
WITH EXECUTE AS CALLER
AS
BEGIN
  declare @Message nvarchar(1024);


  if @RetCode > 0
    Select @Message = Message 
      from tRetCode with (nolock index=ao1)  
     where RetCode = @RetCode
  else
    Select @Message = Message 
      from tRetMessage with (nolock index=ao1) 
     where spid     = @@spid
       and RetCode  = @RetCode

  RETURN(@Message);
END
go
grant exec on dbo.GetRetMsg to public
go
