if OBJECT_ID('tDelimiter') is null
--drop table tDelimiter
/* **********************************************************
tDelimiter - 
********************************************************** */
create table tDelimiter
(
 DelimiterID  int  identity --
,Brief        varchar(10)  
,Name         varchar(60)   --
)
go
create unique index ao1 on tDelimiter(DelimiterID)
go
grant all on tDelimiter to public
go
insert tDelimiter (Brief, Name) select ';', 'Разделитель точка запятая' 
insert tDelimiter (Brief, Name) select char(9), 'Разделитель табуляция' 




