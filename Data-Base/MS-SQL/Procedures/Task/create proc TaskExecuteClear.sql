drop proc if exists TaskExecuteClear
/*
  TaskExecuteClear - 
*/
go
create proc TaskExecuteClear
               @TaskID           numeric(18,0) 
as
  declare @r       int = 0
		 ,@Type    int

  DECLARE @ID TABLE (ID numeric(18,0));

  update [tTask]
     set [DateExec]   = null  
	    ,[Message]    = null 
        ,[updDatetime]= getDate()
  where TaskID = @TaskID

  Select @TaskID = ID from @ID

 exit_:
 return @r
go
grant exec on TaskExecuteClear to public
go
