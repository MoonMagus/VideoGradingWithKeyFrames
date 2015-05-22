function  PlayLeftVideoData(AxesHandle, playHandle, handles, VideoName)
% ����ͬ����������.
global movLeft;
global leftLastVideoName;
global ShowResulting;

%���������Ƶ��ǩ.
% if(ishandle(AxesHandle) == 1)
%     LeftFrameRunning = 1;
% end

%��ȡ��Ƶ�����ݽṹ.
if(ShowResulting == 0)
    VideoMedia = VideoReader(strcat('Video\StartVideo\',VideoName));
else
    VideoMedia = VideoReader(strcat('Video\ResultVideo\TotalVideos\',VideoName));
end
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;
Position = get(AxesHandle,'Position');
AxesWidth = floor(Position(3));
AxesHeight = floor(Position(4));

% Ԥ���Video���ݽṹ.
mov(1:nFrames) = ...
struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'),'colormap', []);

% ����֡����.
h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
h2 = floor(AxesWidth * videoHeight / videoWidth);


% if (leftOver == 1)
%     return;
% end
% ����֡����.
if(strcmp(leftLastVideoName, VideoName) == 0)
    matName = strcat('VideoData\', VideoName(1:end - 4),'.mat');
    fid = fopen(matName);
    if(fid ~= -1)
        mov = load(matName);
        movLeft = mov.mov;
        fclose('all');
    else
        for i = 1 : nFrames
            P = read(VideoMedia, i);
            mov(i).cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
        end
        save(matName,'mov');
        movLeft = mov;
    end
    leftLastVideoName = VideoName;
end


% ��ԭʼ��Ƶ��֡�ʽ���һ�λط�.
% LeftWaitBarControl(0,'',handles.LeftVideoProgress, handles.VideoGrading);
% for i = 1 : nFrames
%     if(ishandle(AxesHandle) == 1)
%         if (leftOver == 1)
%             return;
%         end
%         axes(AxesHandle);
%     else
%         return;
%     end
%     if(ishandle(AxesHandle) == 1)
%         if (leftOver == 1)
%             return;
%         end
%         imshow(mov(i).cdata);
%     else
%         return;
%     end
%     LeftWaitBarControl(i/nFrames, [num2str(floor(i*100/nFrames)),'%'],handles.LeftVideoProgress, handles.VideoGrading);
% end
% TaskTimer = timer;
% TaskTimer.TimerFcn = {@PlayVideoFun, mov};
% TaskTimer.ExecutionMode = 'fixedRate';
% TaskTimer.TasksToExecute = nFrames;
% TaskTimer.Period = 0.001;
% axes(AxesHandle);
% start(TaskTimer);
% delete(TaskTimer);
% 
% function PlayVideoFun(hObject, enentData, mov)
%      pause(0.001);
%     n = hObject.TasksExecuted;
%     imshow(mov(n).cdata);

movie(AxesHandle, movLeft, 1, 30);
if(ishandle(AxesHandle) ==  1)
    axes(AxesHandle);
    imshow(movLeft(nFrames).cdata);
end


% ��Ƶ�������Ž���ʱ����ͬ������.
% if(ishandle(playHandle) == 1)
%     set(playHandle,'string','>>')
% end
% leftOver = 0;
% LeftFrameRunning = 0;







 
    
