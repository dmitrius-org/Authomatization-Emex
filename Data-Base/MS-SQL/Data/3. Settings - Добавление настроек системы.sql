--delete tInstrument
--delete tSettings
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  0, 'State',    '������ ���������',  1
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  0, 'Settings', '��������� �������', 2

Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  2, 'emexdwc', '��������� ���������� � emexdwc', 4--, 'TSettingsT'
--insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select 3, 'emexdwc_username', '������������ ��� ����������', '', 'QXXX', 0
--insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select 3, 'emexdwc_password', '������ ��� ����������', '', 'qXQx', 0

insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select 3, 'CoeffMaxAgree', '������������ ����������� ���������� ���� ������� ��� ������� ��� �����', '������������ ����������� ���������� ���� ������� ��� ������� ��� �����, ���������� �� ����� (�� ��������� 1.1)', '1.1', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select 3, 'AutomaticRejectionPartsByCreatOrder', '�������������� ����� ������� � �������� ��� �������� ������', '', '1', 0

Insert tInstrument ( PID, Brief, Name, InstrumentTypeID, ObjectTypeID) Select  1, '������',    '������',  5, 3


Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  2, 'Orders', '������', 4--, 'TSettingsT'
go
declare @ID numeric(18, 0)
select @ID = InstrumentID from tInstrument where brief = 'Orders'
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'OrdersGridRowCount', '���������� ����� �� �������� ������� �������', '', '500', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'TemplateOrderRefusals', '������ Excel ��� �������� �������', '', '', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'UploadingRefusalsCatalog', '����� ��� ���������� ������ �������', '', '', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'UploadingRefusalsScript', '������ ��� �������� �������', '', '', 0
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'EmexdwcClient', '������ ��� ����������', '', '3', 0





go
declare @PID numeric(18, 0)
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  0, 'SettingsClientApp', '��������� ��� ����������� ����������', 2

select @PID = InstrumentID from tInstrument where brief = 'SettingsClientApp'
Insert tInstrument ( PID, Brief, Name, InstrumentTypeID) Select  @PID, 'ClientAppCommon', '����� ���������', 4--, 'TSettingsT'

declare @ID numeric(18, 0)
select @ID = InstrumentID from tInstrument where brief = 'ClientAppCommon'
insert tSettings (GroupID, Brief, Name, Comment, Val, SettingType) select @ID, 'DefaultSuppliers', '��������� �� ���������', '�������� ������� ��������� ������������� � �������� ������� ��� ����������� �� �����', '', 0












/*

delete
  from tSettings 
 where brief in ('DefaultSuppliers')

delete
  from tSettings 
 where brief in ('UploadingRefusalsScript')
*/


select *
  from tInstrument (nolock)
select *
  from tSettings (nolock)
  where brief = 'OrdersGridRowCount'

--delete
--  from tSettings 
--  where brief = 'OrdersGridRowCount'



