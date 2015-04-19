function OpenAllVideoFormat(handles)
% 使能所有的Video输出格式.
set(handles.OutputSourceForeVideo, 'Enable', 'on');
set(handles.OutputSourceBackVideo, 'Enable', 'on');
set(handles.OutputLuminaVideo, 'Enable', 'on');
set(handles.OutputChrominaVideo, 'Enable', 'on');
set(handles.OutputSyncVideo, 'Enable', 'on');
set(handles.OutputForeLuminaVideo, 'Enable', 'on');
set(handles.OutputForeChrominaVideo, 'Enable', 'on');
set(handles.OutputForeSyncVideo, 'Enable', 'on');
set(handles.OutputForeLumWholeVideo, 'Enable', 'on');
set(handles.OutputForeChroWholeVideo, 'Enable', 'on');
set(handles.OutputForeSyncWholeVideo, 'Enable', 'on');
set(handles.OutputBackLuminaVideo, 'Enable', 'on');
set(handles.OutputBackChrominaVideo, 'Enable', 'on');
set(handles.OutputBackSyncVideo, 'Enable', 'on');
set(handles.OutputBackLumWholeVideo, 'Enable', 'on');
set(handles.OutputBackChroWholeVideo, 'Enable', 'on');
set(handles.OutputBackSyncWholeVideo, 'Enable', 'on');