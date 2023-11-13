if OBJECT_ID('UploadingRefusals') is not null
    drop proc UploadingRefusals
/*
  UploadingRefusals - 
*/
--go
--create proc UploadingRefusals
--              @Spid int = null
--as
--  declare @r int = 0

--  Update o
--     set o.isCancelToClient = 1
--    from tMarks m (nolock)
--   inner join tOrders o (updlock)
--           on o.OrderID = m.ID
--   where m.Spid = isnull(@Spid, @@Spid)
--     and m.Type = 3

  
-- exit_:
-- return @r
--go
--grant exec on UploadingRefusals to public
--go