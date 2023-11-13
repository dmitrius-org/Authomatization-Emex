drop proc if exists NodeDelete
/*
  NodeDelete - 
*/
go
create proc NodeDelete
              @NodeID            numeric(18,0) 
as
  declare @r       int = 0
		 ,@Type    int

  select @Type  = Type
    from tNodes (nolock)
   where NodeID = @NodeID

  if exists (select 1 
                  from tModel i (nolock)
                 where @NodeID in (i.StateID, i.ActionID)
			   )
  begin
    set @r = case @Type
	          when 0 then 332 -- 'Статус с заданным сокращением используется в модели состояния!'
			  when 1 then 333 -- 'Действие с заданным сокращением используется в модели состояния!'
	         end
    goto exit_
  end

  if @Type = 0
    and exists (select 1 
                  from tOrders o (nolock)
                 where o.StatusID  = @NodeID
			   )
  begin
    set @r = 331-- 'Статус с заданным сокращением используется в таблице заказов!'
    goto exit_
  end

  delete tNodes
    from tNodes (rowlock)       
   where NodeID = @NodeID

 exit_:
 return @r
go
grant exec on NodeDelete to public
go
