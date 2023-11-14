if OBJECT_ID('GetCurrencyRate', 'FN') is not null
    DROP FUNCTION GetCurrencyRate
go

/* --------------------------------------------------------
  GetCurrencyRate - получение курса валюты
  @NumCode - цифровой код валюты
  @OnDate  - дата
-------------------------------------------------------- */
CREATE FUNCTION GetCurrencyRate
                (@NumCode varchar(3)
				,@OnDate  date = null )
RETURNS decimal(19, 4)
WITH EXECUTE AS CALLER
BEGIN

  select @OnDate = isnull(@OnDate, cast(getdate() as date))

  return (select top 1 Value
            from tCurrencyRate with (nolock index=ao2)
           where NumCode = '840'
  		     and OnDate <= @OnDate
  		   order by OnDate desc)
end   
go
grant execute on dbo.GetCurrencyRate to public