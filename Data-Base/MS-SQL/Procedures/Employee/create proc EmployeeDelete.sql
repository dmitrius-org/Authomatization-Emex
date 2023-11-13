if OBJECT_ID('EmployeeDelete') is not null
    drop proc EmployeeDelete
/*
  EmployeeDelete - удаление сотрудника
*/
go
create proc EmployeeDelete
              @EmployeeID          numeric(18,0)  --  
as
  declare @r int = 0

  if exists (select 1 
               from tClientReliation (nolock)
              where LinkType =  5 -- Связь клиентов и сотрудников
                and LinkID   = @EmployeeID
              )
  begin
    set @r = 451-- 'Удаление запрещено, менеджер связан с клиентом!'
    goto exit_
  end

  BEGIN TRY 
      delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
      Begin tran
 
        Delete tEmployees
          from tEmployees with (rowlock index=ao1)
         where EmployeeID  = @EmployeeID

        exec ClientEmployeeReliationDelete @LinkID = @EmployeeID

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

grant exec on EmployeeDelete to public
go
 