function  PlayRightVideoData(AxesHandle, playHandle, handles, VideoName)
% 设置同步操作变量.
% global RightFrameRunning;
% global rightOver;
global movRight;
global rightLastVideoName;
global ShowResulting;

%获得左右视频标签.
% if(ishandle(AxesHandle) == 1)
%     RightFrameRunning = 1;
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


% if (rightOver == 1)
%     return;
% end
% 缓冲真数据.
if(strcmp(rightLastVideoName, VideoName) == 0)
    matName = strcat('VideoData\', VideoName(1:end - 4),'.mat');
    fid = fopen(matName);
    if(fid ~= -1)
        mov = load(matName);
        movRight = mov.mov;
        fclose('all');
    else
        for i = 1 : nFrames
            P = read(VideoMedia, i);
            mov(i).cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
        end
        save(matName,'mov');
        movRight = mov;
    end
    rightLastVideoName = VideoName;
end


% 以原始视频的帧率进行一次回放.
% RightWaitBarControl(0,'',handles.RightVideoProgress, handles.VideoGrading);
% for i = 1 : nFrames
%     if(ishandle(AxesHandle) == 1)
%         if (rightOver == 1)
%             return;
%         end
%         axes(AxesHandle);
%     else
%         return;
%     end
%     if(ishandle(AxesHandle) == 1)
%         if (rightOver == 1)
%             return;
%         end
%         imshow(mov(i).cdata);
%     else
%         return;
%     end
%     RightWaitBarControl(i/nFrames, [num2str(floor(i*100/nFrames)),'%'],handles.RightVideoProgress, handles.VideoGrading);
% end
movie(AxesHandle, movRight, 1, 30);
if(ishandle(AxesHandle) ==  1)
    axes(AxesHandle);
    imshow(movRight(nFrames).cdata);
end

% 视频完整播放结束时设置同步变量.
% if(ishandle(playHandle) == 1)
%     set(playHandle,'string','>>')
% end
% rightOver = 0;
% RightFrameRunning = 0;







 
    
