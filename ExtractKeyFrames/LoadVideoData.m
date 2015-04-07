function VideoData = LoadVideoData(VideoName)
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
delete VideoSlices\*.jpg;

% ����֡����.
% dirname = uigetdir('C:\Users\devil\Desktop\KeyFrames','����ļ���');
dirname = uigetdir('VideoSlices','����ļ���');

% ����֡����.
for k = 1 : nFrames
    mov(k).cdata = read(VideoMedia, k);
    TargetName = strcat(dirname,'\','��',num2str(k),'֡.jpg');
    imwrite(mov(k).cdata,TargetName);
end
VideoData = mov;
