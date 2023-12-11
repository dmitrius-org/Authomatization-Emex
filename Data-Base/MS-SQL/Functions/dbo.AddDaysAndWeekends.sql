
if OBJECT_ID('AddDaysAndWeekends') is not null
    drop function AddDaysAndWeekends
--/*
--  AddDaysAndWeekends - Функция SQL Server для добавления рабочих дней к дате
--*/
go
create FUNCTION dbo.AddDaysAndWeekends
(
    @StartDate         DATETIME,
    @NoOfDays          INT,
    @IsSatrudayHoliday bit
)

RETURNS DATETIME AS BEGIN
    while (@NoOfDays>0)
    begin
        --add 1 day
        set @StartDate = DateAdd(day,1,@StartDate)

        --skip weekends
        while (@IsSatrudayHoliday = 1 and DATEPART(dw, @StartDate) in (6, 7))
        begin
            set @StartDate = DateAdd(day, 1, @StartDate)
        end

        set @NoOfDays = @NoOfDays-1
    end

    RETURN @StartDate
END
go
grant exec on dbo.AddDaysAndWeekends to public
go
SET DATEFIRST 1 ;  
select dbo.AddDaysAndWeekends('20231130', 2, 1)


