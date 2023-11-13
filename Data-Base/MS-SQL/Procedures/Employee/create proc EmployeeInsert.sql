if OBJECT_ID('EmployeeInsert') is not null
    drop proc EmployeeInsert
/*
  EmployeeInsert - добавление 
*/
go
create proc EmployeeInsert
              @EmployeeID          numeric(18,0) output --  
             ,@Brief               nvarchar(512)  --
             ,@Name                   nvarchar(1024)  -- 


as
  declare @r int = 0

  DECLARE @ID TABLE (ID numeric(18,0));

  if exists (select 1 
               from tEmployees e (nolock)
              where e.Brief = @Brief)
  begin
    set @r = 450-- 'Сотрудник с заданным наименованием!'
    goto exit_
  end

  BEGIN TRY 
      delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
      Begin tran

        insert into tEmployees
              (
               Brief
              ,Name
               )
        OUTPUT INSERTED.EmployeeID INTO @ID
        select @Brief     
              ,@Name    

        Select @EmployeeID = ID from @ID        
 
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
grant exec on EmployeeInsert to public
go
