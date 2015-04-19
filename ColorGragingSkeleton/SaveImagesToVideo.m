function SaveImagesToVideo(ImagesDir, VideoName, VideoDir)
% ��ͼ��֡����Ŀ¼�е�ͼ��ѹ����.mp4��Ƶ�����VideoDirĿ¼��.

% ImagesDir = 'VideoSlices\LeftSlices\';
% VideoDir = 'Video\ResultVideo\LuminaVideo\';
% VideoName = '����';
% ������Ƶд�����.
writerObj = VideoWriter(strcat(VideoDir,VideoName),'MPEG-4');
writerObj.FrameRate = 30;
open(writerObj);

% ��ָ����ͼ������Ŀ¼.
dirs1 = dir(strcat(ImagesDir, '*.jpg'));
dirs2 = dir(strcat(ImagesDir, '*.bmp'));
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
nFrames = size(filenames,1);

% ����Ƶ֡����д��ָ������Ƶ��.
for i = 1 : nFrames
   imageName = strcat(ImagesDir,'��',num2str(i),'֡.jpg');
   frame = imread(imageName);
   writeVideo(writerObj,frame);
end
close(writerObj);