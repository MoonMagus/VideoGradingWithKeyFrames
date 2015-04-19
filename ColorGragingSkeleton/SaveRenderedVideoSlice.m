function SaveRenderedVideoSlice(picname)
% 保存渲染的视频帧结果.
% 获得所有输出格式的变量状态.
global VOStatus;
global ForeStruct;
global BackStruct;
global ResultStruct;
global SourceSynOpen;
%dirname = uigetdir('C:\Users\devil\Desktop\实验','浏览文件夹');
%dirname = 'VideoSlices\SourceVideoSlices';
% 清空指定的文件夹.
%deleteName = strcat(dirname,'\*.jpg');
%delete(deleteName);
if (nargin == 0)
    name = '临时图像';
end
if(VOStatus.OutputSourceVideoIsOpen == 1)
    name = strcat('VideoSlices\SourceVideoSlices\',picname);
    imwrite(ResultStruct.Source,name);
end
if(VOStatus.OutputSourceForeVideoIsOpen == 1)
    name = strcat('VideoSlices\SouceForeVideoSlices\',picname);
    imwrite(ForeStruct.rs,name);
end
if(VOStatus.OutputSourceBackVideoIsOpen == 1)
    name = strcat('VideoSlices\SouceBackVideoSlices\',picname);
    imwrite(BackStruct.rs,name);
end
if(VOStatus.OutputLuminaVideoIsOpen == 1)
    if(SourceSynOpen == 0)
        name = strcat('VideoSlices\LuminaVideoSlices\',picname);
        imwrite(ForeStruct.LuminaOnlyResult,name);
    else
        name = strcat('VideoSlices\LuminaVideoSlices\',picname);
        imwrite(ResultStruct.CompositeLuminOnlyResult, name);
    end
end
if(VOStatus.OutputChrominaVideoIsOpen == 1)
    if(SourceSynOpen == 0)
        name = strcat('VideoSlices\ChrominaVideoSlices\',picname);
        imwrite(ForeStruct.HueOnlyResult,name);
    else
        name = strcat('VideoSlices\ChrominaVideoSlices\',picname);
        imwrite(ResultStruct.CompostiteHueOnlyResult,name);
    end
end
if(VOStatus.OutputSyncVideoIsOpen == 1)
    if(SourceSynOpen == 0)
        name = strcat('VideoSlices\SyncVideoSlices\',picname);
        imwrite(ForeStruct.HueSynResult,name);
    else
        name = strcat('VideoSlices\SyncVideoSlices\',picname);
        imwrite(ResultStruct.CompositeHueSynResult,name);
    end
end
if(VOStatus.OutputForeLuminaVideoIsOpen == 1)
    name = strcat('VideoSlices\ForeLuminaVideoSlices\',picname);
    imwrite(ForeStruct.LuminaOnlyResult,name);
end
if(VOStatus.OutputForeChrominaVideoIsOpen == 1)
    name = strcat('VideoSlices\ForeChrominaVideoSlices\',picname);
    imwrite(ForeStruct.HueOnlyResult,name);
end
if(VOStatus.OutputForeSyncVideoIsOpen == 1)
    name = strcat('VideoSlices\ForeSyncVideoSlices\',picname);
    imwrite(ForeStruct.HueSynResult,name);
end
if(VOStatus.OutputForeLumWholeVideoIsOpen == 1)
    name = strcat('VideoSlices\ForeLumiWholeVideoSlices\',picname);
    imwrite(ForeStruct.WholeLuminOnlyResult,name);
end
if(VOStatus.OutputForeChroWholeVideoIsOpen == 1)
    name = strcat('VideoSlices\ForeChrominaWholeVideoSlices\',picname);
    imwrite(ForeStruct.WholeHueOnlyResult,name);
end
if(VOStatus.OutputForeSyncWholeVideoIsOpen == 1)
    name = strcat('VideoSlices\ForeSyncWholeVideoSlices\',picname);
    imwrite(ForeStruct.WholeHueSynResult,name);
end
if(VOStatus.OutputBackLuminaVideoIsOpen == 1)
    name = strcat('VideoSlices\BackLuminaVideoSlices\',picname);
    imwrite(BackStruct.LuminaOnlyResult,name);
end
if(VOStatus.OutputBackChrominaVideoIsOpen == 1)
    name = strcat('VideoSlices\BackChrominaVideoSlices\',picname);
    imwrite(BackStruct.HueOnlyResult,name);
end
if(VOStatus.OutputBackSyncVideoIsOpen == 1)
    name = strcat('VideoSlices\BackSyncVideoSlices\',picname);
    imwrite(BackStruct.HueSynResult,name);
end
if(VOStatus.OutputBackLumWholeVideoIsOpen == 1)
    name = strcat('VideoSlices\BackLuminaWholeVideoSlices\',picname);
    imwrite(BackStruct.WholeLuminOnlyResult,name);
end
if(VOStatus.OutputBackChroWholeVideoIsOpen == 1)
    name = strcat('VideoSlices\BackChrominaWholeVideoSlices\',picname);
    imwrite(BackStruct.WholeHueOnlyResult,name);
end
if(VOStatus.OutputBackSyncWholeVideoIsOpen == 1)
    name = strcat('VideoSlices\BackSyncWholeVideoSlices\',picname);
    imwrite(BackStruct.WholeHueSynResult,name);
end
