function ClearAllFiles()
% 清空指定文件夹下的文件.

% 获得所有输出格式的变量状态.
global VOStatus;
if(VOStatus.OutputSourceVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SourceVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputSourceForeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SouceForeVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputSourceBackVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SouceBackVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputLuminaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\LuminaVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputChrominaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ChrominaVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputSyncVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SyncVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputForeLuminaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeLuminaVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputForeChrominaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeChrominaVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputForeSyncVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeSyncVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputForeLumWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeLumiWholeVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputForeChroWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeChrominaWholeVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputForeSyncWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeSyncWholeVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputBackLuminaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackLuminaVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputBackChrominaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackChrominaVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputBackSyncVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackSyncVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputBackLumWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackLuminaWholeVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputBackChroWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackChrominaWholeVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
if(VOStatus.OutputBackSyncWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackSyncWholeVideoSlices\';
    delete(strcat(ImagesDir,'*.jpg'));
end
