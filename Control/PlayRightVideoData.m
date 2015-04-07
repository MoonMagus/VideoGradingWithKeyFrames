function  PlayRightVideoData(AxesHandle, playHandle, handles, VideoName)
% ����ͬ����������.
global RightFrameRunning;
global rightOver;


%���������Ƶ��ǩ.
if(ishandle(AxesHandle) == 1)
    RightFrameRunning = 1;
end

%��ȡ��Ƶ�����ݽṹ.
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;
Position = get(AxesHandle,'Position');
AxesWidth = floor(Position(3));
AxesHeight = floor(Position(4));

% Ԥ���Video���ݽṹ.
mov(1:nFrames) = ...
struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));

% ����֡����.
h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
h2 = floor(AxesWidth * videoHeight / videoWidth);


if (rightOver == 1)
    return;
end
% ����������.
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


% ��ԭʼ��Ƶ��֡�ʽ���һ�λط�.
RightWaitBarControl(0,'',handles.RightVideoProgress, handles.VideoGrading);
for i = 1 : nFrames
    if(ishandle(AxesHandle) == 1)
        if (rightOver == 1)
            return;
        end
        axes(AxesHandle);
    else
        return;
    end
    if(ishandle(AxesHandle) == 1)
        if (rightOver == 1)
            return;
        end
        imshow(mov(i).cdata);
    else
        return;
    end
    RightWaitBarControl(i/nFrames, [num2str(floor(i*100/nFrames)),'%'],handles.RightVideoProgress, handles.VideoGrading);
end

% ��Ƶ�������Ž���ʱ����ͬ������.
set(playHandle,'string','>>')
rightOver = 0;
RightFrameRunning = 0;







 
    
