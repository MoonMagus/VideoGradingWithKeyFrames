function ExtractTargetKeyFrames(ExtractFore, MatteOpen)
% ��ȡĿ����Ƶ�Ĺؼ�֡.
global TargetForeVideoName;
global TargetForeMatteName;
global TargetBackVideoName;
global TargetBackMatteName;
global StatusBarHandle;
if(ExtractFore == 1)
    delete('VideoSlices\TargetForeSlices\*.jpg');
    delete('KeyFrames\TargetForeKeyFrames\*.jpg');
    FreshListBox('������ȡĿ��ǰ��֡����...', StatusBarHandle);
    pause(0.001);
    LoadVideoData(strcat('Video\StartVideo\',TargetForeVideoName), 'TargetFore');
    FreshListBox('Ŀ��ǰ��֡������ȡ���.', StatusBarHandle);
    FreshListBox('��ʼ��ȡĿ��ǰ���ؼ�֡...', StatusBarHandle);
    pause(0.001);
    ExtractKeyFrames(TargetForeVideoName, 'TargetFore');
    FreshListBox('Ŀ��ǰ���ؼ�֡��ȡ���', StatusBarHandle);
    if(MatteOpen == 1)
        delete('VideoSlices\TargetForeMatteSlices\*.jpg');
        delete('KeyFrames\TargetForeMatteKeyFrames\*.jpg');
        FreshListBox('������ȡĿ��ǰ���ɰ�֡����...', StatusBarHandle);
        pause(0.001);
        LoadVideoData(strcat('Video\StartVideo\',TargetForeMatteName), 'TargetForeMatte');
        FreshListBox('Ŀ��ǰ���ɰ�֡������ȡ���.', StatusBarHandle);
        FreshListBox('��ʼ��ȡĿ��ǰ���ɰ�ؼ�֡...', StatusBarHandle);
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
        FreshListBox('Ŀ��ǰ���ɰ�ؼ�֡��ȡ���', StatusBarHandle);
    end
elseif(ExtractFore == 0)
    delete('VideoSlices\TargetBackSlices\*.jpg');
    delete('KeyFrames\TargetBackKeyFrames\*.jpg');
    FreshListBox('������ȡĿ�걳��֡����...', StatusBarHandle);
    pause(0.001);
    LoadVideoData(strcat('Video\StartVideo\',TargetBackVideoName), 'TargetBack');
    FreshListBox('Ŀ�걳��֡������ȡ���.', StatusBarHandle);
    FreshListBox('��ʼ��ȡĿ�걳���ؼ�֡...', StatusBarHandle);
    pause(0.001);
    ExtractKeyFrames(TargetBackVideoName, 'TargetBack');
    FreshListBox('Ŀ�걳���ؼ�֡��ȡ���', StatusBarHandle);
    if(MatteOpen == 1)
        delete('VideoSlices\TargetBackMatteSlices\*.jpg');
        delete('KeyFrames\TargetBackMatteKeyFrames\*.jpg');
        FreshListBox('������ȡĿ�걳���ɰ�֡����...', StatusBarHandle);
        pause(0.001);
        LoadVideoData(strcat('Video\StartVideo\',TargetBackMatteName), 'TargetBackMatte');
        FreshListBox('Ŀ�걳���ɰ�֡������ȡ���.', StatusBarHandle);
        FreshListBox('��ʼ��ȡĿ�걳���ɰ�ؼ�֡...', StatusBarHandle);
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
        FreshListBox('Ŀ�걳���ɰ�ؼ�֡��ȡ���', StatusBarHandle);
    end
end