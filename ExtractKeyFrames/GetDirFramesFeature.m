function [TargetKeyframesFeature, HISTDATAs] = GetDirFramesFeature(ForeOrBack, OpenReverse)
global TargetForeMatteOpen;
global BackMatteHasBeenAdd;
% 获得制定目录下的关键帧特征值.
if(ForeOrBack == 1)
    DirName = 'KeyFrames/TargetForeKeyFrames/';
    DirMatteName = 'KeyFrames/TargetForeMatteKeyFrames/';
    open = TargetForeMatteOpen;
else
    DirName = 'KeyFrames/TargetBackKeyFrames/';
    DirMatteName = 'KeyFrames/TargetBackMatteKeyFrames/';
    open = BackMatteHasBeenAdd;
end
[nFrames, filenames] = GetFilenames(DirName);
TargetKeyframesFeature(1, nFrames) = struct('MS',[],'ES',[],'MM',[],'EM',[],'MH',[],'EH',[]);
hasDefineData = 0;

for i = 1 : nFrames
    TargetImage = strcat(DirName,filenames(i));
    TargetImage = char(TargetImage);

    if(open == 1)
        TargetMatteImage = strcat(DirMatteName,filenames(i));
        TargetMatteImage = char(TargetMatteImage);
        if(hasDefineData == 0)
            hasDefineData = 1;
            f = imread(TargetImage);
            [x,y] = size(f);
            HISTDATAs(1, nFrames) = struct('HISTDATA',zeros(x,y, 'double'));
        end
        [TargetKeyframesFeature(i), HISTDATAs(i).HISTDATA] = ExtractBandFeatureWithMatte(TargetImage, TargetMatteImage, OpenReverse);
    else
        if(hasDefineData == 0)
            hasDefineData = 1;
            f = imread(TargetImage);
            [x,y] = size(f);
            HISTDATAs(1, nFrames) = struct('HISTDATA',zeros(x,y, 'double'));
        end
        [TargetKeyframesFeature(i), HISTDATAs(i).HISTDATA] = ExtractLABBandFeature(TargetImage);
    end
end