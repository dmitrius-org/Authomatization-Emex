if OBJECT_ID('UserDelete') is not null
    drop proc UserDelete
/*
  UserDelete - удаление пользователя
*/
go
create proc UserDelete
              @UserID          numeric(18,0)  --  
as
  declare @r int = 0

  --DECLARE @ID TABLE (ID numeric(18,0));
  -- проверка на возможность удаления
  exec @r = UserDeleteCheck @UserID = @UserID
  if @r > 0
  begin
    goto exit_
  end

  if IS_SRVROLEMEMBER('sysadmin') is null
  begin
    set @r = 2 -- Пользователь должен иметь права [sysadmin]
    goto exit_
  end


  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran

    declare @Brief nvarchar(512)
           ,@Login nvarchar(512) 

    select @Brief = Brief 
          ,@Login = Login
      from tUser (nolock)
     where UserID=@UserID


    -- Check database user
    IF USER_ID(@Brief) IS NOT NULL
      exec('Drop USER ' + @Brief)
     
    IF SUSER_ID(@Login) IS NOT NULL
      exec('Drop LOGIN ' + @Login)  
    
    delete tUser
      from tUser u (rowlock)
     where u.UserID = @UserID
    
    commit tran
  END TRY  
  BEGIN CATCH  
    if @@TRANCOUNT > 0
      rollback tran
 
    set @r = -1
    insert tRetMessage(RetCode, Message) select @r,  ERROR_MESSAGE()  

    goto exit_     
  END CATCH 


 exit_:
 return @r
go
grant exec on UserDelete to public
go
