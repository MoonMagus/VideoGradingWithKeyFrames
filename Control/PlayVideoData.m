function  PlayVideoData(AxesHandle, playHandle, handles, VideoName)
%获取视频的数据结构.
global curFrame;
curFrame = 1;
global over;
over = 0;
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;
Position = get(AxesHandle,'Position');
AxesWidth = floor(Position(3));
AxesHeight = floor(Position(4));

% 预填充Video数据结构.
mov(1:nFrames) = ...
struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));


% 载入帧数据.
h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
h2 = floor(AxesWidth * videoHeight / videoWidth);

global leftClose;
if (leftClose == 1)
    return;
end
% 缓冲真数据.
matName = strcat('VideoData\', VideoName(1:end - 4),'.mat');
fid = fopen(matName);
if(fid ~= -1)
    mov = load(matName);
    mov = mov.mov;
    fclose('all');
else
    for i = 1 : nFrames
        P = read(VideoMedia, i);
        mov(i).cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
    end
    save(matName,'mov');
end


% 以原始视频的帧率进行一次回放.
WaitBarControl(0,'',handles.LeftVideoProgress, handles.VideoGrading);
for i = 1 : nFrames
    if (leftClose == 1)
        return;
    end
    axes(AxesHandle);
    if (leftClose == 1)
        return;
    end
    imshow(mov(i).cdata);
    if(leftClose == 1)
        return;
    end
    WaitBarControl(i/nFrames, [num2str(floor(i*100/nFrames)),'%'],handles.LeftVideoProgress, handles.VideoGrading);
end

% t = timer('Period', 0.002, 'TasksToExecute', nFrames, 'ExecutionMode','fixedRate', 'TimerFcn', {@onTimer, mov, AxesHandle, nFrames, handles});
% start(t);
% stop(t);
set(playHandle,'string','>>')
over = 1;


% function onTimer(timerHandle, event, mov, handle, nFrames, handles)
%     axes(handle);
%     imshow(mov(timerHandle.TasksExecuted).cdata);  
%     WaitBarControl(timerHandle.TasksExecuted - 1/nFrames, [num2str(floor(timerHandle.TasksExecuted*100/nFrames)),'%'],handles.LeftVideoProgress, handles.VideoGrading);
% end
% end






 
    
