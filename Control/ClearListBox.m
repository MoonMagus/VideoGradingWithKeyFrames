function  ClearListBox(listHandle)
% ���ָ����listbox.
str = '';
set(listHandle,'string', str);
set(listHandle,'Value',0);
