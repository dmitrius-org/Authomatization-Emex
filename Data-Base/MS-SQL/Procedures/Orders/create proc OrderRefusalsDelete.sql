drop proc if exists OrderRefusalsDelete
/*
  OrderRefusalsDelete 

*/
go
create proc OrderRefusalsDelete
              @OrderRefusalsID numeric(18, 0)
             ,@IsCancel        bit
as
  set nocount on
  declare @r int

  BEGIN TRY 
      delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
      Begin tran

      --delete ot 
      --  from tOrderRefusals  t (nolock)
      -- inner join tOrderRefusalsDetail ot (rowlock)
      --         on ot.OrderRefusalsID = t.OrderRefusalsID
      -- where t.OrderRefusalsID = @OrderRefusalsID
      Update tOrderRefusals 
         set Flag = Flag|8 -- Удален
        from tOrderRefusals (rowlock) 
       where OrderRefusalsID = @OrderRefusalsID

      --delete tOrderRefusals from tOrderRefusals (rowlock) where OrderRefusalsID = @OrderRefusalsID

      if @IsCancel = 1
      begin
        Update o
           set o.isCancelToClient = 1
          from pEmexRefusalsConfirm p (nolock)
         inner join tOrders o (updlock) 
                 on o.OrderID  = p.OrderID
                and o.isCancel = 1
         where p.Spid = @@spid
      end
	
		--if @r <> 0
		--begin 
		--  RAISERROR (15600, 16, 1, @r);
		--end

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
 return 0
go
grant exec on OrderRefusalsInsert to public
go


--exec TaskRefusals

--select  *
--from sys.dm_db_index_usage_stats where database_id = db_id('Car');