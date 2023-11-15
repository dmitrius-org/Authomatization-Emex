if OBJECT_ID('ClientInsert') is not null
    drop proc ClientInsert
/*
  ClientInsert - добавление клиента
*/
go
create proc ClientInsert
              @ClientID             numeric(18,0) output --  
             ,@Brief                nvarchar(512)  --
             ,@Name	                nvarchar(1024)  -- 
			 ,@SuppliersID          numeric(18,0)=null--поставщик
			 ,@IsActive             bit
			 ,@Taxes                money        -- налоги
             ,@ResponseType         int          -- Тип ответа
             ,@NotificationMethod   int          -- Способ оповещения
             ,@NotificationAddress  nvarchar(256)-- Адрес оповещения
             ,@ClientTypeID	        int         =null -- Тип клиента

as
  declare @r int = 0

  DECLARE @ID TABLE (ID numeric(18,0));

  if exists (select 1 
               from tClients u (nolock)
              where u.Brief = @Brief)
  begin
    set @r = 100 -- 'Клиент с заданным наименование существует'
    goto exit_
  end

  BEGIN TRY 
      delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
      Begin tran

		insert into tClients
		      (
		       Brief
		      ,Name
		      ,SuppliersID
		      ,IsActive 
		      ,UserID
			  ,Taxes 
              ,ResponseType
              ,NotificationMethod
              ,NotificationAddress
              ,ClientTypeID	
		       )
		OUTPUT INSERTED.ClientID INTO @ID
		select @Brief     
		      ,@Name	
		      ,@SuppliersID
		      ,@IsActive
		      ,dbo.GetUserID()	
			  ,@Taxes -- налоги %
              ,@ResponseType
              ,@NotificationMethod
              ,@NotificationAddress
              ,@ClientTypeID	

		Select @ClientID = ID from @ID	    
 
	    exec @r=OrderFileFormat_load 
		          @ClientID  = @ClientID,
			      @Direction = 1

        if @r = 0
          exec @r=EmployeeReliationload
                    @ClientID  = @ClientID 
                   ,@Direction = 1  
		
		if @r <> 0
		begin 
		  RAISERROR (15600, 16, 1, @r);
		end

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
grant exec on ClientInsert to public
go
