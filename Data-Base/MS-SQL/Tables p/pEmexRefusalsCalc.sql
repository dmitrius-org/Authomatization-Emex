drop table if exists pEmexRefusalsCalc
go
/* **********************************************************
pEmexRefusalsCalc - таблица отказы
********************************************************** */
create table pEmexRefusalsCalc
(
 Spid             numeric(18,0) 
,OrderID          numeric(18,0)  
,isCancel         bit
,isCancelToClient bit
,Quantity         int
,Flag             int
)
go
create unique index ao1 on pEmexRefusalsCalc(Spid, OrderID)
go
grant all on pEmexRefusalsCalc to public
go
exec dbo.sys_setTableDescription @table = 'pEmexRefusalsCalc', @desc = 'Таблица отказы'
go


drop table if exists pEmexRefusalsConfirm
go
/* **********************************************************
pEmexRefusalsConfirm - таблица отказы
********************************************************** */
create table pEmexRefusalsConfirm
(
 Spid      numeric(18,0) 
,OrderID   numeric(18,0)  
)
go
create unique index ao1 on pEmexRefusalsConfirm(Spid, OrderID)
go
grant all on pEmexRefusalsConfirm to public
go
exec dbo.sys_setTableDescription @table = 'pEmexRefusalsCalc', @desc = 'Таблица отказы'
go






