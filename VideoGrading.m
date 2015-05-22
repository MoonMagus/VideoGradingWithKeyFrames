function varargout = VideoGrading(varargin)
%%-----------------------------------------------------------------------  
% ColorGrading.
% Author: ������
% CreateTime: 2015-01-29 
%%------------------------------------------------------------------------  
%% ��ʼ������,����༭.
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VideoGrading_OpeningFcn, ...
                   'gui_OutputFcn',  @VideoGrading_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% ������ʼ��.


%% ��ColorGrading���ӻ�֮ǰִ��.
% global LeftFrameRunning;
% global leftOver;
% global RightFrameRunning;
% global rightOver;
global SourceVideoName;
global SourceMatteName;
global TargetForeVideoName;
global TargetForeMatteName;
global TargetBackVideoName;
global TargetBackMatteName;
global rendering;
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
global TargetBackGradingOpen;
global ForeStruct;
global BackStruct;
global ResultStruct;
global UiStatus;
global VOStatus;
global stopRendering;
global StatusBarHandle;
global StatusProgressBarHandle;
global figHandle;
global LeftAxisHandle;
global RightAxisHandle;
global StartRealTimeRendering;
global RealTimeWindowStruct;
global OpenFilter;
global OpenUpdateForeKeyFrames;
global OpenUpdateBackKeyFrames;
global OpenForeMatteReverseSwitch;
global OpenBackMatteReverseSwitch;
global movLeft;
global movRight;
global leftLastVideoName;
global rightLastVideoName;
global CoreMethodName;
global SourceImageName;
global SourceMatteImageName;
global TargetForeImageName;
global TargetForeImageMatteName;
global TargetBackImageName;
global TargetBackImageMatteName;
global ImageStatus;
global ShowResulting;
function VideoGrading_OpeningFcn(hObject, eventdata, handles, varargin)
% global LeftFrameRunning;
% LeftFrameRunning = 0;
% global leftOver;
% leftOver = 0;
% global RightFrameRunning;
% RightFrameRunning = 0;
% global rightOver;
% rightOver = 0;
global ShowResulting;
ShowResulting = 0;
global leftLastVideoName;
leftLastVideoName = '';
global rightLastVideoName;
rightLastVideoName = '';
global SourceVideoName;
SourceVideoName = '';
global SourceMatteName;
SourceMatteName = '';
global TargetForeVideoName;
TargetForeVideoName = '';
global TargetForeMatteName;
TargetForeMatteName = '';
global TargetBackVideoName;
TargetBackVideoName = '';
global TargetBackMatteName;
TargetBackMatteName = '';
global rendering;
rendering = 0;
global figHandle;
figHandle = hObject;
global StartRealTimeRendering;
StartRealTimeRendering = 0;
global CoreMethodName;
CoreMethodName = 'ColorGradingMethod';
global ImageStatus;
ImageStatus = 0;
SoftIcon = javax.swing.ImageIcon('Color.png');
figFrame = get(hObject,'JavaFrame'); 
figFrame.setFigureIcon(SoftIcon);
handles.output = hObject;
guidata(hObject, handles);
InitialAxes(handles);


%% ��������ص�������.
function varargout = VideoGrading_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function InitialAxes(handles)
set(handles.SourceVideoAxes,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetVideoAxes,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.SourcePreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.SourceMattePreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetForePreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetForeMattePreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetBackPreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetBackMattePreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);



% ����״̬��Ϣ����.
function StatusWindow_Callback(hObject, eventdata, handles)
function StatusWindow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global StatusBarHandle;
StatusBarHandle = hObject;


% ������.
function ProgressbarAxes_CreateFcn(hObject, eventdata, handles)
global StatusProgressBarHandle;
StatusProgressBarHandle = hObject;
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');


%% ���Ԥ�����ں������˵�.
% ���Ԥ������.
function FillPreviewWindow(hObject, AxesHandle, handles, curPopMenu)
% global leftOver;
% global LeftFrameRunning;
% global rightOver;
% global RightFrameRunning;
% %���������Ƶ��ǩ.
% if(ishandle(AxesHandle) == 1)
%     if(1 == strcmp(curPopMenu, 'left'))
%         leftOver = 0; 
%         LeftFrameRunning = 0;
%     else
%         rightOver = 0;
%         RightFrameRunning = 0;
%     end
% end
global ShowResulting;
if(strcmp(get(handles.SwitchButton,'String'),'SwitchImage') == 1)
    set(handles.LeftPlay, 'string','Play')
    ListName = get(hObject,'UserData');
    CurrentVideo = char(ListName(get(hObject,'Value')));
    if(ShowResulting == 0)
        VideoMedia = VideoReader(strcat('Video\StartVideo\',CurrentVideo));
    else
        VideoMedia = VideoReader(strcat('Video\ResultVideo\TotalVideos\',CurrentVideo));
    end
    videoHeight = VideoMedia.Height;
    videoWidth = VideoMedia.Width;
    nFrames = VideoMedia.NumberOfFrames;
    if(1 == strcmp(curPopMenu, 'left'))
        set(handles.LeftFrameNum, 'string',strcat('��',num2str(nFrames),'֡'));
    else
        set(handles.RightFrameNum, 'string',strcat('��',num2str(nFrames),'֡'));
    end
    Position = get(AxesHandle,'Position');
    AxesWidth = floor(Position(3));
    AxesHeight = floor(Position(4));
    mov = struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));
    h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
    h2 = floor(AxesWidth * videoHeight / videoWidth);
    P = read(VideoMedia, 1);
    mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
else
    ListName = get(hObject, 'UserData');
    CurrentImage = char(ListName(get(hObject,'Value')));
    if(ShowResulting == 0)
        P = imread(char(strcat('Images\',CurrentImage)));
    else
        P = imread(char(strcat('VideoSlices\TotalSlices\',CurrentImage)));
    end
    [x,y,~] = size(P);
    Position = get(AxesHandle,'Position');
    AxesWidth = floor(Position(3));
    AxesHeight = floor(Position(4));
    mov = struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));
    if(x/y < AxesHeight/AxesWidth)
        h1 = floor((AxesHeight - floor(AxesWidth * x / y))/2);
        h2 = floor(AxesWidth * x / y);
        mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
    else
        w1 = floor((AxesWidth - floor(AxesHeight*y/x))/2);
        w2 = floor(AxesHeight * y / x);
        mov.cdata(:,w1 : w1 + w2 - 1, :) = imresize(P,[AxesHeight, w2]);
    end
end
axes(AxesHandle);
imshow(mov.cdata);
% ��ȡPopMenu�µ�Video����.
function FillPopMemuData(hObject, VideoName)
dirs1 = dir('Video\StartVideo\*.mp4');
dirs2 = dir('Video\StartVideo\*.avi');
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
[x,~] = size(filenames);
if x > 0 
    ListImage = char(filenames(1));
else
    ListImage = '';
end
for i = 2:x
    ListImage = strcat(ListImage,'|',char(filenames(i)));
end
i = 1;
if nargin == 2
    for i=1:x
        if strcmp(char(filenames(i)),VideoName)==1
            break;
        end
    end
end
set(hObject,'String',ListImage);
set(hObject,'UserData',filenames);
set(hObject,'Value',i);

function FillPopMenuImageData(hObject)
dirs1 = dir('Images\*.bmp');
dirs2 = dir('Images\*.jpg');
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
[x,~] = size(filenames);
if x > 0 
    ListImage = char(filenames(1));
else
    ListImage = '';
end
for i = 2:x
    ListImage = strcat(ListImage,'|',char(filenames(i)));
end
i = 1;
if nargin == 2
    for i=1:x
        if strcmp(char(filenames(i)),VideoName)==1
            break;
        end
    end
end
set(hObject,'String',ListImage);
set(hObject,'UserData',filenames);
set(hObject,'Value',i);

function FillPopMenuResultData(hObject, imageOrMp4)
if(imageOrMp4 == 1)
    dirs1 = dir('VideoSlices\TotalSlices\*.bmp');
    dirs2 = dir('VideoSlices\TotalSlices\*.jpg');
else
    dirs1 = dir('Video\ResultVideo\TotalVideos\*.mp4');
    dirs2 = dir('Video\ResultVideo\TotalVideos\*.avi');
end
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
[x,~] = size(filenames);
if x > 0 
    ListImage = char(filenames(1));
else
    ListImage = '';
end
for i = 2:x
    ListImage = strcat(ListImage,'|',char(filenames(i)));
end
i = 1;
set(hObject,'String',ListImage);
set(hObject,'UserData',filenames);
set(hObject,'Value',i);


% ��ʾԴVideo�����б�.
function SourceVideoMenu_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject, handles.SourceVideoAxes, handles, 'left');
function SourceVideoMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);
% ��ʾĿ��Video�����б�.
function TargetVideoMenu_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject, handles.TargetVideoAxes, handles, 'right');
function TargetVideoMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);



%% ���ò��Ű�ť.
% ִ������Ƶ������ͣ.
function LeftPlay_Callback(hObject, eventdata, handles)
% global LeftFrameRunning;
% global leftOver;
% if( LeftFrameRunning == 0)
% global StatusBarHandle;
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.001);
ListName = get(handles.SourceVideoMenu, 'UserData');
CurrentVideo = char(ListName(get(handles.SourceVideoMenu, 'Value')));
if(ishandle(hObject) == 1)
    set(hObject,'string','| |')
end
PlayLeftVideoData(handles.SourceVideoAxes, hObject, handles, CurrentVideo);
if(ishandle(handles.LeftPlay) == 1)
    set(handles.LeftPlay,'string','Play')
end
if(ishandle(handles.VideoGrading) == 1)
    UIStatusSwitch(0, handles);
    set(handles.Render, 'Enable', 'on');
    set(handles.Stop, 'Enable', 'on');
end
% end
%PausePlay(hObject, handles.VideoGrading);
% if(leftOver == 1)
%     if(ishandle(hObject))
%         set(hObject,'string','>>')
%         LeftFrameRunning = 0;
%     else
%         return;
%     end
% end
% ִ���ҷ���Ƶ������ͣ.
function RightPlay_Callback(hObject, eventdata, handles)
% global RightFrameRunning;
% global rightOver;
% if( RightFrameRunning == 0)
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.001);
ListName = get(handles.TargetVideoMenu, 'UserData');
CurrentVideo = char(ListName(get(handles.TargetVideoMenu, 'Value')));
if(ishandle(hObject) == 1)
    set(hObject,'string','| |')
end
PlayRightVideoData(handles.TargetVideoAxes, hObject, handles, CurrentVideo);
if(ishandle(handles.RightPlay) == 1)
    set(handles.RightPlay,'string','Play')
end
if(ishandle(handles.VideoGrading) == 1)
    UIStatusSwitch(0, handles);
    set(handles.Render, 'Enable', 'on');
    set(handles.Stop, 'Enable', 'on');
end
% end
% PausePlay(hObject, handles.VideoGrading);
% if(rightOver == 1)
%     if(ishandle(hObject))
%         set(hObject,'string','>>')
%         RightFrameRunning = 0;
%     else
%         return;
%     end
% end


% % ��ʼ���������.
% function LeftVideoProgress_CreateFcn(hObject, eventdata, handles)
% set(hObject,...
%     'Units','Pixels',...
%     'XTick',[],'YTick',[]);
% xline = [100 0 0 100 100];
% yline = [0 0 1 1 0];
% line(xline,yline,'EraseMode','none','Color','k');
% % ��ʼ���ҽ�����.
% function RightVideoProgress_CreateFcn(hObject, eventdata, handles)
% set(hObject,...
%     'Units','Pixels',...
%     'XTick',[],'YTick',[]);
% xline = [100 0 0 100 100];
% yline = [0 0 1 1 0];
% line(xline,yline,'EraseMode','none','Color','k');


% %%�ر���Ƶ����.
% % �ر������Ƶ����.
% function CloseLeft_Callback(hObject, eventdata, handles)
% global LeftFrameRunning;
% LeftFrameRunning = 0;
% global leftOver;
% leftOver = 1;
% uiresume(handles.VideoGrading);
% cla(handles.LeftVideoProgress);
% axes(handles.LeftVideoProgress);
% set(handles.LeftVideoProgress,...
%     'Units','Pixels',...
%     'XTick',[],'YTick',[]);
% xline = [100 0 0 100 100];
% yline = [0 0 1 1 0];
% line(xline,yline,'EraseMode','none','Color','k');
% cla(handles.SourceVideoAxes);
% axes(handles.SourceVideoAxes);
% set(handles.SourceVideoAxes,...
%     'Units','Pixels',...
%     'XTick',[],'YTick',[]);
% set(handles.SourceVideoAxes, 'Visible', 'on');
% uiresume(handles.VideoGrading);
% �ر��Ҳ���Ƶ����.
% function CloseRight_Callback(hObject, eventdata, handles)
% global RightFrameRunning;
% RightFrameRunning = 0;
% global rightOver;
% rightOver = 1;
% uiresume(handles.VideoGrading);
% cla(handles.RightVideoProgress);
% axes(handles.RightVideoProgress);
% set(handles.RightVideoProgress,...
%     'Units','Pixels',...
%     'XTick',[],'YTick',[]);
% xline = [100 0 0 100 100];
% yline = [0 0 1 1 0];
% line(xline,yline,'EraseMode','none','Color','k');
% cla(handles.TargetVideoAxes);
% axes(handles.TargetVideoAxes);
% set(handles.TargetVideoAxes,...
%     'Units','Pixels',...
%     'XTick',[],'YTick',[]);
% set(handles.TargetVideoAxes, 'Visible', 'on');
% uiresume(handles.VideoGrading);


%% ��ȡ����Ƶ���еĹؼ�֡.
function LeftKeyFrames_Callback(hObject, eventdata, handles)
% ���ô����ڵ��ʹ��״̬.
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.5);
% ��ʼ��ȡ�ؼ�֡.
ListName = get(handles.SourceVideoMenu, 'UserData');
VideoName = char(ListName(get(handles.SourceVideoMenu, 'Value')));
LoadVideoData(strcat('Video\StartVideo\',VideoName), 'left');
ExtractKeyFrames(VideoName, 'left');
% �ָ������ڵ�ʹ��״̬.
UIStatusSwitch(0, handles);
set(handles.Render, 'Enable', 'on');
set(handles.Stop, 'Enable', 'on');

% ��ȡ����Ƶ�еĹؼ�֡.
function RightKeyFrames_Callback(hObject, eventdata, handles)
% ���ô����ڵ��ʹ��״̬.
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.5);
% ��ʼ��ȡ�ؼ�֡.
ListName = get(handles.TargetVideoMenu, 'UserData');
VideoName = char(ListName(get(handles.TargetVideoMenu, 'Value')));
LoadVideoData(strcat('Video\StartVideo\',VideoName), 'right');
ExtractKeyFrames(VideoName, 'right');
% �ָ������ڵ�ʹ��״̬.
UIStatusSwitch(0, handles);
set(handles.Render, 'Enable', 'on');
set(handles.Stop, 'Enable', 'on');


% %% ִ��ϵͳ��Դ�ͷ�.
% function LeftVideoProgress_DeleteFcn(hObject, eventdata, handles)
% global leftOver;
% leftOver = 1;
% uiresume(handles.VideoGrading);
% function SourceVideoAxes_DeleteFcn(hObject, eventdata, handles)
% global leftOver;
% leftOver = 1;
% uiresume(handles.VideoGrading);


%% ����RadioButton.
% ԴVideo���ť.
function SourceVideoButton_Callback(hObject, eventdata, handles)
SwitchSourceButton(handles,1);
% ԴVideoMatte���ť.
function SourceMatteButton_Callback(hObject, eventdata, handles)
SwitchSourceButton(handles,0);
% Ŀ��Video���ť.
function TargetVideoButton_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 1);
% Ŀ��VideoMatte���ť.
function TargetMatteButton_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 2);
% Ŀ��BackVideo���ť.
function BackVideo_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 3);
% Ŀ��BackMatte���ť.
function TargetBackMatte_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 4);
% Դ��Ƶ���л�.
function SwitchSourceButton(handles, CurButton)
if(CurButton == 1)
    set(handles.SourceMatteButton, 'Value', 0);
else
    set(handles.SourceVideoButton, 'Value', 0);
end
% Ŀ����Ƶ���л�.
function SwitchTargetButton(handles, CurButton)
if(CurButton == 1)
    set(handles.TargetMatteButton, 'Value', 0);
    set(handles.BackVideo, 'Value', 0);
    set(handles.TargetBackMatte, 'Value', 0);
elseif(CurButton  == 2)
    set(handles.TargetVideoButton, 'Value', 0);
    set(handles.BackVideo, 'Value', 0);
    set(handles.TargetBackMatte, 'Value', 0);
elseif(CurButton == 3)
    set(handles.TargetVideoButton, 'Value', 0);
    set(handles.TargetMatteButton, 'Value', 0);
    set(handles.TargetBackMatte, 'Value', 0);
else
    set(handles.TargetVideoButton, 'Value', 0);
    set(handles.TargetMatteButton, 'Value', 0);
    set(handles.BackVideo, 'Value', 0);
end
% ����Դ�ɰ濪��״̬.
function OpenSourceMatte_Callback(hObject, eventdata, handles)
global SourceMatteName;
global TargetBackVideoName;
global TargetBackMatteName;
if(get(hObject, 'Value') == 1)
    % ������Ⱦѡ��״̬.
    set(handles.SourceSyn, 'Enable', 'on');
    % ����RadioButton.
    set(handles.SourceMatteButton, 'Enable', 'on');
    % ������Ⱦ��״̬.
    set(handles.SourceMatte, 'Enable', 'on');
else
    % ������Ⱦѡ��״̬.
    set(handles.SourceSyn, 'Value', 0);
    set(handles.SourceSyn, 'Enable', 'off');
    set(handles.TargetSyn, 'Value', 0);
    set(handles.TargetSyn, 'Enable', 'off');
    set(handles.OpenBackGrading, 'Value', 0);
    set(handles.OpenBackGrading, 'Enable', 'off');
    set(handles.OpenTargetBackMatte, 'Value', 0);
    set(handles.OpenTargetBackMatte, 'Enable', 'off');
    % ����RadioButton.
    set(handles.SourceMatteButton, 'Enable', 'off');
    set(handles.SourceMatteButton, 'Value',0);
    set(handles.SourceVideoButton, 'Value', 1);
    set(handles.BackVideo, 'Enable', 'off');
    set(handles.BackVideo, 'Value', 0);
    set(handles.TargetBackMatte, 'Enable', 'off');
    set(handles.TargetBackMatte, 'Value', 0);
    if(get(handles.TargetVideoButton, 'Value') == 0 && get(handles.TargetMatteButton, 'Value') == 0)
        set(handles.TargetVideoButton, 'Value', 1);
    end
    % ���ÿ������״̬.
    set(handles.UpdateBackKeyframes, 'Enable', 'off');
    set(handles.UpdateBackKeyframes, 'Value', 0);
    set(handles.OpenBackMatteReverse, 'Enable', 'off');
    set(handles.OpenBackMatteReverse, 'Value', 0);
    % ������Ⱦ��״̬.
    set(handles.TargetBackTag, 'Enable', 'off');
    set(handles.TargetBackMatteTag, 'Enable','off');
    set(handles.SourceMatte, 'Enable', 'off');
    
    % ˢ��Դ��Ƶ����Ⱦ��.
    SourceMatteName = '';
    cla(handles.SourceMattePreview);
    axes(handles.SourceMattePreview);
    set(handles.SourceMattePreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.SourceMattePreview, 'Visible', 'on');
    TargetBackVideoName = '';
    cla(handles.TargetBackPreview);
    axes(handles.TargetBackPreview);
    set(handles.TargetBackPreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.TargetBackPreview, 'Visible', 'on');
    TargetBackMatteName = '';
    cla(handles.TargetBackMattePreview);
    axes(handles.TargetBackMattePreview);
    set(handles.TargetBackMattePreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.TargetBackMattePreview, 'Visible', 'on');
end
VideoStatusSwitch(handles);
    

% ����Դǰ�󱳾�ͬ��.
function SourceSyn_Callback(hObject, eventdata, handles)
global TargetBackVideoName;
global TargetBackMatteName;

if(get(hObject, 'Value') == 1)
    % ������Ⱦѡ��״̬.
    set(handles.TargetSyn, 'Value', 1);
    set(handles.TargetSyn, 'Enable', 'on');
    set(handles.OpenTargetForeMatte, 'Value', 1);
    set(handles.OpenTargetForeMatte, 'Enable', 'on');
    set(handles.OpenBackGrading, 'Value', 0);
    set(handles.OpenBackGrading, 'Enable', 'off');
    set(handles.OpenTargetBackMatte, 'Value', 0);
    set(handles.OpenTargetBackMatte, 'Enable', 'off');
    % ����RadioButton.
    set(handles.BackVideo, 'Enable', 'off');
    set(handles.BackVideo, 'Value', 0);
    set(handles.TargetBackMatte, 'Enable', 'off');
    set(handles.TargetBackMatte, 'Value', 0);
    set(handles.TargetMatteButton, 'Enable', 'on');
    if(get(handles.TargetVideoButton, 'Value') ==0 && get(handles.TargetMatteButton, 'Value') == 0)
        set(handles.TargetVideoButton, 'Value', 1);
    end
    % ���ÿ������.
    set(handles.UpdateBackKeyframes, 'Enable', 'off');
    set(handles.UpdateBackKeyframes, 'Value', 0);
    set(handles.OpenForeMatteReverse, 'Enable', 'on');
    set(handles.OpenBackMatteReverse, 'Enable', 'off');
    set(handles.OpenBackMatteReverse, 'Value', 0);
    % ������Ⱦ��״̬.
    set(handles.TargetBackTag, 'Enable', 'off');
    set(handles.TargetBackMatteTag, 'Enable', 'off');
else
    % ������Ⱦѡ��״̬.
    set(handles.TargetSyn, 'Value', 0);
    set(handles.TargetSyn, 'Enable', 'off');
    set(handles.OpenBackGrading, 'Value', 0);
    set(handles.OpenBackGrading, 'Enable', 'off');
    set(handles.OpenTargetBackMatte, 'Value', 0);
    set(handles.OpenTargetBackMatte, 'Enable', 'off');
    % ����RadioButton.
    set(handles.BackVideo, 'Enable', 'off');
    set(handles.BackVideo, 'Value', 0);
    set(handles.TargetBackMatte, 'Enable', 'off');
    set(handles.TargetBackMatte, 'Value', 0);
    if(get(handles.TargetVideoButton, 'Value') ==0 && get(handles.TargetMatteButton, 'Value') == 0)
        set(handles.TargetVideoButton, 'Value', 1);
    end
    % ���ÿ������.
    set(handles.UpdateBackKeyframes, 'Value', 0);
    set(handles.UpdateBackKeyframes, 'Enable', 'off');
    set(handles.OpenBackMatteReverse, 'Value', 0);
    set(handles.OpenBackMatteReverse,'Enable', 'off');
    % ������Ⱦ��״̬.
    set(handles.TargetBackTag, 'Enable', 'off');
    set(handles.TargetBackMatteTag, 'Enable', 'off');

    %ˢ��Ŀ����Ƶ����Ⱦ��.
    TargetBackVideoName = '';
    cla(handles.TargetBackPreview);
    axes(handles.TargetBackPreview);
    set(handles.TargetBackPreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.TargetBackPreview, 'Visible', 'on');
    TargetBackMatteName = '';
    cla(handles.TargetBackMattePreview);
    axes(handles.TargetBackMattePreview);
    set(handles.TargetBackMattePreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.TargetBackMattePreview, 'Visible', 'on');
end
VideoStatusSwitch(handles);

% ����Ŀ���ɰ濪��״̬.
function OpenTargetForeMatte_Callback(hObject, eventdata, handles)
global TargetForeMatteName;

if(get(hObject, 'Value') == 1)
    % ����RadioButton.
    set(handles.TargetMatteButton, 'Enable', 'on');
    % ���ÿ������.
    set(handles.OpenForeMatteReverse, 'Enable', 'on');
    % ������Ⱦ��״̬.
    set(handles.TargetForeMatte, 'Enable', 'on');
    % ���ÿ������.
    set(handles.OpenForeMatteReverse, 'Enable', 'on');
else
    % ������Ⱦ״̬ѡ��.
    set(handles.TargetSyn, 'Value', 0);
    if(get(handles.SourceSyn, 'Value') == 1)
        set(handles.OpenBackGrading, 'Enable', 'on');
        set(handles.OpenBackGrading, 'Value', 1);
        set(handles.OpenTargetBackMatte, 'Enable', 'on');
    end
    % ����RadioButton.
    if(get(handles.TargetMatteButton, 'Value') == 1)
        set(handles.TargetMatteButton, 'Value', 0);
        set(handles.TargetVideoButton, 'Value', 1);
    end
    set(handles.TargetMatteButton, 'Enable', 'off');
    set(handles.BackVideo, 'Enable', 'on');
    % ���ÿ������.
    set(handles.OpenForeMatteReverse, 'Enable', 'off');
    set(handles.OpenForeMatteReverse, 'Value', 0);
    set(handles.UpdateBackKeyframes, 'Enable', 'on');
    set(handles.UpdateBackKeyframes, 'Value', 1);
    % ������Ⱦ��״̬.
    set(handles.TargetForeMatte, 'Enable', 'off');
    
    % ˢ��Ŀ����Ƶ��״̬.
    TargetForeMatteName = '';
    cla(handles.TargetForeMattePreview);
    axes(handles.TargetForeMattePreview);
    set(handles.TargetForeMattePreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.TargetForeMattePreview, 'Visible', 'on');
end


% ����Ŀ��ǰ�󱳾�ͬ��.
function TargetSyn_Callback(hObject, eventdata, handles)
global SourceSynOpen;
global TargetBackVideoName;
global TargetBackMatteName;
SourceSynOpen = get(handles.SourceSyn, 'Value');

if(get(hObject, 'Value') == 1)
    if(SourceSynOpen == 1)
        % ������Ⱦѡ��״̬.
        set(handles.OpenTargetForeMatte, 'Value', 1);
        set(handles.OpenTargetForeMatte, 'Enable', 'on');
        set(handles.OpenBackGrading, 'Value', 0);
        set(handles.OpenBackGrading, 'Enable', 'off');
        set(handles.OpenTargetBackMatte, 'Value', 0);
        set(handles.OpenTargetBackMatte, 'Enable', 'off');
        % ����RadioButton.
        set(handles.BackVideo, 'Enable', 'off');
        set(handles.BackVideo, 'Value', 0);
        set(handles.TargetBackMatte, 'Enable', 'off');
        set(handles.TargetBackMatte, 'Value', 0);
        if(get(handles.TargetVideoButton,'Value') == 0 && get(handles.TargetMatteButton, 'Value') == 0)
            set(handles.TargetVideoButton, 'Value', 1);
        end
        % ���ÿ������.
        set(handles.UpdateBackKeyframes, 'Enable', 'off');
        set(handles.UpdateBackKeyframes, 'Value', 0);
        set(handles.OpenForeMatteReverse, 'Enable', 'on');
        set(handles.OpenBackMatteReverse, 'Enable', 'off');
        set(handles.OpenBackMatteReverse, 'Value', 0);
        % ������Ⱦ��״̬.
        set(handles.TargetForeMatte, 'Enable', 'on');
        set(handles.TargetBackTag, 'Enable', 'off');
        set(handles.TargetBackMatteTag, 'Enable', 'off');
      
        %ˢ��Ŀ����Ƶ����Ⱦ��.
        TargetBackVideoName = '';
        cla(handles.TargetBackPreview);
        axes(handles.TargetBackPreview);
        set(handles.TargetBackPreview,...
            'Units','Pixels',...
            'XTick',[],'YTick',[]);
        set(handles.TargetBackPreview, 'Visible', 'on');
        TargetBackMatteName = '';
        cla(handles.TargetBackMattePreview);
        axes(handles.TargetBackMattePreview);
        set(handles.TargetBackMattePreview,...
            'Units','Pixels',...
            'XTick',[],'YTick',[]);
        set(handles.TargetBackMattePreview, 'Visible', 'on');
    end
else
    if(SourceSynOpen == 1)
        % ������Ⱦѡ��״̬.
        set(handles.OpenBackGrading, 'Enable', 'on');
        set(handles.OpenBackGrading, 'Value', 1);
        set(handles.OpenTargetBackMatte, 'Enable', 'on');
        % ����RadioButton.
        set(handles.BackVideo, 'Enable', 'on');
        % ���ÿ������.
        set(handles.UpdateBackKeyframes, 'Enable','on');
        set(handles.UpdateBackKeyframes, 'Value', 1);
        % ������Ⱦ��״̬.
        set(handles.TargetBackTag, 'Enable', 'on');
    end
end


% ����Ŀ�걳���ɰ�.
function OpenBackGrading_Callback(hObject, eventdata, handles)
global TargetBackVideoName;
global TargetBackMatteName;
global SourceSynOpen;
SourceSynOpen = get(handles.SourceSyn, 'Value');
if(get(hObject, 'Value') == 1)
    if(SourceSynOpen == 1)
        % ������Ⱦѡ��״̬.
        set(handles.TargetSyn, 'Value', 0);
        set(handles.TargetSyn, 'Enable', 'off');
        set(handles.OpenTargetBackMatte, 'Enable', 'on');
        % ����RadioButton.
        set(handles.BackVideo, 'Enable', 'on');
        % ���ÿ������.
        set(handles.UpdateBackKeyframes, 'Enable', 'on');
        set(handles.UpdateBackKeyframes, 'Value', 1);
        % ������Ⱦ��״̬.
        set(handles.TargetBackTag, 'Enable', 'on');
    end
else
    if(SourceSynOpen == 1)
        % ������Ⱦѡ��״̬.
        set(handles.TargetSyn, 'Value', 1);
        set(handles.TargetSyn, 'Enable', 'on');
        set(handles.OpenTargetForeMatte, 'Value', 1);
        set(handles.OpenTargetForeMatte, 'Enable', 'on');
        set(handles.OpenBackGrading, 'Enable', 'off');
        set(handles.OpenTargetBackMatte, 'Value', 0);
        set(handles.OpenTargetBackMatte, 'Enable', 'off');
        % ����RadioButton.
        set(handles.BackVideo, 'Enable', 'off');
        set(handles.BackVideo, 'Value', 0);
        set(handles.TargetBackMatte, 'Enable', 'off');
        set(handles.TargetBackMatte, 'Value', 0);
        set(handles.TargetMatteButton, 'Enable', 'on');
        if(get(handles.TargetVideoButton, 'Value') ==0 && get(handles.TargetMatteButton, 'Value') == 0)
            set(handles.TargetVideoButton, 'Value', 1);
        end
        % ���ÿ������.
        set(handles.UpdateBackKeyframes, 'Enable', 'off');
        set(handles.UpdateBackKeyframes, 'Value', 0);
        set(handles.OpenBackMatteReverse, 'Enable', 'off');
        set(handles.OpenBackMatteReverse, 'Value', 0);
        % ������Ⱦ��״̬.
        set(handles.TargetBackTag, 'Enable', 'off');
        set(handles.TargetBackMatteTag, 'Enable', 'off');
        
        %ˢ��Ŀ����Ƶ����Ⱦ��.
        TargetBackVideoName = '';
        cla(handles.TargetBackPreview);
        axes(handles.TargetBackPreview);
        set(handles.TargetBackPreview,...
            'Units','Pixels',...
            'XTick',[],'YTick',[]);
        set(handles.TargetBackPreview, 'Visible', 'on');
        TargetBackMatteName = '';
        cla(handles.TargetBackMattePreview);
        axes(handles.TargetBackMattePreview);
        set(handles.TargetBackMattePreview,...
            'Units','Pixels',...
            'XTick',[],'YTick',[]);
        set(handles.TargetBackMattePreview, 'Visible', 'on');
    end
end


% ����BackMatte��Ƶ����������.
function OpenTargetBackMatte_Callback(hObject, eventdata, handles)
global TargetBackMatteName;
if(get(handles.OpenTargetBackMatte, 'Value') == 1)
    % ����RadioButton.
    set(handles.TargetBackMatte, 'Enable', 'on');
    % ���ÿ������.
    set(handles.OpenBackMatteReverse, 'Enable','on');
    set(handles.OpenBackMatteReverse, 'Value', 0);
    % ������Ⱦ��״̬.
    set(handles.TargetBackMatteTag, 'Enable', 'on');
else
    % ����RadioButton.
    set(handles.TargetBackMatte, 'Enable', 'off');
    if(get(handles.TargetBackMatte, 'Value') == 1)
        set(handles.TargetBackMatte, 'Value', 0);
        set(handles.TargetVideoButton, 'Value', 1);
    end
    % ���ÿ������.
    set(handles.OpenBackMatteReverse, 'Enable','off');
    set(handles.OpenBackMatteReverse, 'Value', 0);
    % ������Ⱦ��״̬.
    set(handles.TargetBackMatteTag, 'Enable', 'off');
    
    % ˢ��Ŀ����Ƶ����Ⱦ��.
    TargetBackMatteName = '';
    cla(handles.TargetBackMattePreview);
    axes(handles.TargetBackMattePreview);
    set(handles.TargetBackMattePreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.TargetBackMattePreview, 'Visible', 'on');
end


%% ����Ⱦ���������Ƶ��.
% ����ߵ�ԭ��Ƶ����ӵ���Ⱦ����.
function LeftAddVideoButton_Callback(hObject, eventdata, handles)
global SourceVideoName;
global SourceMatteName;
global SourceImageName;
global SourceMatteImageName;
if(strcmp(get(handles.SwitchButton, 'String'),'SwitchImage'))
    ListName = get(handles.SourceVideoMenu, 'UserData');
    CurrentVideo = char(ListName(get(handles.SourceVideoMenu,'Value')));
    VideoMedia = VideoReader(strcat('Video\StartVideo\',CurrentVideo));
    videoHeight = VideoMedia.Height;
    videoWidth = VideoMedia.Width;
    AxesHandle = handles.SourceVideoAxes;
    Position = get(AxesHandle,'Position');
    AxesWidth = floor(Position(3));
    AxesHeight = floor(Position(4));
    mov = struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));
    h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
    h2 = floor(AxesWidth * videoHeight / videoWidth);
    P = read(VideoMedia, 1);
    mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
    if(get(handles.SourceVideoButton, 'Value') == 1)
        SourceVideoName = CurrentVideo;
        axes(handles.SourcePreview);
        imshow(mov.cdata);
    else
        SourceMatteName = CurrentVideo;
        axes(handles.SourceMattePreview);
        imshow(mov.cdata);
    end
else
    ListName = get(handles.SourceVideoMenu, 'UserData');
    CurrentImage = char(ListName(get(handles.SourceVideoMenu,'Value')));
    P = imread(char(strcat('Images\',CurrentImage)));
    [x,y,~] = size(P);
    AxesHandle = handles.SourceVideoAxes;
    Position = get(AxesHandle,'Position');
    AxesWidth = floor(Position(3));
    AxesHeight = floor(Position(4));
    mov = struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));
     if(x/y < AxesHeight/AxesWidth)
        h1 = floor((AxesHeight - floor(AxesWidth * x / y))/2);
        h2 = floor(AxesWidth * x / y);
        mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
    else
        w1 = floor((AxesWidth - floor(AxesHeight*y/x))/2);
        w2 = floor(AxesHeight * y / x);
        mov.cdata(:,w1 : w1 + w2 - 1, :) = imresize(P,[AxesHeight, w2]);
    end
    if(get(handles.SourceVideoButton, 'Value') == 1)
        SourceImageName = CurrentImage;
        axes(handles.SourcePreview);
        imshow(mov.cdata);
    else
        SourceMatteImageName = CurrentImage;
        axes(handles.SourceMattePreview);
        imshow(mov.cdata);
    end
end
axes(AxesHandle);
imshow(mov.cdata);

% ���ұߵ�ԭ��Ƶ����ӵ���Ⱦ����.
function RightAddVideoButton_Callback(hObject, eventdata, handles)
global TargetForeVideoName;
global TargetForeMatteName;
global TargetBackVideoName;
global TargetBackMatteName;
global TargetForeImageName;
global TargetForeImageMatteName;
global TargetBackImageName;
global TargetBackImageMatteName;
if(strcmp(get(handles.SwitchButton, 'String'),'SwitchImage'))
    ListName = get(handles.TargetVideoMenu, 'UserData');
    CurrentVideo = char(ListName(get(handles.TargetVideoMenu,'Value')));
    VideoMedia = VideoReader(strcat('Video\StartVideo\',CurrentVideo));
    videoHeight = VideoMedia.Height;
    videoWidth = VideoMedia.Width;
    AxesHandle = handles.TargetVideoAxes;
    Position = get(AxesHandle,'Position');
    AxesWidth = floor(Position(3));
    AxesHeight = floor(Position(4));
    mov = struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));
    P = read(VideoMedia, 1);
     if(videoHeight/videoWidth < AxesHeight/AxesWidth)
        h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
        h2 = floor(AxesWidth * videoHeight/videoWidth);
        mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
    else
        w1 = floor((AxesWidth - floor(AxesHeight* videoWidth / videoHeight))/2);
        w2 = floor(AxesHeight * videoWidth / videoHeight);
        mov.cdata(:,w1 : w1 + w2 - 1, :) = imresize(P,[AxesHeight, w2]);
    end
    if(get(handles.TargetVideoButton, 'Value') == 1)
        TargetForeVideoName = CurrentVideo;
        axes(handles.TargetForePreview);
        imshow(mov.cdata);
    elseif(get(handles.TargetMatteButton, 'Value') == 1)
        TargetForeMatteName = CurrentVideo;
        axes(handles.TargetForeMattePreview);
        imshow(mov.cdata);
    elseif(get(handles.BackVideo, 'Value') == 1)
        TargetBackVideoName = CurrentVideo;
        axes(handles.TargetBackPreview);
        imshow(mov.cdata);
    else
        TargetBackMatteName = CurrentVideo;
        axes(handles.TargetBackMattePreview);
        imshow(mov.cdata);
    end
else
    ListName = get(handles.TargetVideoMenu, 'UserData');
    CurrentImage = char(ListName(get(handles.TargetVideoMenu,'Value')));
    P = imread(char(strcat('Images\',CurrentImage)));
    [x,y,~] = size(P);
    AxesHandle = handles.TargetVideoAxes;
    Position = get(AxesHandle,'Position');
    AxesWidth = floor(Position(3));
    AxesHeight = floor(Position(4));
    mov = struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));
    if(x/y < AxesHeight/AxesWidth)
        h1 = floor((AxesHeight - floor(AxesWidth * x / y))/2);
        h2 = floor(AxesWidth * x / y);
        mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
    else
        w1 = floor((AxesWidth - floor(AxesHeight*y/x))/2);
        w2 = floor(AxesHeight * y / x);
        mov.cdata(:,w1 : w1 + w2 - 1, :) = imresize(P,[AxesHeight, w2]);
    end
    if(get(handles.TargetVideoButton, 'Value') == 1)
        TargetForeImageName = CurrentImage;
        axes(handles.TargetForePreview);
        imshow(mov.cdata);
    elseif(get(handles.TargetMatteButton, 'Value') == 1)
        TargetForeImageMatteName = CurrentImage;
        axes(handles.TargetForeMattePreview);
        imshow(mov.cdata);
    elseif(get(handles.BackVideo, 'Value') == 1)
        TargetBackImageName = CurrentImage;
        axes(handles.TargetBackPreview);
        imshow(mov.cdata);
    else
        TargetBackImageMatteName = CurrentImage;
        axes(handles.TargetBackMattePreview);
        imshow(mov.cdata);
    end
end
axes(AxesHandle);
imshow(mov.cdata);


% ������Ƶ����Ⱦ.
function Render_Callback(hObject, eventdata, handles)
global rendering;
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
global TargetBackGradingOpen;
global OpenFilter;
global OpenUpdateForeKeyFrames;
global OpenUpdateBackKeyFrames;
global OpenForeMatteReverseSwitch;
global OpenBackMatteReverseSwitch;
set(handles.ShowResult, 'String','ShowResult');
if(rendering == 0)
    rendering = 1;
    UIStatusSwitch(1, handles);
    set(handles.Render, 'Enable', 'off');
    pause(0.1);
    % ��ʼ����Ⱦ״̬����.
    OpenForeMatteReverseSwitch = get(handles.OpenForeMatteReverse, 'Value');
    OpenBackMatteReverseSwitch = get(handles.OpenBackMatteReverse, 'Value');
    OpenUpdateForeKeyFrames = get(handles.UpdateForeKeyframes, 'Value');
    OpenUpdateBackKeyFrames = get(handles.UpdateBackKeyframes, 'Value');
    OpenFilter = get(handles.OpenFilter, 'Value');
    SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
    SourceSynOpen = get(handles.SourceSyn, 'Value');
    TargetBackGradingOpen = get(handles.OpenBackGrading, 'Value');
    TargetForeMatteOpen = get(handles.OpenTargetForeMatte, 'Value');
    TargetBackMatteOpen = get(handles.OpenTargetBackMatte, 'Value');
    TargetSynOpen = get(handles.TargetSyn, 'Value');
    GetAllVideoOutputStatus(handles);
    if(strcmp(get(handles.SwitchButton,'String'),'SwitchImage') == 1)
        ColorTransferWithinVideo();
    else
        ColorTransferWitinImage();
    end
    UIStatusSwitch(0, handles);
    set(handles.Render, 'Enable', 'on');
    rendering = 0;
end

% ��ֹ��Ƶ����Ⱦ.
function Stop_Callback(hObject, eventdata, handles)
global rendering;
global stopRendering;
stopRendering = 1;
if(rendering == 1)
   rendering = 0;
   UIStatusSwitch(0, handles);
   set(handles.Render, 'Enable', 'on');
end
UIStatusSwitch(0, handles);
set(handles.Render, 'Enable', 'on');

function UpdateForeKeyframes_Callback(hObject, eventdata, handles)
function UpdateBackKeyframes_Callback(hObject, eventdata, handles)

function OpenForeMatteReverse_Callback(hObject, eventdata, handles)
function OpenBackMatteReverse_Callback(hObject, eventdata, handles)
function OpenFilter_Callback(hObject, eventdata, handles)

% ��SourceVideoĿ¼.
function OutputSourceVideo_Callback(hObject, eventdata, handles)
function SouceVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SourceVideo');
function SourceVideoSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SourceVideoSlices');

% ��SourceForeVideoĿ¼.
function OutputSourceForeVideo_Callback(hObject, eventdata, handles)
function SouceForeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SourceForeVideo');
function SouceForeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SouceForeVideoSlices');

% ��SourceBackVideoĿ¼.
function OutputSourceBackVideo_Callback(hObject, eventdata, handles)
function SouceBackVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SourceBackVideo');
function SouceBackVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SouceBackVideoSlices');

% ��LuminaVideoĿ¼.
function OutputLuminaVideo_Callback(hObject, eventdata, handles)
function LuminaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\LuminaVideo');
function LuminaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\LuminaVideoSlices');

% ��ChrominaVideoĿ¼.
function OutputChrominaVideo_Callback(hObject, eventdata, handles)
function ChrominaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ChrominaVideo');
function ChrominaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ChrominaVideoSlices');

% ��SyncVideoĿ¼.
function OutputSyncVideo_Callback(hObject, eventdata, handles)
function SyncVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SyncVideo');
function SyncVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SyncVideoSlices');

% ��ForeLuminaVideoĿ¼.
function OutputForeLuminaVideo_Callback(hObject, eventdata, handles)
function ForeLuminaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeLuminaVideo');
function ForeLuminaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeLuminaVideoSlices');

% ��ForeChrominaVideoĿ¼.
function OutputForeChrominaVideo_Callback(hObject, eventdata, handles)
function ForeChrominaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeChrominaVideo');
function ForeChrominaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeChrominaVideoSlices');

% ��ForeSyncVideoĿ¼.
function OutputForeSyncVideo_Callback(hObject, eventdata, handles)
function ForeSyncVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeSyncVideo');
function ForeSyncVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeSyncVideoSlices');

% ��BackLuminaVideoĿ¼.
function OutputBackLuminaVideo_Callback(hObject, eventdata, handles)
function BackLuminaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackLuminaVideo');
function BackLuminaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackLuminaVideoSlices');

% ��BackChrominaVideoĿ¼.
function OutputBackChrominaVideo_Callback(hObject, eventdata, handles)
function BackChrominaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackChrominaVideo');
function BackChrominaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackChrominaVideoSlices');

% ��BackSyncVideoĿ¼.
function OutputBackSyncVideo_Callback(hObject, eventdata, handles)
function BackSyncVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackSyncVideo');
function BackSyncVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackSyncVideoSlices');

% ��ForeLumWholeVideoĿ¼.
function OutputForeLumWholeVideo_Callback(hObject, eventdata, handles)
function ForeLumiWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeLumiWholeVideo');
function ForeLumiWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeLumiWholeVideoSlices');

% ��ForeChroWholeVideoĿ¼.
function OutputForeChroWholeVideo_Callback(hObject, eventdata, handles)
function ForeChrominaWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeChrominaWholeVideo');
function ForeChrominaWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeChrominaWholeVideoSlices');

% ��ForeSyncWholeVideoĿ¼.
function OutputForeSyncWholeVideo_Callback(hObject, eventdata, handles)
function ForeSyncWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeSyncWholeVideo');
function ForeSyncWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeSyncWholeVideoSlices');

% ��BackLumWholeVideoĿ¼.
function OutputBackLumWholeVideo_Callback(hObject, eventdata, handles)
function BackLuminaWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackLuminaWholeVideo');
function BackLuminaWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackLuminaWholeVideoSlices');

% ��BackChroWholeVideoĿ¼.
function OutputBackChroWholeVideo_Callback(hObject, eventdata, handles)
function BackChrominaWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackChrominaWholeVideo');
function BackChrominaWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackChrominaWholeVideoSlices');

% ��BackSyncWholeVideoĿ¼.
function OutputBackSyncWholeVideo_Callback(hObject, eventdata, handles)
function BackSyncWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackSyncWholeVideo');
function BackSyncWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackSyncWholeVideoSlices');


% ��Ŀ����Ƶǰ���ؼ�֡Ŀ¼.
function TargetForeKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetForeKeyFrames');
% ��Ŀ����Ƶǰ������Ŀ¼.
function TargetForeSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetForeSlices');
% ��Ŀ����Ƶǰ���ɰ�ؼ�֡Ŀ¼.
function TargetForeMatteKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetForeMatteKeyFrames');
% ��Ŀ����Ƶǰ���ɰ�����Ŀ¼.
function TargetForeMatteSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetForeMatteSlices');
% ��Ŀ����Ƶ��������Ŀ¼.
function TargetBackKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetBackKeyFrames');
% ��Ŀ����Ƶ��������Ŀ¼.
function TargetBackSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetBackSlices');
% ��Ŀ����Ƶ�������ɰ�ؼ�֡Ŀ¼.
function TargetBackMatteKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetBackMatteKeyFrames');
% ��Ŀ����Ƶ�����ɰ�����Ŀ¼.
function TargetBackMatteSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetBackMatteSlices');
% ������Ƶ�ؼ�֡Ŀ¼.
function LeftKeyframeDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/LeftKeyFrames');
% ������Ƶ֡����Ŀ¼.
function LeftVideoSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/LeftSlices');
% ������Ƶ�ؼ�֡Ŀ¼..
function RightKeyframeDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/RightKeyFrames');
% ������Ƶ֡����Ŀ¼.
function RightVideoSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/RightSlices');


% ����Ƶ���ڴ���.
function SourceVideoAxes_CreateFcn(hObject, eventdata, handles)
global LeftAxisHandle;
LeftAxisHandle = hObject;
% ����Ƶ���ڴ���.
function TargetVideoAxes_CreateFcn(hObject, eventdata, handles)
global RightAxisHandle;
RightAxisHandle = hObject;


% Video����������.
function RebuildVideo_Callback(hObject, eventdata, handles)
function RebuildVideo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);


% �ָ���Ƶ.
function SplitVideo_Callback(hObject, eventdata, handles)
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.001);
ListName = get(handles.RebuildVideo,'UserData');
CurrentVideo = char(ListName(get(handles.RebuildVideo,'Value')));
delete VideoSlices\VideoSplitSlices\*.jpg;
LoadVideoData(strcat('Video\StartVideo\',CurrentVideo), 'split');
UIStatusSwitch(0, handles);
set(handles.Render, 'Enable', 'on');
set(handles.Stop, 'Enable', 'on');

% ������Ƶ.
function Recombine_Callback(hObject, eventdata, handles)
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.001);
ImagesDir = 'VideoSlices\VideoSplitSlices\';
VideoDir = 'Video\ResultVideo\RecombineVideo\';
delete(strcat(VideoDir,'*.mp4'));
ListName = get(handles.RebuildVideo,'UserData');
CurrentVideo = char(ListName(get(handles.RebuildVideo,'Value')));
VideoName = CurrentVideo(1:end - 4);
SaveImagesToVideo(ImagesDir, VideoName, VideoDir);
UIStatusSwitch(0, handles);
set(handles.Render, 'Enable', 'on');
set(handles.Stop, 'Enable', 'on');

function VideoSplitDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices\VideoSplitSlices');
function VideoRecombineDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\RecombineVideo');


% �����ں˷���.
function MethodSwitch(methodName, handles)
global CoreMethodName;
if strcmp(methodName, 'ColorGrading') == 1
    set(handles.ReinhardMethod, 'Value', 0);
    CoreMethodName = 'ColorGradingMethod';
elseif strcmp(methodName, 'Reinhard') == 1
    set(handles.ColorGradingMethod, 'Value', 0);
    CoreMethodName = 'ReinhardMethod';
end
function ColorGradingMethod_Callback(hObject, eventdata, handles)
MethodSwitch('ColorGrading',handles);
function ReinhardMethod_Callback(hObject, eventdata, handles)
MethodSwitch('Reinhard',handles);

function SwitchButton_Callback(hObject, eventdata, handles)
global StatusBarHandle;
StatusBarHandle = handles.StatusWindow;
global ImageStatus;
set(handles.ShowResult,'String','ShowResult');
if(strcmp(get(hObject,'String'), 'SwitchImage') == 1)
    set(hObject, 'String', 'SwitchVideo');
    set(handles.SourceVideoButton, 'String', 'SourceImage');
    set(handles.TargetVideoButton, 'String', 'TargetImage');
    FillPopMenuImageData(handles.SourceVideoMenu);
    FillPopMenuImageData(handles.TargetVideoMenu);
    SwitchSaveNames(handles, 0);
    ClearListBox(StatusBarHandle);
    FillPreviewWindow(handles.SourceVideoMenu, handles.SourceVideoAxes, handles, 'left');
    FillPreviewWindow(handles.TargetVideoMenu, handles.TargetVideoAxes, handles, 'right');
    set(handles.LeftPlay,'Enable','off');
    set(handles.RightPlay,'Enable','off');
    ImageStatus = 1;
else
    set(hObject, 'String', 'SwitchImage');
    set(handles.SourceVideoButton, 'String', 'SourceVideo');
    set(handles.TargetVideoButton, 'String', 'TargetVideo');
    FillPopMemuData(handles.SourceVideoMenu);
    FillPopMemuData(handles.TargetVideoMenu);
    SwitchSaveNames(handles, 1);
    ClearListBox(StatusBarHandle);
    FillPreviewWindow(handles.SourceVideoMenu, handles.SourceVideoAxes, handles, 'left');
    FillPreviewWindow(handles.TargetVideoMenu, handles.TargetVideoAxes, handles, 'right');
    set(handles.LeftPlay,'Enable','on');
    set(handles.RightPlay,'Enable','on');
    ImageStatus = 0;
end


% ��ʾ���ս��.
function ShowResult_Callback(hObject, eventdata, handles)
global ShowResulting;
if(strcmp(get(hObject,'String'), 'ShowResult') == 1)
    set(hObject,'String','RESET');
    if(strcmp(get(handles.SwitchButton,'String'), 'SwitchImage') == 1)
        FillPopMenuResultData(handles.SourceVideoMenu, 0);
        FillPopMenuResultData(handles.TargetVideoMenu, 0);
    else
        FillPopMenuResultData(handles.SourceVideoMenu, 1);
        FillPopMenuResultData(handles.TargetVideoMenu, 1);
    end
    ShowResulting = 1;
else
    set(hObject,'String','ShowResult');
    if(strcmp(get(handles.SwitchButton,'String'), 'SwitchImage') == 1)
        FillPopMemuData(handles.SourceVideoMenu);
        FillPopMemuData(handles.TargetVideoMenu);
    else
        FillPopMenuImageData(handles.SourceVideoMenu);
        FillPopMenuImageData(handles.TargetVideoMenu);
    end
    ShowResulting = 0;
end
