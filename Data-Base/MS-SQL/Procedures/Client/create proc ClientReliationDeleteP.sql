if OBJECT_ID('ClientReliationDeleteP') is not null
    drop proc ClientReliationDeleteP
/*
  ClientEmployeeReliationP - Удаление связи клиента и сотрудника из временной таблицы
*/
go
create proc ClientReliationDeleteP
              @ID            numeric(18,0) 
--
as
  declare @r int = 0

  delete pClientReliation from pClientReliation (rowlock) where ID = @ID   

exit_:
return @r
go
grant exec on ClientReliationDeleteP to public
go