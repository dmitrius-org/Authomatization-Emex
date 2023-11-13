if OBJECT_ID('OrdersReferenceCalc') is not null
    drop proc OrdersReferenceCalc
/*
  OrdersReferenceCalc - 
*/
go
create proc OrdersReferenceCalc
as
   declare @r int = 0
          ,@s varchar(max)


  set @s = isnull((   Select STRING_AGG('Update tOrders ' +
	                                    '    set Reference = ' + isnull(c.Reference, '') +
							            '  from tOrders (Updlock)   ' +
								        '  where isnull(Reference, '''') = ''''  '+
								        '    and ClientID = ' + convert(varchar(20), c.ClientID), ';')
					    from tOrderFileFormat c (nolock)
					   where isnull(c.Reference, '') <> ''), '')
		

  exec( @s )

  set @s = isnull((   Select STRING_AGG('Update tOrders 
	                                        set CustomerSubID = ' + isnull(c.CustomerSubID, '') +
							            '  from tOrders  (updlock) 
								          where isnull(CustomerSubID, '''') = '''' 
								            and ClientID = ' + convert(varchar(20), c.ClientID), ';' )
					    from tOrderFileFormat c (nolock)
					   where isnull(c.CustomerSubID, '') <> ''), '')
  exec( @s )
	
 exit_:
 return @r
go
grant exec on OrdersReferenceCalc to public
go
 
 --exec OrdersReferenceCalc