function  ClearListBox(listHandle)
% 清空指定的listbox.
str = '';
set(listHandle,'string', str);
set(listHandle,'Value',0);
