function PausePlay(playHandle, figureHandle)
global over;
if(over == 1)
    uiresume(figureHandle);
    set(playHandle,'string','>>')
else
    if(ishandle(playHandle) == 1)
        if strcmp(get(playHandle,'string'),'| |')
            set(playHandle,'string','>>')
            uiwait(figureHandle);
        else
            set(playHandle,'string','| |')
            uiresume(figureHandle);
        end
    end
end