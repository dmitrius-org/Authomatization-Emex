if OBJECT_ID('ClientDelete') is not null
    drop proc ClientDelete
/*
  ClientDelete - удаление клиента
*/
go
create proc ClientDelete
              @ClientID          numeric(18,0)  --  
as
  declare @r int = 0

  --DECLARE @ID TABLE (ID numeric(18,0));

  if exists (select 1 
               from tOrders o (nolock)
              where o.ClientID  = @ClientID
             )
  begin
    set @r = 101-- 'Удаление запрещено, Клиент используется в таблице заказов!'
    goto exit_
  end 

  BEGIN TRY 
      delete tRetMessage from tRetMessage (rowlock) where spid=@@spid
      Begin tran
 
 		exec @r = OrderFileFormatDelete 
                    @ClientID = @ClientID

        if @r = 0
          exec @r=ClientReliationDelete
                    @ClientID  = @ClientID 
		
		if @r <> 0
		begin 
		  RAISERROR (15600, 16, 1, @r);
		end

		Delete tClients
			from tClients with (rowlock index=ao1)
		   where ClientID  = @ClientID

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

grant exec on ClientDelete to public
go
 