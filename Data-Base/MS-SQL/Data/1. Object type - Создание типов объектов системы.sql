delete from tObjectType
/*
Flag  -- 1 - ������������ ������ ����������
      -- 2 - �������

*/
go
insert tObjectType (ObjectTypeID, Brief, Name)       select   1, '�����������',   '����������� ������������'
insert tObjectType (ObjectTypeID, Brief, Name)       select   2, '������������',  '������������' -- otUser
insert tObjectType (ObjectTypeID, Brief, Name, Flag) select   3, '������',        '������', 1
insert tObjectType (ObjectTypeID, Brief, Name, Flag) select   4, '����� �������', '����� �������', 0

insert tObjectType (ObjectTypeID, Brief, Name, Flag) select 101, 'TaskProc',      '��������� �������������� �������', 0

insert tObjectType (ObjectTypeID, Brief, Name, Flag) select   5, '����� �������� � �����������', '����� �������� � �����������', 0
