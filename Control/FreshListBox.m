function FreshListBox(newstr, listHandle)
%使用新的信息更新ListBox显示列表.

str = get(listHandle,'string');
str{end+1} = newstr;
[l,~] = size(str);
set(listHandle,'Value',l);
set(listHandle, 'string', str);
