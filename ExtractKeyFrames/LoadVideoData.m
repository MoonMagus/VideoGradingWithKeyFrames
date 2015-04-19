function VideoData = LoadVideoData(VideoName, DirName)
%��ȡ��Ƶ�����ݽṹ.
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;

% Ԥ���Video���ݽṹ.
mov(1:nFrames) = ...
struct('cdata', zeros(videoHeight, videoWidth, 3, 'uint8'),'colormap', []);

% ���ָ���ļ����µ�֡����.
%delete C:\Users\devil\Desktop\KeyFrames\*.jpg;
if(strcmp(DirName,'left') == 1)
    delete VideoSlices\LeftSlices\*.jpg;
elseif(strcmp(DirName,'right') == 1)
    delete VideoSlices\RightSlices\*.jpg;
end

% ����֡����.
% dirname = uigetdir('C:\Users\devil\Desktop\KeyFrames','����ļ���');
% dirname = uigetdir('VideoSlices\LeftSlices\','����ļ���');
if(strcmp(DirName, 'left') == 1)
    dirname = 'VideoSlices\LeftSlices\';
elseif(strcmp(DirName, 'right') == 1)
    dirname = 'VideoSlices\RightSlices\';
elseif(strcmp(DirName, 'TargetFore') == 1)
    dirname = 'VideoSlices\TargetForeSlices\';
elseif(strcmp(DirName, 'TargetForeMatte') == 1)
    dirname = 'VideoSlices\TargetForeMatteSlices\';
elseif(strcmp(DirName,'TargetBack') == 1)
    dirname = 'VideoSlices\TargetBackSlices\';
elseif(strcmp(DirName,'TargetBackMatte') == 1)
    dirname = 'VideoSlices\TargetBackMatteSlices\';
else
    dirname = 'VideoSlices\VideoSplitSlices\';
end


% ����֡����.
for k = 1 : nFrames
    mov(k).cdata = read(VideoMedia, k);
    TargetName = strcat(dirname,'��',num2str(k),'֡.jpg');
    imwrite(mov(k).cdata,TargetName);
end
VideoData = mov;
