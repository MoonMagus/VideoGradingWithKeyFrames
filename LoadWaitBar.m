clear;
isCanceled = false;
hWaitbar = waitbar(0.9,'请等待...',...
                   'Name','这是名字',...
                   'CreateCancelBtn','isCanceled = true;');
btnCancel = findall(hWaitbar,'style','pushbutton');
set(btnCancel,'string','取消','fontsize',10); 
h = findall(hWaitbar,'type','patch');
set(h,'EdgeColor','k','facecolor','b');
for i = 1:100
    waitbar(i/100, hWaitbar, ['进度完成',num2str(i),'%']);
    pause(0.1);
    if isCanceled
       break;
    end
end

if ishandle(hWaitbar)
   delete(hWaitbar);
   clear hWaitbar;
end