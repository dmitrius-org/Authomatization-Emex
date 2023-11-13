drop proc if exists TaskInsert
/*
  TaskInsert - 
*/
go
create proc TaskInsert
               @TaskID           numeric(18,0)  out 
              ,@Brief            nvarchar(60)       --
              ,@Name	         nvarchar(128) null  -- 
              ,@TaskType         int  -- тип задачи
              ,@PeriodType       int
              ,@DateBegin        datetime
              ,@IsActive         int
			  ,@Field            nvarchar(max)
			  ,@LinkID           numeric(18,0)
			  ,@TimeBegin        Time
              ,@TimeEnd          Time
              ,@DayPeriod        int
              ,@TimePeriod       Time
as
  declare @r       int = 0
		 ,@Type    int

  DECLARE @ID TABLE (ID numeric(18,0));

  INSERT INTO [tTask]
        ([Brief]
        ,[Name]
        ,[TaskType]
        ,[PeriodType]
       -- ,[TimeType]
        ,[DateBegin]
        ,[IsActive]
		,Field
		,LinkID
        ,[inDatetime]
        ,[updDatetime]
		,TimeBegin        
        ,TimeEnd          
        ,DayPeriod        
        ,TimePeriod       
		)
  OUTPUT INSERTED.TaskID  INTO @ID
  select @Brief       
		,@Name	    
		,@TaskType    
		,@PeriodType  
		--,@TimeType    
		,@DateBegin   
		,@IsActive  
		,@Field
		,@LinkID
		,getDate() 
		,getDate() 
		,@TimeBegin        
        ,@TimeEnd          
        ,@DayPeriod        
        ,@TimePeriod  

  Select @TaskID = ID from @ID

 exit_:
 return @r
go
grant exec on TaskInsert to public
go
