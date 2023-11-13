if OBJECT_ID('SupplierUpdate') is not null
    drop proc SupplierUpdate
/*
  SupplierUpdate - изменение данных поставщика
*/
go
create proc SupplierUpdate
              @SuppliersID          numeric(18,0) --  
             ,@Brief                nvarchar(512) --
             ,@Name                 nvarchar(1024)-- 
             ,@emexUsername         nvarchar(32)=null--Пользователь для интеграции
             ,@emexPassword         nvarchar(32)=null--Пароль для интеграции

as
  declare @r int = 0

  if exists (select 1 
               from tSuppliers (nolock)
              where Brief        = @Brief
                and SuppliersID <> @SuppliersID)
  begin
    set @r = 200 -- 'Поставщик с заданным наименованием!'
    goto exit_
  end

  BEGIN TRY 
      delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
      Begin tran

        Update tSuppliers
           set Brief               = @Brief
                 ,Name             = @Name
              ,emexUsername        = @emexUsername
              ,emexPassword        = @emexPassword
          from tSuppliers (rowlock)
         where SuppliersID     = @SuppliersID
        
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
grant exec on SupplierUpdate to public
go
