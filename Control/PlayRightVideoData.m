function  PlayRightVideoData(AxesHandle, playHandle, handles, VideoName)
% ����ͬ����������.
% global RightFrameRunning;
% global rightOver;
global movRight;
global rightLastVideoName;
global ShowResulting;

%���������Ƶ��ǩ.
% if(ishandle(AxesHandle) == 1)
%     RightFrameRunning = 1;
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


% if (rightOver == 1)
%     return;
% end
% ����������.
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


% ��ԭʼ��Ƶ��֡�ʽ���һ�λط�.
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

% ��Ƶ�������Ž���ʱ����ͬ������.
% if(ishandle(playHandle) == 1)
%     set(playHandle,'string','>>')
% end
% rightOver = 0;
% RightFrameRunning = 0;







 
    
