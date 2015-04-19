function StatusWaitBarControl(x,  AxesHandle, FigureHandle)
axes(AxesHandle);

x = max(0,min(100*x,100));
if  x == 0    
    cla
    % 绘制进度条框.
    xline = [100 0 0 100 100];
    yline = [0 0 1 1 0];
    line(xline,yline,'EraseMode','none');  
    %填充进度条框.
    xpatch = [0 x x 0];
    ypatch = [0 0 1 1];
    patch(xpatch,ypatch,'b','EdgeColor','k','EraseMode','none','Tag','StatusPatch');
else
    p = findobj(FigureHandle,'Tag','StatusPatch');
    xpatch = [0 x x 0];
    set(p,'XData',xpatch);
end