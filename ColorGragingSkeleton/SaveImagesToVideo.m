function SaveImagesToVideo(ImagesDir, VideoName, VideoDir)
% 将图像帧序列目录中的图像压缩成.mp4视频存放至VideoDir目录中.

% ImagesDir = 'VideoSlices\LeftSlices\';
% VideoDir = 'Video\ResultVideo\LuminaVideo\';
% VideoName = '测试';
% 创建视频写入对象.
writerObj = VideoWriter(strcat(VideoDir,VideoName),'MPEG-4');
writerObj.FrameRate = 30;
open(writerObj);

% 打开指定的图像序列目录.
dirs1 = dir(strcat(ImagesDir, '*.jpg'));
dirs2 = dir(strcat(ImagesDir, '*.bmp'));
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
nFrames = size(filenames,1);

% 将视频帧序列写入指定的视频中.
for i = 1 : nFrames
   imageName = strcat(ImagesDir,'第',num2str(i),'帧.jpg');
   frame = imread(imageName);
   writeVideo(writerObj,frame);
end
close(writerObj);