clear;
isCanceled = false;
hWaitbar = waitbar(0.9,'��ȴ�...',...
                   'Name','��������',...
                   'CreateCancelBtn','isCanceled = true;');
btnCancel = findall(hWaitbar,'style','pushbutton');
set(btnCancel,'string','ȡ��','fontsize',10); 
h = findall(hWaitbar,'type','patch');
set(h,'EdgeColor','k','facecolor','b');
for i = 1:100
    waitbar(i/100, hWaitbar, ['�������',num2str(i),'%']);
    pause(0.1);
    if isCanceled
       break;
    end
end

if ishandle(hWaitbar)
   delete(hWaitbar);
   clear hWaitbar;
end