drop proc if exists UserGroupLinkDelete
/*
  UserGroupLinkDelete -  Удаление связи пользователя и группы
*/
go
create proc UserGroupLinkDelete
              @GroupID         numeric(18,0) 
             ,@UserID          numeric(18,0) 
as
  declare @r int = 0

  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran
      Delete tUserReliation
        from tUserReliation (rowlock)
       where LinkType = 2
         and UserID  = @UserID
         and GroupID = @GroupID     

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
grant exec on UserGroupLinkDelete to public
go
