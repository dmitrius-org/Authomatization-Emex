if OBJECT_ID('OrderFileFormatDeleteP') is not null
    drop proc OrderFileFormatDeleteP
/*
  OrderFileFormatDeleteP - Удаление формата файла заказа из временной таблицы
*/
go
create proc OrderFileFormatDeleteP
              @ID            numeric(18,0) 
--
as
  declare @r int = 0

  delete pOrderFileFormat from pOrderFileFormat (rowlock) where ID = @ID   

exit_:
return @r
go
grant exec on OrderFileFormatDeleteP to public
go