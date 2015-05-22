function ColorTransferWitinImage()
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackGradingOpen;
global TargetBackMatteOpen;
global CoreMethodName;
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
global OpenForeMatteReverseSwitch;
global OpenBackMatteReverseSwitch;
global SourceImageName;
global SourceMatteImageName;
global TargetForeImageName;
global TargetForeImageMatteName;
global TargetBackImageName;
global TargetBackImageMatteName;

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

pause(0.001);
if(stopRendering == 1)
    stopRendering = 0;
    disp('渲染图像被临时终止...');
    FreshListBox('渲染图像被临时终止...', StatusBarHandle);
    return;
end
FreshListBox('开始提取目标图像前景特征...', StatusBarHandle);
TargetForeName = char(strcat('Images\',TargetForeImageName));
TargetForeImage = imread(char(TargetForeName));
if(TargetForeMatteOpen == 0)
    [F1, HISTDATA] = ExtractLABBandFeature(TargetForeName);
else
    TargetForeMatteName = char(strcat('Images/',TargetForeImageMatteName));
    TargetForeMatteImage = imread(char(TargetForeMatteName));
    if(OpenForeMatteReverseSwitch == 1)
        TargetForeMatteImage = 255 - TargetForeMatteImage;
    end
    [F1, HISTDATA] = ExtractBandFeatureWithMatte(TargetForeName, TargetForeMatteName, OpenForeMatteReverseSwitch);
end 
pause(0.001);
if(stopRendering == 1)
    stopRendering = 0;
    disp('渲染图像被临时终止...');
    FreshListBox('渲染图像被临时终止...', StatusBarHandle);
    return;
end
if(SourceSynOpen == 1)
    FreshListBox('开始提取目标图像背景特征...', StatusBarHandle);
    if(TargetBackGradingOpen == 1)
        if(TargetBackMatteOpen == 0)
            TargetBackName = char(strcat('Images/',TargetBackImageName));
            TargetBackImage = imread(char(TargetBackName));
            [F2, HISTDATAB] = ExtractLABBandFeature(TargetBackName);
        else
            TargetBackName = char(strcat('Images/',TargetBackImageName));
            TargetBackImage = imread(char(TargetBackName));
            TargetBackMatteName = char(strcat('Images/',TargetBackImageMatteName));
            TargetBackMatteImage = imread(char(TargetBackMatteName));
            if(OpenBackMatteReverseSwitch == 1)
                TargetBackMatteImage = 255 - TargetBackMatteImage;
            end
            [F2, HISTDATAB] = ExtractBandFeatureWithMatte(TargetBackName, TargetBackMatteName, OpenBackMatteReverseSwitch);
        end
    else
        [F2, HISTDATAB] = ExtractBandFeatureWithMatte(TargetForeName, TargetForeMatteName, 1 - OpenForeMatteReverseSwitch);
    end
end


% 渲染图像.
disp('开始渲染图像...');
ClearAllFiles();
pause(0.001);
if(stopRendering == 1)
    stopRendering = 0;
    disp('渲染视频帧被临时终止...');
    FreshListBox('渲染视频帧被临时终止...', StatusBarHandle);
    return;
end
SourceName = strcat('Images/',SourceImageName);
SourceImage = imread(char(SourceName));
SourceMatteName = strcat('Images/', SourceMatteImageName);
SourceMatteImage = imread(char(SourceMatteName));
if(strcmp(CoreMethodName, 'ColorGradingMethod') == 1)
    ForeStruct = ColorTransferWithImage(SourceImage, SourceMatteOpen, SourceMatteImage, F1, HISTDATA,  OpenFilter, 0);
elseif(strcmp(CoreMethodName, 'ReinhardMethod') == 1)
    if(TargetForeMatteOpen == 0)
        TargetForeMatteImage = 0;
    end
    ForeStruct = ColorTransferWithImageReinhard(SourceImage, SourceMatteOpen, SourceMatteImage, TargetForeImage, TargetForeMatteOpen, TargetForeMatteImage);
end
if(SourceSynOpen  == 1)
    SourceBackMatte = 255 - SourceMatteImage;
    if(TargetBackGradingOpen == 0)
        if(strcmp(CoreMethodName, 'ColorGradingMethod') == 1)
            BackStruct =  ColorTransferWithImage(SourceImage, 1, SourceBackMatte, F2, HISTDATAB, OpenFilter, 0); 
        elseif(strcmp(CoreMethodName, 'ReinhardMethod') == 1)
            BackStruct =  ColorTransferWithImageReinhard(SourceImage, 1, SourceBackMatte, TargetForeImage, 1, 255 - TargetForeMatteImage);
        end
    else
        if(strcmp(CoreMethodName, 'ColorGradingMethod') == 1)
            BackStruct =  ColorTransferWithImage(SourceImage, 1, SourceBackMatte, F2, HISTDATAB, OpenFilter, 0);
        elseif(strcmp(CoreMethodName, 'ReinhardMethod') == 1)
            BackStruct =  ColorTransferWithImageReinhard(SourceImage, 1, SourceBackMatte,TargetBackImage, TargetBackMatteOpen,TargetBackMatteImage);
        end
    end
end
% 合成渲染结果.
if (SourceSynOpen == 1)
    ResultStruct.CompositeLuminOnlyResult = CatImageMatteRegion(ForeStruct.WholeLuminOnlyResult, BackStruct.WholeLuminOnlyResult, SourceMatteImage);
    ResultStruct.CompostiteHueOnlyResult =  CatImageMatteRegion(ForeStruct.WholeHueOnlyResult, BackStruct.WholeHueOnlyResult, SourceMatteImage);
    ResultStruct.CompositeHueSynResult = CatImageMatteRegion(ForeStruct.WholeHueSynResult, BackStruct.WholeHueSynResult, SourceMatteImage);
else
    ResultStruct.CompositeLuminOnlyResult = ForeStruct.WholeLuminOnlyResult;
    ResultStruct.CompostiteHueOnlyResult = ForeStruct.WholeHueOnlyResult;
    ResultStruct.CompositeHueSynResult = ForeStruct.WholeHueSynResult;
end
ResultStruct.Source = SourceImage;

% 实时显示渲染图像.
RealTimeRendering(SourceImage, 1);
if(SourceMatteOpen == 0)
    RealTimeRendering(ForeStruct.HueOnlyResult, 0);
else
    RealTimeRendering(ResultStruct.CompostiteHueOnlyResult, 0);
end  
SaveRenderedVideoSlice(char(SourceImageName));
