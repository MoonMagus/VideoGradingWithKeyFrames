function PausePlay(playHandle, figureHandle)
% �ú�������ʵ�ֲ��Ű�ť����ͣ��ť�������ԭ��ͬ������.
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
