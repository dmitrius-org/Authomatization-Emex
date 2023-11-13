if OBJECT_ID('EmployeeUpdate') is not null
    drop proc EmployeeUpdate
/*
  EmployeeUpdate - изменение данных сотрудника
*/
go
create proc EmployeeUpdate
              @EmployeeID           numeric(18,0) --  
             ,@Brief                nvarchar(512) --
             ,@Name                    nvarchar(1024)-- 


as
  declare @r int = 0

  if exists (select 1 
               from tEmployees (nolock)
              where Brief       = @Brief
                and EmployeeID <> @EmployeeID)
  begin
    set @r = 450-- 'Сотрудник с заданным наименованием!'
    goto exit_
  end

  BEGIN TRY 
      delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
      Begin tran

        Update tEmployees
           set Brief          = @Brief
                 ,Name           = @Name
          from tEmployees (updlock)
         where EmployeeID     = @EmployeeID

        exec ClientReliationload
              @LinkID    = @EmployeeID 
             ,@LinkType  = 5
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
grant exec on EmployeeUpdate to public
go
