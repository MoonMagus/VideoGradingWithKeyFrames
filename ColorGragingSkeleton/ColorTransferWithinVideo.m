function ColorTransferWithinVideo()
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackGradingOpen;
global TargetBackMatteOpen;

global SourceVideoName;
global SourceMatteName;

global ForeStruct;
global BackStruct;
global ResultStruct;
global StatusBarHandle;
global stopRendering;
global StatusProgressBarHandle;
global figHandle;
global StartRealTimeRendering;
global OpenFilter;
global OpenUpdateForeKeyFrames;
global OpenUpdateBackKeyFrames;
global OpenForeMatteReverseSwitch;
global OpenBackMatteReverseSwitch;

stopRendering = 0;
StartRealTimeRendering = 0;
ClearListBox(StatusBarHandle);
StatusWaitBarControl(0,StatusProgressBarHandle, figHandle);
set(StatusProgressBarHandle,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');

% ��ȡĿ��ǰ���ؼ�֡.
if(OpenUpdateForeKeyFrames == 1)
    pause(0.001);
    if(stopRendering == 1)
        stopRendering = 0;
        disp('��Ⱦ��Ƶ֡����ʱ��ֹ...');
        FreshListBox('��Ⱦ��Ƶ֡����ʱ��ֹ...', StatusBarHandle);
        return;
    end
    if(TargetForeMatteOpen == 1)       
        ExtractTargetKeyFrames(1, 1);
    else
        ExtractTargetKeyFrames(1, 0);
    end
end
% ��ȡĿ�걳���ؼ�֡.
if(OpenUpdateBackKeyFrames == 1)
    pause(0.001);
    if(stopRendering == 1)
        stopRendering = 0;
        disp('��Ⱦ��Ƶ֡����ʱ��ֹ...');
        FreshListBox('��Ⱦ��Ƶ֡����ʱ��ֹ...', StatusBarHandle);
        return;
    end
    if(TargetBackGradingOpen == 1 && TargetBackMatteOpen == 1)
        ExtractTargetKeyFrames(0, 1);
    elseif(TargetBackMatteOpen == 1 && TargetBackMatteOpen == 0)
        ExtractTargetKeyFrames(0, 0);
    end
end

pause(0.001);
if(stopRendering == 1)
    stopRendering = 0;
    disp('��Ⱦ��Ƶ֡����ʱ��ֹ...');
    FreshListBox('��Ⱦ��Ƶ֡����ʱ��ֹ...', StatusBarHandle);
    return;
end
FreshListBox('��ʼ��ȡĿ��ǰ���ؼ�֡����...', StatusBarHandle);
[F1, H1, Filenames1] = GetDirFramesFeature(1,OpenForeMatteReverseSwitch);
n1 = size(F1,2); 
pause(0.001);
if(stopRendering == 1)
    stopRendering = 0;
    disp('��Ⱦ��Ƶ֡����ʱ��ֹ...');
    FreshListBox('��Ⱦ��Ƶ֡����ʱ��ֹ...', StatusBarHandle);
    return;
end
if(SourceSynOpen == 1)
    FreshListBox('��ʼ��ȡĿ�걳���ؼ�֡����...', StatusBarHandle);
    if(TargetBackGradingOpen == 1)
        [F2, H2, Filenames2] = GetDirFramesFeature(0,OpenBackMatteReverseSwitch);
        n2 = size(F2,2);
    else
        [F3, H3, Filenames3] = GetDirFramesFeature(1,1 - OpenForeMatteReverseSwitch);
        n3 = size(F3,2); 
    end
end


% ��ȾVideo.
pause(0.001);
if(stopRendering == 1)
    stopRendering = 0;
    disp('��Ⱦ��Ƶ֡����ʱ��ֹ...');
    FreshListBox('��Ⱦ��Ƶ֡����ʱ��ֹ...', StatusBarHandle);
    return;
end
FreshListBox('��ʼ��ȡԴ��Ƶ֡����...', StatusBarHandle);
[SourceVideo, nFrames] = GetVideoData(strcat('Video\StartVideo\',SourceVideoName));
pause(0.001);
if(stopRendering == 1)
    stopRendering = 0;
    disp('��Ⱦ��Ƶ֡����ʱ��ֹ...');
    FreshListBox('��Ⱦ��Ƶ֡����ʱ��ֹ...', StatusBarHandle);
    return;
end
if(SourceMatteOpen == 1)
    FreshListBox('��ʼ��ȡԴ��Ƶ�ɰ�֡����...', StatusBarHandle);
    SourceMatteVideo = GetVideoData(strcat('Video\StartVideo\',SourceMatteName));
else
    SourceMatteVideo(1:nFrames) = ...
    struct('cdata', zeros(1, 1, 3, 'uint8'),'colormap', []);
end
disp('��ʼ��Ⱦ��Ƶ֡...');
ClearAllFiles();
for i = 1 : nFrames
    pause(0.001);
    if(stopRendering == 1)
        stopRendering = 0;
        disp('��Ⱦ��Ƶ֡����ʱ��ֹ...');
        FreshListBox('��Ⱦ��Ƶ֡����ʱ��ֹ...', StatusBarHandle);
        return;
    end
    ForeStruct = ColorTransferWithVideo(SourceVideo(i).cdata, SourceMatteOpen, SourceMatteVideo(i).cdata, F1, n1, H1, OpenFilter, 0);
    if(SourceSynOpen  == 1)
        SourceBackMatte = 255 - SourceMatteVideo(i).cdata;
        if(TargetBackGradingOpen == 0)
             BackStruct =  ColorTransferWithVideo(SourceVideo(i).cdata, 1, SourceBackMatte, F3, n3, H3, OpenFilter, 0);
        else
             BackStruct =  ColorTransferWithVideo(SourceVideo(i).cdata, 1, SourceBackMatte, F2, n2, H2, OpenFilter, 0);
        end
    end
    % �ϳ���Ⱦ���.
    if (SourceSynOpen == 1)
        ResultStruct.CompositeLuminOnlyResult = CatImageMatteRegion(ForeStruct.WholeLuminOnlyResult, BackStruct.WholeLuminOnlyResult, SourceMatteVideo(i).cdata);
        ResultStruct.CompostiteHueOnlyResult =  CatImageMatteRegion(ForeStruct.WholeHueOnlyResult, BackStruct.WholeHueOnlyResult, SourceMatteVideo(i).cdata);
        ResultStruct.CompositeHueSynResult = CatImageMatteRegion(ForeStruct.WholeHueSynResult, BackStruct.WholeHueSynResult, SourceMatteVideo(i).cdata);
    else
        ResultStruct.CompositeLuminOnlyResult = ForeStruct.WholeLuminOnlyResult;
        ResultStruct.CompostiteHueOnlyResult = ForeStruct.WholeHueOnlyResult;
        ResultStruct.CompositeHueSynResult = ForeStruct.WholeHueSynResult;
    end
    ResultStruct.Source = SourceVideo(i).cdata;
    
    % ʵʱ��ʾ��Ⱦ��Ƶ֡.
    RealTimeRendering(SourceVideo(i).cdata, 1);
    if(SourceMatteOpen == 0)
        RealTimeRendering(ForeStruct.HueOnlyResult, 0);
    else
        RealTimeRendering(ResultStruct.CompostiteHueOnlyResult, 0);
    end
    
    SaveRenderedVideoSlice(strcat('��',num2str(i),'֡.jpg'));
    StatusWaitBarControl(i/nFrames, StatusProgressBarHandle, figHandle);
    FreshListBox(strcat('������Ⱦ��',num2str(i),'֡.jpg'), StatusBarHandle);
    FreshListBox(strcat('ǰ���ؼ�֡Ϊ��',char(Filenames1(ForeStruct.index))), StatusBarHandle);
    if(SourceSynOpen  == 1)
        if(TargetBackGradingOpen == 0)
             FreshListBox(strcat('�����ؼ�֡Ϊ��',char(Filenames3(BackStruct.index))), StatusBarHandle);
        else
             FreshListBox(strcat('�����ؼ�֡Ϊ��',char(Filenames2(BackStruct.index))), StatusBarHandle);
        end
    end
    FreshListBox(strcat('--------------------------------------'), StatusBarHandle);
    disp(strcat('��',num2str(i),'֡.jpg'));
end
FreshListBox('��ʼ������Ⱦ֡����......', StatusBarHandle);
disp('��ʼ������Ⱦ֡����......');
SaveResultToVideos();
FreshListBox('��Ƶ֡��Ⱦ����', StatusBarHandle);
disp('��Ƶ֡��Ⱦ����');

