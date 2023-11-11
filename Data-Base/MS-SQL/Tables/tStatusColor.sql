if OBJECT_ID('tStatusColor') is not null
  drop table tStatusColor
go
/* **********************************************************
tStatusColor - Статусы
********************************************************** */
create table tStatusColor
(
 StatusColorID     nvarchar(32)  not null --  
,Brief             nvarchar(7)   not null --
,Name              nvarchar(60)  not null --  
)
go
create unique index ao1 on tStatusColor(StatusColorID)
go
create unique index ao2 on tStatusColor(Brief)
go
grant all on tStatusColor to public
go
insert tStatusColor (StatusColorID, Brief, Name) Select 'clBlack',      '$000000', 'Black'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clMaroon',     '$000080', 'Maroon'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clGreen',      '$008000', 'Green'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clOlive',      '$008080', 'Olive'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clNavy',       '$800000', 'Navy Blue'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clPurple',     '$800080', 'Purple'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clTeal',       '$808000', 'Teal'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clGray',       '$808080', 'Gray'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clSilver',     '$C0C0C0', 'Silver'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clRed',        '$0000FF', 'Red'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clLime',       '$00FF00', 'Lime Green'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clYellow',     '$00FFFF', 'Yellow'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clBlue',       '$FF0000', 'Blue'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clFuchsia',    '$FF00FF', 'Fuchsia'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clAqua',       '$FFFF00', 'Aqua'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clWhite',      '$FFFFFF', 'White'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clMoneyGreen', '$C0DCC0', 'Mint Green'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clSkyBlue',    '$F0CAA6', 'Sky Blue'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clCream',      '$F0FBFF', 'Cream'
insert tStatusColor (StatusColorID, Brief, Name) Select 'clMedGray',    '$A4A0A0', 'Medium Gray'

select * from tStatusColor