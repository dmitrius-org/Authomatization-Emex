if OBJECT_ID('OrderFileFormatInsert') is not null
    drop proc OrderFileFormatInsert
/*
  OrderFileFormatInsert - добавление формата файла заказа
*/
go
create proc OrderFileFormatInsert
              @ID                  numeric(18,0) output -- 
             ,@ClientID            numeric(18,0) 
             ,@Folder              nvarchar(512) -- Папка	
             ,@Firstline           int           -- Первая строка	
             ,@Manufacturer        int           -- Столбец Производитель	
             ,@DetailNumber        int           -- Столбец Номер детали	
             ,@Quantity            int           -- Столбец Количество	
             ,@DetailID            int           -- Столбец ID	
             ,@DetailName          int           -- Столбец Наименование детали	
             ,@Price               int           -- Столбец Цена	
             ,@Amount              int           -- Столбец Сумма	
             ,@OrderNum            nvarchar(32)  -- Ячейка Заказ	
             ,@OrderDate           nvarchar(32)  -- Ячейка Дата Заказа	
             ,@PriceNum            nvarchar(32)  -- Прайс	
             ,@Commission          money         -- Комиссия
			 ,@CustomerSubID       varchar(32)   -- Правило формирование поля CustomerSubID
             ,@Reference           varchar(64)   -- Правило формирование поля Reference 
			 ,@IsActive            bit
             --

as
  declare @r int = 0

  DECLARE @tID TABLE (ID numeric(18,0));

  delete tRetMessage from tRetMessage (rowlock) where spid=@@spid

  insert into pOrderFileFormat
        (SPID
		,ClientID
        ,Folder      
        ,Firstline   
        ,Manufacturer
        ,DetailNumber  
        ,Quantity    
        ,DetailID          
        ,DetailName    
        ,Price       
        ,Amount      
        ,OrderNum    
        ,OrderDate   
        ,PriceNum    
        ,Commission  
		,CustomerSubID 
		,Reference   
		,IsActive
        )
  OUTPUT INSERTED.ID INTO @tID
  select @@SPID
        ,@ClientID         
        ,@Folder           
        ,@Firstline        
        ,@Manufacturer     
        ,@DetailNumber      
        ,@Quantity         
        ,@DetailID               
        ,@DetailName       
        ,@Price            
        ,@Amount           
        ,@OrderNum         
        ,@OrderDate        
        ,@PriceNum         
        ,@Commission  
		,@CustomerSubID 
		,@Reference 
		,@IsActive


  Select @ID = ID from @tID

exit_:
return @r
go
grant exec on OrderFileFormatInsert to public
go