function SwitchSaveNames(handles, Video)
if(Video == 1)
    set(handles.OutputSourceVideo, 'String', 'OutputSourceVideo');
    set(handles.OutputSourceForeVideo, 'String', 'OutputSourceForeVideo');
    set(handles.OutputSourceBackVideo, 'String', 'OutputSourceBackVideo');
    set(handles.OutputLuminaVideo, 'String', 'OutputLuminaVideo');  
    set(handles.OutputChrominaVideo, 'String', 'OutputChrominaVideo');
    set(handles.OutputSyncVideo, 'String', 'OutputSyncVideo');
    set(handles.OutputForeLuminaVideo, 'String', 'OutputForeLuminaVideo');
    set(handles.OutputForeChrominaVideo, 'String', 'OutputForeChrominaVideo'); 
    set(handles.OutputForeSyncVideo, 'String', 'OutputForeSyncVideo');
    set(handles.OutputForeLumWholeVideo, 'String', 'OutputForeLumWholeVideo'); 
    set(handles.OutputForeChroWholeVideo, 'String', 'OutputForeChroWholeVideo');
    set(handles.OutputForeSyncWholeVideo, 'String', 'OutputForeSyncWholeVideo');
    set(handles.OutputBackLuminaVideo, 'String', 'OutputBackLuminaVideo');   
    set(handles.OutputBackChrominaVideo, 'String', 'OutputBackChrominaVideo');   
    set(handles.OutputBackSyncVideo, 'String', 'OutputBackSyncVideo');
    set(handles.OutputBackLumWholeVideo, 'String', 'OutputBackLumWholeVideo');    
    set(handles.OutputBackChroWholeVideo, 'String', 'OutputBackChroWholeVideo');
    set(handles.OutputBackSyncWholeVideo, 'String', 'OutputBackSyncWholeVideo');
else
    set(handles.OutputSourceVideo, 'String', 'OutputSourceImage');
    set(handles.OutputSourceForeVideo, 'String', 'OutputSourceForeImage');
    set(handles.OutputSourceBackVideo, 'String', 'OutputSourceBackImage');
    set(handles.OutputLuminaVideo, 'String', 'OutputLuminaImage');  
    set(handles.OutputChrominaVideo, 'String', 'OutputChrominaImage');
    set(handles.OutputSyncVideo, 'String', 'OutputSyncImage');
    set(handles.OutputForeLuminaVideo, 'String', 'OutputForeLuminaImage');
    set(handles.OutputForeChrominaVideo, 'String', 'OutputForeChrominaImage'); 
    set(handles.OutputForeSyncVideo, 'String', 'OutputForeSyncImage');
    set(handles.OutputForeLumWholeVideo, 'String', 'OutputForeLumWholeImage'); 
    set(handles.OutputForeChroWholeVideo, 'String', 'OutputForeChroWholeImage');
    set(handles.OutputForeSyncWholeVideo, 'String', 'OutputForeSyncWholeImage');
    set(handles.OutputBackLuminaVideo, 'String', 'OutputBackLuminaImage');   
    set(handles.OutputBackChrominaVideo, 'String', 'OutputBackChrominaImage');   
    set(handles.OutputBackSyncVideo, 'String', 'OutputBackSyncImage');
    set(handles.OutputBackLumWholeVideo, 'String', 'OutputBackLumWholeImage');    
    set(handles.OutputBackChroWholeVideo, 'String', 'OutputBackChroWholeImage');
    set(handles.OutputBackSyncWholeVideo, 'String', 'OutputBackSyncWholeImage');
end