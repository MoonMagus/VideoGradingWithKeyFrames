function  PlayLeftVideoData(AxesHandle, playHandle, handles, VideoName)
% 设置同步操作变量.
global movLeft;
global leftLastVideoName;
global ShowResulting;

%获得左右视频标签.
% if(ishandle(AxesHandle) == 1)
%     LeftFrameRunning = 1;
% end

%获取视频的数据结构.
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

% 预填充Video数据结构.
mov(1:nFrames) = ...
struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'),'colormap', []);

% 载入帧数据.
h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
h2 = floor(AxesWidth * videoHeight / videoWidth);


% if (leftOver == 1)
%     return;
% end
% 缓冲帧数据.
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


% 以原始视频的帧率进行一次回放.
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


% 视频完整播放结束时设置同步变量.
% if(ishandle(playHandle) == 1)
%     set(playHandle,'string','>>')
% end
% leftOver = 0;
% LeftFrameRunning = 0;







 
    
