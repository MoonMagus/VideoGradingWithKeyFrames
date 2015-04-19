function GetAllVideoOutputStatus(handles)
% 获得所有输出格式的变量状态.
global VOStatus;
VOStatus.OutputSourceVideoIsOpen = get(handles.OutputSourceVideo, 'Value');
VOStatus.OutputSourceForeVideoIsOpen = get(handles.OutputSourceForeVideo, 'Value');
VOStatus.OutputSourceBackVideoIsOpen = get(handles.OutputSourceBackVideo, 'Value');
VOStatus.OutputLuminaVideoIsOpen = get(handles.OutputLuminaVideo, 'Value');
VOStatus.OutputChrominaVideoIsOpen = get(handles.OutputChrominaVideo, 'Value');
VOStatus.OutputSyncVideoIsOpen = get(handles.OutputSyncVideo, 'Value');
VOStatus.OutputForeLuminaVideoIsOpen = get(handles.OutputForeLuminaVideo, 'Value');
VOStatus.OutputForeChrominaVideoIsOpen = get(handles.OutputForeChrominaVideo, 'Value');
VOStatus.OutputForeSyncVideoIsOpen = get(handles.OutputForeSyncVideo, 'Value');
VOStatus.OutputForeLumWholeVideoIsOpen = get(handles.OutputForeLumWholeVideo, 'Value');
VOStatus.OutputForeChroWholeVideoIsOpen = get(handles.OutputForeChroWholeVideo, 'Value');
VOStatus.OutputForeSyncWholeVideoIsOpen = get(handles.OutputForeSyncWholeVideo, 'Value');
VOStatus.OutputBackLuminaVideoIsOpen = get(handles.OutputBackLuminaVideo, 'Value');
VOStatus.OutputBackChrominaVideoIsOpen = get(handles.OutputBackChrominaVideo, 'Value');
VOStatus.OutputBackSyncVideoIsOpen = get(handles.OutputBackSyncVideo, 'Value');
VOStatus.OutputBackLumWholeVideoIsOpen = get(handles.OutputBackLumWholeVideo, 'Value');
VOStatus.OutputBackChroWholeVideoIsOpen = get(handles.OutputBackChroWholeVideo, 'Value');
VOStatus.OutputBackSyncWholeVideoIsOpen = get(handles.OutputBackSyncWholeVideo, 'Value');

