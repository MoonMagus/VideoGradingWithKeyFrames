function RightWaitBarControl(x, message, AxesHandle, FigureHandle)
global rightOver;
if(ishandle(AxesHandle) == 1)
    axes(AxesHandle);
else
    return;
end
% TitleHandle = get(AxesHandle,'title');
% set(TitleHandle,'String',message);
if (rightOver == 1)
    return;
end
x = max(0,min(100*x,100));
if  x == 0    
    if (rightOver == 1)
        return;
    end
    cla
    % 绘制进度条框.
    xline = [100 0 0 100 100];
    yline = [0 0 1 1 0];
    line(xline,yline,'EraseMode','none');  
    %填充进度条框.
    xpatch = [0 x x 0];
    ypatch = [0 0 1 1];
    patch(xpatch,ypatch,'b','EdgeColor','k','EraseMode','none','Tag', 'RightPatch');
else
    if (rightOver == 1)
        return;
    end
    if(ishandle(AxesHandle) == 1)
         p = findobj(FigureHandle,'Tag','RightPatch');
        xpatch = [0 x x 0];
        set(p,'XData',xpatch);
    else
        return;
    end
end