drop proc if exists GrantSave
/* **********************************************************
  GrantSave - сохранение прав пользователя/группы

  @ObjectID   -- ид объекта
  @ObjectType -- тп объекта
              -- 0 - пользователь
              -- 1 - группа

  на вход подается таблица pGrant
********************************************************** */
go
create proc GrantSave
              @ObjectID          numeric(18,0)  
             ,@ObjectType        int
as
  set nocount on

  declare @r int = 0
  
  delete t
    from tGrant t (rowlock)
   inner join pGrant p (nolock)
           on p.Spid     = @@spid
          and p.ObjectID = t.ObjectID
          and p.Value    = 0
   where t.ObjectType = @ObjectType
     and t.ObjectID   = @ObjectID

  -- сохранение прав на интерфейс
  insert tGrant
        (
         ObjectID
        ,MenuID  
        ,ObjectType
        )
  select p.ObjectID
        ,p.MenuID   
        ,@ObjectType
    from pGrant p with (nolock index=ao1)
   where p.Spid       = @@spid
     and p.ObjectID   = @ObjectID
     and p.Value      = 1
     and not exists (select 1
                       from tGrant g with (nolock index=ao1)
                      where g.ObjectType = @ObjectType
                        and g.ObjectID   = @ObjectID
                        and g.MenuID     = p.MenuID
                     )


  -- сохранение прав на объекты учета
  delete tGrantObject 
    from tGrantObject (rowlock)
   where ObjectID   = @ObjectID
     and ObjectType = @ObjectType

  insert tGrantObject
        (
         ObjectID
        ,ObjectType
        ,LinkID
        ,LinkType
        )
  select p.ObjectID
        ,p.ObjectType
        ,p.LinkID
        ,p.LinkType
    from pGrantObject p (nolock)
   where p.Spid=@@SPID

  delete p
    from pGrantObject p (rowlock)
   where p.Spid=@@SPID

 exit_:
 return @r

grant exec on GrantSave to public
go
