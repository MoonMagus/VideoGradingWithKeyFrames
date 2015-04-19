function [nFrames, filenames] = GetFilenames(DirName)
% 获得制定目录下的文件名序列.
dirs1 = dir(strcat(DirName, '*.jpg'));
dirs2 = dir(strcat(DirName, '*.bmp'));
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
nFrames = size(filenames,1);