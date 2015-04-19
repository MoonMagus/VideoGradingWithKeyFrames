function SaveResultToVideos()
% 将最终的结果保存至相应的文件中.

% 获得所有输出格式的变量状态.
global VOStatus;
if(VOStatus.OutputSourceVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SourceVideoSlices\';
    VideoDir = 'Video\ResultVideo\SourceVideo\';
    VideoName = 'SourceVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputSourceForeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SouceForeVideoSlices\';
    VideoDir = 'Video\ResultVideo\SourceForeVideo\';
    VideoName = 'SourceForeVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputSourceBackVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SouceBackVideoSlices\';
    VideoDir = 'Video\ResultVideo\SourceBackVideo\';
    VideoName = 'SourceBackVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputLuminaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\LuminaVideoSlices\';
    VideoDir = 'Video\ResultVideo\LuminaVideo\';
    VideoName = 'LuminaVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputChrominaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ChrominaVideoSlices\';
    VideoDir = 'Video\ResultVideo\ChrominaVideo\';
    VideoName = 'ChrominaVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputSyncVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\SyncVideoSlices\';
    VideoDir = 'Video\ResultVideo\SyncVideo\';
    VideoName = 'SyncVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputForeLuminaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeLuminaVideoSlices\';
    VideoDir = 'Video\ResultVideo\ForeLuminaVideo\';
    VideoName = 'ForeLuminaVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputForeChrominaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeChrominaVideoSlices\';
    VideoDir = 'Video\ResultVideo\ForeChrominaVideo\';
    VideoName = 'ForeChrominaVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputForeSyncVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeSyncVideoSlices\';
    VideoDir = 'Video\ResultVideo\ForeSyncVideo\';
    VideoName = 'ForeSyncVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputForeLumWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeLumiWholeVideoSlices\';
    VideoDir = 'Video\ResultVideo\ForeLumiWholeVideo\';
    VideoName = 'ForeLumiWholeVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputForeChroWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeChrominaWholeVideoSlices\';
    VideoDir = 'Video\ResultVideo\ForeChrominaWholeVideo\';
    VideoName = 'ForeChrominaWholeVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputForeSyncWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\ForeSyncWholeVideoSlices\';
    VideoDir = 'Video\ResultVideo\ForeSyncWholeVideo\';
    VideoName = 'ForeSyncWholeVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputBackLuminaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackLuminaVideoSlices\';
    VideoDir = 'Video\ResultVideo\BackLuminaVideo\';
    VideoName = 'BackLuminaVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputBackChrominaVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackChrominaVideoSlices\';
    VideoDir = 'Video\ResultVideo\BackChrominaVideo\';
    VideoName = 'BackChrominaVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputBackSyncVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackSyncVideoSlices\';
    VideoDir = 'Video\ResultVideo\BackSyncVideo\';
    VideoName = 'BackSyncVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputBackLumWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackLuminaWholeVideoSlices\';
    VideoDir = 'Video\ResultVideo\BackLuminaWholeVideo\';
    VideoName = 'BackLuminaWholeVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputBackChroWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackChrominaWholeVideoSlices\';
    VideoDir = 'Video\ResultVideo\BackChrominaWholeVideo\';
    VideoName = 'BackChrominaWholeVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
if(VOStatus.OutputBackSyncWholeVideoIsOpen == 1)
    ImagesDir = 'VideoSlices\BackSyncWholeVideoSlices\';
    VideoDir = 'Video\ResultVideo\BackSyncWholeVideo\';
    VideoName = 'BackSyncWholeVideo';
    delete(strcat(VideoDir,'*.mp4'));
    SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
end
