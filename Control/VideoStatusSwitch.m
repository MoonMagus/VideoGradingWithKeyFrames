function VideoStatusSwitch(handles)
global SourceMatteOpen;
global SourceSynOpen;
SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
SourceSynOpen = get(handles.SourceSyn, 'Value');
if(SourceMatteOpen == 0)
    OpenAllVideoFormat(handles);
    set(handles.OutputSourceForeVideo, 'Enable', 'off');
    set(handles.OutputSourceForeVideo, 'Value', 0);
    set(handles.OutputSourceBackVideo, 'Enable', 'off');
    set(handles.OutputSourceBackVideo, 'Value', 0);
    set(handles.OutputForeLuminaVideo, 'Enable', 'off');
    set(handles.OutputForeLuminaVideo, 'Value', 0);
    set(handles.OutputForeChrominaVideo, 'Enable', 'off');
    set(handles.OutputForeChrominaVideo, 'Value', 0);
    set(handles.OutputForeSyncVideo, 'Enable', 'off');
    set(handles.OutputForeSyncVideo, 'Value', 0);
    set(handles.OutputForeLumWholeVideo, 'Enable', 'off');
    set(handles.OutputForeLumWholeVideo, 'Value', 0);
    set(handles.OutputForeChroWholeVideo, 'Enable', 'off');
    set(handles.OutputForeChroWholeVideo, 'Value', 0);
    set(handles.OutputForeSyncWholeVideo, 'Enable', 'off');
    set(handles.OutputForeSyncWholeVideo, 'Value', 0);
    set(handles.OutputBackLuminaVideo, 'Enable', 'off');
    set(handles.OutputBackLuminaVideo, 'Value', 0);
    set(handles.OutputBackChrominaVideo, 'Enable', 'off');
    set(handles.OutputBackChrominaVideo, 'Value', 0);
    set(handles.OutputBackSyncVideo, 'Enable', 'off');
    set(handles.OutputBackSyncVideo, 'Value', 0);
    set(handles.OutputBackLumWholeVideo, 'Enable', 'off');
    set(handles.OutputBackLumWholeVideo, 'Value', 0);
    set(handles.OutputBackChroWholeVideo, 'Enable', 'off');
    set(handles.OutputBackChroWholeVideo, 'Value', 0);
    set(handles.OutputBackSyncWholeVideo, 'Enable', 'off');
    set(handles.OutputBackSyncWholeVideo, 'Value', 0);
else
    if(SourceSynOpen == 0)
        OpenAllVideoFormat(handles);
        set(handles.OutputSourceBackVideo, 'Enable', 'off');
        set(handles.OutputSourceBackVideo, 'Value', 0);
        set(handles.OutputLuminaVideo, 'Enable', 'off');
        set(handles.OutputLuminaVideo, 'Value', 0);
        set(handles.OutputChrominaVideo, 'Enable', 'off');
        set(handles.OutputChrominaVideo, 'Value', 0);
        set(handles.OutputSyncVideo, 'Enable', 'off');
        set(handles.OutputSyncVideo, 'Value', 0);
        set(handles.OutputBackLuminaVideo, 'Enable', 'off');
        set(handles.OutputBackLuminaVideo, 'Value', 0);
        set(handles.OutputBackChrominaVideo, 'Enable', 'off');
        set(handles.OutputBackChrominaVideo, 'Value', 0);
        set(handles.OutputBackSyncVideo, 'Enable', 'off');
        set(handles.OutputBackSyncVideo, 'Value', 0);
        set(handles.OutputBackLumWholeVideo, 'Enable', 'off');
        set(handles.OutputBackLumWholeVideo, 'Value', 0);
        set(handles.OutputBackChroWholeVideo, 'Enable', 'off');
        set(handles.OutputBackChroWholeVideo, 'Value', 0);
        set(handles.OutputBackSyncWholeVideo, 'Enable', 'off');
        set(handles.OutputBackSyncWholeVideo, 'Value', 0);
    elseif(SourceSynOpen == 1)
        OpenAllVideoFormat(handles);
    end 
end