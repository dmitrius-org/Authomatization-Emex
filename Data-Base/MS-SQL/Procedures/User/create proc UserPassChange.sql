drop proc if exists UserPassChange
/*
  UserPassChange - 
*/
go
create proc UserPassChange
              @OldPas          nvarchar(256) --  
             ,@NewPas          nvarchar(256) --  
as
  declare @r int = 0

  if @OldPas=@NewPas
  begin
    set @r = 5 --Старый и новый пароли не должны совподать
    goto exit_
  end

  declare @User nvarchar(256)
  select @User = SUSER_NAME() 

  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran

      exec('ALTER LOGIN ' + @User + ' WITH PASSWORD = ''' + @NewPas + ''' OLD_PASSWORD = ''' + @OldPas + '''')

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
grant exec on UserPassChange to public
go
