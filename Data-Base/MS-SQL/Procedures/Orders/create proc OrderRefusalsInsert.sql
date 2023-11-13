drop proc if exists TaskRefusals

drop proc if exists TaskRefusalsInsert



drop proc if exists OrderRefusalsInsert
/*
  TaskRefusals 

*/
go
create proc OrderRefusalsInsert
              @FileName nvarchar(128)
as
  set nocount on
  declare @r int

  if exists (select 1
               from tOrderRefusals (nolock)
              where FileName = @FileName
                and Flag&4=0
                and Flag&8=0) 
  begin
    select @r=525-- 'Данный файл уже в обработке!' 
    goto exit_
  end 


  --if isnull(@FileName, '') = ''
  --begin
  --    insert tTaskRefusals 
  --          (OrderID, 
  --           Flag)
  --    select m.ID, 
  --           1 -- объект
  --      from tMarks m (nolock)
  --     inner join tOrders o (nolock)
  --             on o.OrderID          = m.ID
  --            and o.isCancelToClient = 0 
  --     where m.Spid = @@SPID
  --       and m.Type = 3
  --       and not exists (select 1
  --                         from tTaskRefusals t (nolock)
  --                        where t.OrderID = m.ID
  --                          and t.Flag&4  = 0 )
  --end
  --else
  --begin
      insert tOrderRefusals (FileName, Flag)
      select @FileName, 
             2 -- файл
       where not exists (select 1
                           from tOrderRefusals t (nolock)
                          where t.FileName = @FileName
                            and t.Flag&4   = 0 )
  --end
     

 exit_:
 return @r
go
grant exec on OrderRefusalsInsert to public
go


--exec TaskRefusals

--select  *
--from sys.dm_db_index_usage_stats where database_id = db_id('Car');