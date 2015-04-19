function [mov, nFrames] = GetVideoData(VideoName)
% ���Video������.
%��ȡ��Ƶ�����ݽṹ.
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;

% Ԥ���Video���ݽṹ.
mov(1:nFrames) = ...
struct('cdata', zeros(videoHeight, videoWidth, 3, 'uint8'),'colormap', []);

% ����֡����.
for k = 1 : nFrames
    mov(k).cdata = read(VideoMedia, k);
end


