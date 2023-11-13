drop proc if exists UserUpdate
/*
  UserUpdate - Изменение сведений о пользователе

  @isBlock:
  ENABLE | DISABLE — включает или отключает это имя входа. Отключение входа не влияет на поведение имен входа, которые уже подключены. 
  (Чтобы завершить существующие подключения, используйте инструкцию KILL.) 
  Отключенные имена входа сохраняют свои разрешения и все еще могут быть олицетворены.
*/
go
create proc UserUpdate
              @UserID          numeric(18,0)  --  
             ,@Brief           nvarchar(512)  --
             ,@Name	           nvarchar(512)  -- 
             ,@isBlock	       bit      =null
             ,@DateBlock       datetime =null
as
  declare @r int = 0
  
  select @isBlock   = isnull(@isBlock, 0)
        ,@DateBlock = isnull(nullif(@DateBlock, '18991230'), GetDate()) --nullif(u.DateBlock, '18991230')

  if exists (select 1 
               from tUser u (nolock)
              where u.Brief  = @Brief
                and u.UserID <> @UserID)
  begin
    set @r = 1 -- Пользователь с заданным логином существует
    goto exit_
  end

  BEGIN TRY 
    delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
    Begin tran
      --declare @oldBrief nvarchar(512)

      --select @oldBrief = u.Brief
      --  from tUser u (nolock)
      -- where u.UserID = @UserID

      -- меняем имя пользователя в базе данных
      --if @oldBrief <> @Brief
      --if IS_SRVROLEMEMBER('sysadmin') is null -- для изменения логина пользователь должен иметь права [sysadmin] 
      --begin
      --  set @r = 2 --
      --  goto exit_
      --end
      --else
      --   exec('ALTER USER ' + @oldBrief + ' WITH NAME = ' + @Brief)  

      --if @oldBrief <> @Brief
      if exists (SELECT is_disabled from sys.server_principals WHERE name = @Brief and is_disabled = 1) or @isBlock = 1
          if IS_SRVROLEMEMBER('sysadmin') is null -- для изменения логина пользователь должен иметь права [sysadmin] 
          begin
              set @r = 2 --
              goto exit_
          end
          else
          begin
              if @isBlock=1
              begin
                  exec('ALTER LOGIN ' + @Brief + ' DISABLE')  
              end
              else
              begin
                  exec('ALTER LOGIN ' + @Brief + ' ENABLE')  
              end
          end
         
      Update u
         set u.Brief    = @Brief
            ,u.Name     = @Name
            ,u.isBlock  = @isBlock
            ,u.DateBlock= case  
                            when @isBlock = 0 
                            then null
                            else @DateBlock
                           end
            ,u.updDatetime = getdate()
        from tUser u (updlock)
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
grant exec on UserUpdate to public
go
