if OBJECT_ID('GetUserID') is not null
    drop function GetUserID
/*
  GetUserID - 
*/
go

create function dbo.GetUserID()
RETURNS numeric(18, 0)
WITH EXECUTE AS CALLER
AS
BEGIN
  declare @UserID numeric(18,0)

  select @UserID = UserID
    from tUser (nolock)
   where brief = dbo.GetLogin()

  RETURN(@UserID);
END
go
grant exec on dbo.GetUserID to public
go

