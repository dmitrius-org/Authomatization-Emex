if OBJECT_ID('UserGroupLinkInsert') is not null
    drop proc UserGroupLinkInsert
/*
  UserGroupLinkInsert - Добавление связи пользователя и группы
*/
go
create proc UserGroupLinkInsert
              @GroupID         numeric(18,0) 
             ,@UserID          numeric(18,0) 
as
  declare @r int = 0

  --DECLARE @ID TABLE (ID numeric(18,0));

  if exists (select 1 
               from tUserReliation (nolock)
              where LinkType = 2
                and UserID  = @UserID
                and GroupID = @GroupID)
  begin
    set @r =  9 -- 'Связь пользователя и группы существет!'
    goto exit_
  end

  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran

    insert into tUserReliation
          (
           LinkType
          ,UserID
          ,GroupID
          )
  --  OUTPUT INSERTED.GroupID  INTO @ID
    select 2     
          ,@UserID
          ,@GroupID

    commit tran
  END TRY  
  BEGIN CATCH  
    if @@TRANCOUNT > 0
      rollback tran
    
    set @r = -1
    insert tRetMessage(RetCode, Message) select @r,  ERROR_MESSAGE()  

    goto exit_     
  END CATCH  

  -- Select @GroupID = ID from @ID

 exit_:
 return @r
go
grant exec on UserGroupLinkInsert to public
go
