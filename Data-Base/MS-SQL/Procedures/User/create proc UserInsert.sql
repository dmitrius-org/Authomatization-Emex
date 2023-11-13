if OBJECT_ID('UserInsert') is not null
    drop proc UserInsert
/*
  UserInsert - добавление пользователя
*/
go
create proc UserInsert
              @UserID          numeric(18,0) output --  
             ,@Brief           nvarchar(512)  --
             ,@Name	           nvarchar(512)  -- 
             --,@isAdmin	       bit      null
             ,@isBlock	       bit      = null
             ,@DateBlock       datetime = null
             ,@Password        nvarchar(512) = null
as
  declare @r int = 0

  select @Password = isnull(@Password, 'Q!123456')
  
  select @isBlock   = isnull(@isBlock, 0)
        ,@DateBlock = nullif(@DateBlock, '18991230')

  if @isBlock=1
    select @DateBlock=getdate()

  DECLARE @ID TABLE (ID numeric(18,0));

  if exists (select 1 
               from tUser u (nolock)
              where u.Brief = @Brief)
  begin
    set @r = 1 -- Пользователь с заданным логином существует
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
 
    exec('CREATE LOGIN ' + @Brief + ' WITH PASSWORD = '''+ @Password + '''')  
    exec('CREATE USER ' + @Brief + ' FOR LOGIN ' +  @Brief)  

    if @isBlock=1 -- статус пользователя
    begin
      exec('ALTER LOGIN ' + @Brief + ' DISABLE')  
    end

    insert into tUser
        (
         Brief
        ,Name
        ,isBlock
        ,DateBlock
        ,Login
        )
    OUTPUT INSERTED.UserID INTO @ID
    select @Brief     
          ,@Name	     
          ,@isBlock	 
          ,@DateBlock 
          ,@Brief
    commit tran
  END TRY  
  BEGIN CATCH  
    if @@TRANCOUNT > 0
      rollback tran
    
    set @r = -1
    insert tRetMessage(RetCode, Message) select @r,  ERROR_MESSAGE()  

    goto exit_     
  END CATCH  

   Select @UserID = ID from @ID

 exit_:
 return @r

grant exec on UserInsert to public
go
