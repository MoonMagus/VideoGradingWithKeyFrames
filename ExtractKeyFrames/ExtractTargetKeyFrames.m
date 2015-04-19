function ExtractTargetKeyFrames(ExtractFore, MatteOpen)
% 抽取目标视频的关键帧.
global TargetForeVideoName;
global TargetForeMatteName;
global TargetBackVideoName;
global TargetBackMatteName;
global StatusBarHandle;
if(ExtractFore == 1)
    delete('VideoSlices\TargetForeSlices\*.jpg');
    delete('KeyFrames\TargetForeKeyFrames\*.jpg');
    FreshListBox('正在提取目标前景帧序列...', StatusBarHandle);
    pause(0.001);
    LoadVideoData(strcat('Video\StartVideo\',TargetForeVideoName), 'TargetFore');
    FreshListBox('目标前景帧序列提取完成.', StatusBarHandle);
    FreshListBox('开始提取目标前景关键帧...', StatusBarHandle);
    pause(0.001);
    ExtractKeyFrames(TargetForeVideoName, 'TargetFore');
    FreshListBox('目标前景关键帧提取完成', StatusBarHandle);
    if(MatteOpen == 1)
        delete('VideoSlices\TargetForeMatteSlices\*.jpg');
        delete('KeyFrames\TargetForeMatteKeyFrames\*.jpg');
        FreshListBox('正在提取目标前景蒙版帧序列...', StatusBarHandle);
        pause(0.001);
        LoadVideoData(strcat('Video\StartVideo\',TargetForeMatteName), 'TargetForeMatte');
        FreshListBox('目标前景蒙版帧序列提取完成.', StatusBarHandle);
        FreshListBox('开始提取目标前景蒙版关键帧...', StatusBarHandle);
        SclicesDir = 'VideoSlices\TargetForeMatteSlices\';
        KeyframesDir = 'KeyFrames\TargetForeMatteKeyFrames\';
        MatteDir = 'KeyFrames\TargetForeKeyFrames\';
        dirs1 = dir(strcat(MatteDir, '*.jpg'));
        dirs2 = dir(strcat(MatteDir, '*.bmp'));
        dirs = [dirs1;dirs2];
        dircell = struct2cell(dirs)';
        filenames = dircell(:,1);
        KeyFrames = size(filenames,1);
        for i = 1:KeyFrames
            f = imread(strcat(SclicesDir, char(filenames(i))));
            imwrite(f,strcat(KeyframesDir, char(filenames(i))));
        end
        FreshListBox('目标前景蒙版关键帧提取完成', StatusBarHandle);
    end
elseif(ExtractFore == 0)
    delete('VideoSlices\TargetBackSlices\*.jpg');
    delete('KeyFrames\TargetBackKeyFrames\*.jpg');
    FreshListBox('正在提取目标背景帧序列...', StatusBarHandle);
    pause(0.001);
    LoadVideoData(strcat('Video\StartVideo\',TargetBackVideoName), 'TargetBack');
    FreshListBox('目标背景帧序列提取完成.', StatusBarHandle);
    FreshListBox('开始提取目标背景关键帧...', StatusBarHandle);
    pause(0.001);
    ExtractKeyFrames(TargetBackVideoName, 'TargetBack');
    FreshListBox('目标背景关键帧提取完成', StatusBarHandle);
    if(MatteOpen == 1)
        delete('VideoSlices\TargetBackMatteSlices\*.jpg');
        delete('KeyFrames\TargetBackMatteKeyFrames\*.jpg');
        FreshListBox('正在提取目标背景蒙版帧序列...', StatusBarHandle);
        pause(0.001);
        LoadVideoData(strcat('Video\StartVideo\',TargetBackMatteName), 'TargetBackMatte');
        FreshListBox('目标背景蒙版帧序列提取完成.', StatusBarHandle);
        FreshListBox('开始提取目标背景蒙版关键帧...', StatusBarHandle);
        SclicesDir = 'VideoSlices\TargetBackMatteSlices\';
        KeyframesDir = 'KeyFrames\TargetBackMatteKeyFrames\';
        MatteDir = 'KeyFrames\TargetBackKeyFrames\';
        dirs1 = dir(strcat(MatteDir, '*.jpg'));
        dirs2 = dir(strcat(MatteDir, '*.bmp'));
        dirs = [dirs1;dirs2];
        dircell = struct2cell(dirs)';
        filenames = dircell(:,1);
        KeyFrames = size(filenames,1);
        for i = 1:KeyFrames
            f = imread(strcat(SclicesDir, char(filenames(i))));
            imwrite(f,strcat(KeyframesDir, char(filenames(i))));
        end
        FreshListBox('目标背景蒙版关键帧提取完成', StatusBarHandle);
    end
end