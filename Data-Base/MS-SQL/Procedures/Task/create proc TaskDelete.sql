drop proc if exists TaskDelete
/*
  TaskDelete - 
*/
go
create proc TaskDelete
               @TaskID           numeric(18,0) 
as
  declare @r       int = 0

  delete from tTask where TaskID=@TaskID 

 exit_:
 return @r
go
grant exec on TaskDelete to public
go
