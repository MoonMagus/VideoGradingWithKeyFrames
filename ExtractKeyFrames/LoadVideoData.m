function VideoData = LoadVideoData(VideoName)
%获取视频的数据结构.
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;

% 预填充Video数据结构.
mov(1:nFrames) = ...
struct('cdata', zeros(videoHeight, videoWidth, 3, 'uint8'),'colormap', []);

% 清空指定文件夹下的帧数据.
%delete C:\Users\devil\Desktop\KeyFrames\*.jpg;
delete VideoSlices\*.jpg;

% 保存帧数据.
% dirname = uigetdir('C:\Users\devil\Desktop\KeyFrames','浏览文件夹');
dirname = uigetdir('VideoSlices','浏览文件夹');

% 载入帧数据.
for k = 1 : nFrames
    mov(k).cdata = read(VideoMedia, k);
    TargetName = strcat(dirname,'\','第',num2str(k),'帧.jpg');
    imwrite(mov(k).cdata,TargetName);
end
VideoData = mov;
