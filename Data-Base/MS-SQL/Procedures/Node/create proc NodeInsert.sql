drop proc if exists NodeInsert
/*
  NodeInsert - 
*/
go
create proc NodeInsert
 @NodeID            numeric(18,0) out
,@Brief             nvarchar(64)
,@Name              nvarchar(256)
,@Comment           nvarchar(512)= null
,@Flag              int          
,@ColorID           nvarchar(32) = null
,@Type              int
as
  declare @r int = 0

  if exists (select 1 
               from tNodes (nolock)
              where Brief = @Brief
			    and Type  = @Type)
  begin
    set @r = case @Type
	          when 0 then 300 -- 'Состояние с заданным системным наименованием существует!'
			  when 1 then 302 -- 'Действие с заданным сокращением существует!'
	         end
    goto exit_
  end

  declare @ID as table (ID numeric(18, 0))
  insert into tNodes
         (
          Brief
         ,Name
         ,Type
	     ,Comment
	     ,Flag
		 ,ColorID
         )
  OUTPUT INSERTED.NodeID INTO @ID
  select @Brief     
        ,@Name	     
        ,@Type	 
		,@Comment
		,@Flag
		,@ColorID


   Select @NodeID = ID from @ID

 exit_:
 return @r
go
grant exec on NodeInsert to public
go
