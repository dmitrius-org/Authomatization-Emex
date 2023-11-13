drop proc if exists GroupUpdate
/*
  GroupUpdate - Изменение сведений о пользователе
*/
go
create proc GroupUpdate
              @GroupID         numeric(18,0)  --  
             ,@Brief           nvarchar(512)  --
             ,@Name	           nvarchar(512)  -- 
as
  declare @r int = 0
  
  if exists (select 1 
               from tGroups u (nolock)
              where u.Brief    = @Brief
                and u.GroupID <> @GroupID)
  begin
    set @r =  7 --'Группа с заданным сокращением существует!'
    goto exit_
  end

  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran
        
      Update u
         set u.Brief    = @Brief
            ,u.Name     = @Name
            ,u.updDatetime = getdate()
        from tGroups u (updlock)
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
grant exec on GroupUpdate to public
go
