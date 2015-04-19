function [mov, nFrames] = GetVideoData(VideoName)
% 获得Video的内容.
%获取视频的数据结构.
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;

% 预填充Video数据结构.
mov(1:nFrames) = ...
struct('cdata', zeros(videoHeight, videoWidth, 3, 'uint8'),'colormap', []);

% 载入帧数据.
for k = 1 : nFrames
    mov(k).cdata = read(VideoMedia, k);
end


