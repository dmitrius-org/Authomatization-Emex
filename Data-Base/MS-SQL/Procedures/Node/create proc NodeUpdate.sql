drop proc if exists NodeUpdate
/*
  NodeUpdate - 
*/
go
create proc NodeUpdate
 @NodeID            numeric(18,0) 
--,@Brief             nvarchar(64)
,@Name              nvarchar(256)
,@Comment           nvarchar(512)= null
,@Flag              int          
,@ColorID           nvarchar(32) = null
,@Type              int
as
  declare @r       int = 0
         ,@Brief   nvarchar(64)

  select @Brief = Brief
    from tNodes (nolock)
   where NodeID = @NodeID

  if exists (select 1 
               from tNodes (nolock)
              where Brief   = @Brief
			    and Type    = @Type
				and NodeID <> @NodeID)
  begin
    set @r = case @Type
	          when 0 then 300 -- 'Состояние с заданным системным наименованием существует!'
			  when 1 then 302 -- 'Действие с заданным сокращением существует!'
	         end
    goto exit_
  end

  Update tNodes
     set
         -- Brief   = @Brief 
          Name    = @Name	
         ,Type    = @Type
	     ,Comment = @Comment
	     ,Flag    = @Flag
		 ,ColorID = @ColorID
         
  where NodeID = @NodeID

 exit_:
 return @r
go
grant exec on NodeUpdate to public
go
