if OBJECT_ID('GroupDelete') is not null
    drop proc GroupDelete
/*
  GroupDelete - удаление группы
*/
go
create proc GroupDelete
              @GroupID          numeric(18,0)  --  
as
  declare @r int = 0

  --DECLARE @ID TABLE (ID numeric(18,0));
  -- проверка на возможность удаления
 -- exec @r = UserDeleteCheck @UserID = @GroupID
  if exists (select 1 
               from tGroups g (nolock)
              inner join tUserReliation ug (nolock)
                      on ug.LinkType = 2
                     and ug.GroupID  = g.GroupID
              where g.GroupID = @GroupID)
  begin
    set @r = 8 -- 'Удаление запрещено, в группу входят пользователи!'
    goto exit_
  end
  
  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran
   
    delete tGroups
      from tGroups u (rowlock)
     where u.GroupID = @GroupID
    
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
grant exec on GroupDelete to public
go
