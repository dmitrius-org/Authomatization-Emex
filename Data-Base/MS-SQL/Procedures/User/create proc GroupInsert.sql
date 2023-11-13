drop proc if exists GroupInsert
/*
  GroupInsert - добавление группы
*/
go
create proc GroupInsert
              @GroupID         numeric(18,0) output --  
             ,@Brief           nvarchar(512)  --
             ,@Name	           nvarchar(512)  -- 
as
  declare @r int = 0

  DECLARE @ID TABLE (ID numeric(18,0));

  if exists (select 1 
               from tGroups (nolock)
              where Brief = @Brief)
  begin
    set @r =  7 --'Группа с заданным сокращением существует!'
    goto exit_
  end

  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran

    insert into tGroups
        (
         Brief
        ,Name
        )
    OUTPUT INSERTED.GroupID  INTO @ID
    select @Brief     
          ,@Name	     

    commit tran
  END TRY  
  BEGIN CATCH  
    if @@TRANCOUNT > 0
      rollback tran
    
    set @r = -1
    insert tRetMessage(RetCode, Message) select @r,  ERROR_MESSAGE()  

    goto exit_     
  END CATCH  

   Select @GroupID = ID from @ID

 exit_:
 return @r
go
grant exec on GroupInsert to public
go
