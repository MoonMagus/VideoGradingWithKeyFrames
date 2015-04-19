function [nFrames, filenames] = GetFilenames(DirName)
% ����ƶ�Ŀ¼�µ��ļ�������.
dirs1 = dir(strcat(DirName, '*.jpg'));
dirs2 = dir(strcat(DirName, '*.bmp'));
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
nFrames = size(filenames,1);