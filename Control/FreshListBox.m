function FreshListBox(newstr, listHandle)
%ʹ���µ���Ϣ����ListBox��ʾ�б�.

str = get(listHandle,'string');
str{end+1} = newstr;
[l,~] = size(str);
set(listHandle,'Value',l);
set(listHandle, 'string', str);
