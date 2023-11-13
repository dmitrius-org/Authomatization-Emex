drop proc if exists TaskUpdate
/*
  TaskUpdate - 
*/
go
create proc TaskUpdate
               @TaskID           numeric(18,0) 
              ,@Brief            nvarchar(60)   --
              ,@Name	         nvarchar(128)   -- 
              ,@TaskType         int   -- тип задачи
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

  update [tTask]
     set [Brief]	   = @Brief
        ,[Name]		   = @Name
        ,[TaskType]	   = @TaskType
        ,[PeriodType]  = @PeriodType
        ,[DateBegin]   = @DateBegin
        ,[IsActive]	   = @IsActive
        ,Field         = @Field
        ,[updDatetime] = getDate()
		,LinkID        = @LinkID
		,TimeBegin 	   = @TimeBegin        
        ,TimeEnd       = @TimeEnd          
        ,DayPeriod     = @DayPeriod        
        ,TimePeriod    = @TimePeriod       
   where TaskID = @TaskID

 exit_:
 return @r
go
grant exec on TaskUpdate to public
go
