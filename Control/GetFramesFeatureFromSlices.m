function FS = GetFramesFeatureFromSlices(SlicesDir, SlicesMatteOpen, SlicesMatteDir, TargetKeyName)
% 该函数用于从指定的Slices序列提取每帧的特征值，如果开启蒙版，则提取蒙版叠加后特征值.
dirs1 = dir(strcat(SlicesDir, '*.jpg'));
dirs2 = dir(strcat(SlicesDir, '*.bmp'));
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
n = size(filenames,1);
Frames(1,n) = struct('MS',[],'ES',[],'MM',[],'EM',[],'MH',[],'EH',[]);
TargetKeyName = strcat('VideoData\',TargetKeyName,'Feature.mat');
fid = fopen(TargetKeyName);
if(fid ~= -1)
    Frames = load(TargetKeyName);
    FS = Frames.Frames;
    fclose('all');
else
    if(SlicesMatteOpen == 1)
        for i = 1 : n
            Frames(i) = ExtractBandFeatureWithMatte(strcat(SlicesDir,char(filenames(i))), strcat(SlicesMatteDir,char(filenames(i))))';
        end
    else
        for i = 1 : n
            Frames(i) = ExtractLABBandFeature(strcat(SlicesDir,char(filenames(i))))';
        end
    end
    FS = Frames;
    save(TargetKeyName, 'Frames');
end