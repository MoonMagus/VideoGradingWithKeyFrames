function PausePlay(playHandle, figureHandle)
% 该函数用于实现播放按钮和暂停按钮，添加了原子同步操作.
global leftOver;
global LeftFrameRunning;
global rightOver;
global RightFrameRunning;
if(ishandle(playHandle) == 1)
    PlayButtonTag = get(playHandle, 'Tag');
    if(strcmp(PlayButtonTag,'LeftPlay') == 1)
        if(leftOver == 1)
            uiresume(figureHandle);
            set(playHandle,'string','>>')
        else
            if(ishandle(playHandle) == 1)
                if(LeftFrameRunning == 1)
                    if strcmp(get(playHandle,'string'),'| |')
                        set(playHandle,'string','>>')
                        uiwait(figureHandle);
                    else
                        set(playHandle,'string','| |')
                        uiresume(figureHandle);
                    end
                else
                    set(playHandle,'string','>>')
                    uiwait(figureHandle);
                end
            end
        end
    else
        if(rightOver == 1)
            uiresume(figureHandle);
            set(playHandle,'string','>>')
        else
            if(ishandle(playHandle) == 1)
                if(RightFrameRunning == 1)
                    if strcmp(get(playHandle,'string'),'| |')
                        set(playHandle,'string','>>')
                        uiwait(figureHandle);
                    else
                        set(playHandle,'string','| |')
                        uiresume(figureHandle);
                    end
                else
                    set(playHandle,'string','>>')
                    uiwait(figureHandle);
                end
            end
        end
    end
end
