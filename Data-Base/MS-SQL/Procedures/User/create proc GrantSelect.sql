drop proc if exists GrantSelect
/*
  GrantSelect - права пользователя или группы
  @ObjectID   -- ид объекта
  @ObjectType -- тп объекта
              -- 0 - пользователь
              -- 1 - группа
  результат возвращается pGrant
*/
go
create proc GrantSelect
              @ObjectID          numeric(18,0)
             ,@ObjectType        int
as
  set nocount on

  declare @r int = 0

  -- Права на интерфейс
  Delete pGrant from pGrant (rowlock) where spid = @@spid

  insert pGrant
        (Spid              
        ,GrantID           
        ,ObjectID            
        ,MenuID         
        ,ParentID
        ,N
        ,Caption	           
        ,Value
        ,Type
        )
  select @@Spid
        ,g.GrantID
        ,@ObjectID
        ,m.MenuID
        ,m.ParentID
        ,m.N
        ,m.Caption
        ,cast((case 
                when g.MenuID is not null then 1
                else 0
               end) as bit) Value
        ,m.Type
    from tMenu m (nolock)
    left join tGrant g (nolock)
           on g.ObjectType = @ObjectType 
          and g.ObjectID   = @ObjectID
          and g.MenuID     = m.MenuID
   order by m.n

  if @ObjectType = 0 
    Update p
       set /*p.Value = isnull(cast((case 
                                     when g.MenuID is not null then 1
                                     else 0
                                  end) as bit), p.Value)
         ,*/
          p.IsGroup = case 
                        when g.MenuID is not null then 1
                        else 0
                      end
         ,p.Groups = g.Groups
     from pGrant p
     cross apply ( select top 1 m.MenuID,
                          STRING_AGG(gr.Brief, ', ') Groups 
                     from tUserReliation ur (nolock)
                    inner join tGroups gr (nolock)
                            on gr.GroupID = ur.GroupID     
                    inner join tGrant g (nolock)
                            on g.ObjectType = 1 -- группа
                           and g.ObjectID   = gr.GroupID
                          -- 
                    inner join tMenu m (nolock)
                            on m.MenuID = g.MenuID 
                           and m.MenuID = p.MenuID
                     where ur.LinkType = 2
                       and ur.UserID   = @ObjectID
                    group by m.MenuID
                 ) as g 
     where p.Spid = @@Spid


  -- права на объекты учета
  delete p
    from pGrantObject p (rowlock)
   where p.Spid=@@SPID

  insert pGrantObject
        (Spid
        ,GrantObjectID
        ,ObjectID
        ,ObjectType
        ,LinkID
        ,LinkType
        )
  select @@Spid
        ,t.GrantObjectID
        ,t.ObjectID
        ,t.ObjectType
        ,t.LinkID
        ,t.LinkType
    from tGrantObject t (nolock)
   where t.ObjectID   = @ObjectID
     and t.ObjectType = @ObjectType


 exit_:
 return @r
go
grant exec on GrantSelect to public
go
