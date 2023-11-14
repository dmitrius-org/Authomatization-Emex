drop proc if exists GetAppInfo
/*
  GetAppInfo 

*/
go
create proc GetAppInfo
as
  set nocount on

        select 'Имя пользователя на SQL-серверах' as p , dbo.GetLogin() as i
  union select 'Алиас SQL-сервера', @@SERVERNAME  
  union select 'Имя базы данных', DB_NAME() 
  union select 'SPID', cast(@@SPID as varchar)
  union select 'Сотpудник', (Select top 1 Name from tUser (nolock) where UserID = dbo.GetUserID())


 exit_:
 return 0
go
grant exec on GetAppInfo to public
go


exec GetAppInfo

--select  *
--from sys.dm_db_index_usage_stats where database_id = db_id('Car');