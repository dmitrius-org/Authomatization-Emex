if OBJECT_ID('OrderFileFormatUpdate') is not null
    drop proc OrderFileFormatUpdate
/*
  OrderFileFormatUpdate - Обновление/изменение формата файла заказа
*/
go
create proc OrderFileFormatUpdate
              --@OrderFileFormatID   numeric(18,0) -- 
              --@ClientID            numeric(18,0) 
              @Folder              nvarchar(512) --Папка	
             ,@Firstline           int           --Первая строка	
             ,@Manufacturer        int           --Столбец Производитель	
             ,@DetailNumber        int           --Столбец Номер детали	
             ,@Quantity            int           --Столбец Количество	
             ,@DetailID            int           --Столбец ID	
             ,@DetailName          int           --Столбец Наименование детали	
             ,@Price               int           --Столбец Цена	
             ,@Amount              int           --Столбец Сумма	
             ,@OrderNum            nvarchar(32)  --Ячейка Заказ	
             ,@OrderDate           nvarchar(32)  --Ячейка Дата Заказа	
             ,@PriceNum            nvarchar(32)  --Прайс	
             ,@Commission          money         --Комиссия
			 ,@CustomerSubID       varchar(32)   -- Правило формирование поля CustomerSubID
             ,@Reference           varchar(64)   -- Правило формирование поля Reference
			 ,@IsActive            bit
			 ,@ID                  numeric(18,0)   
             --

as
  declare @r int = 0
  --if exists (select 1 
  --             from tOrderFileFormat u (nolock)
  --            where u.ClientID = @ClientID)
  --begin
  --  set @r = 0
  --  goto exit_
  --end

  delete tRetMessage from tRetMessage (rowlock) where spid=@@spid

  Update pOrderFileFormat
     set Folder        = @Folder      
        ,Firstline     = @Firstline   
        ,Manufacturer  = @Manufacturer
        ,DetailNumber  = @DetailNumber 
        ,Quantity      = @Quantity    
        ,DetailID      = @DetailID         
        ,DetailName    = @DetailName   
        ,Price         = @Price       
        ,Amount        = @Amount      
        ,OrderNum      = @OrderNum    
        ,OrderDate     = @OrderDate   
        ,PriceNum      = @PriceNum    
        ,Commission    = @Commission  
		,CustomerSubID = @CustomerSubID 
		,Reference     = @Reference 
		,IsActive      = @IsActive
    from pOrderFileFormat (updlock)
   where ID = @ID

exit_:
return @r
go
grant exec on OrderFileFormatUpdate to public
go