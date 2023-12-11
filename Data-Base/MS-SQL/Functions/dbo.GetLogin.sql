if OBJECT_ID('GetLogin') is not null
    drop function GetLogin
/*
  GetLogin - 
*/
go

create function dbo.GetLogin()
RETURNS nvarchar(256)
WITH EXECUTE AS CALLER
AS
BEGIN
  RETURN(SUSER_NAME());
END
go
grant exec on dbo.GetLogin to public
go

