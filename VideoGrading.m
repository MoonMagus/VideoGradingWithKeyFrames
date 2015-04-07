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
global LeftFrameRunning;
global leftOver;
global RightFrameRunning;
global rightOver;
function VideoGrading_OpeningFcn(hObject, eventdata, handles, varargin)
global LeftFrameRunning;
LeftFrameRunning = 0;
global leftOver;
leftOver = 0;
global RightFrameRunning;
RightFrameRunning = 0;
global rightOver;
rightOver = 0;
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


% ����״̬��Ϣ����.
function StatusWindow_Callback(hObject, eventdata, handles)
function StatusWindow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ������.
function ProgressbarAxes_CreateFcn(hObject, eventdata, handles)
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');


%% ���Ԥ�����ں������˵�.
% ���Ԥ������.
function FillPreviewWindow(hObject, AxesHandle, handles, curPopMenu)
global leftOver;
global LeftFrameRunning;
global rightOver;
global RightFrameRunning;
%���������Ƶ��ǩ.
if(ishandle(AxesHandle) == 1)
    if(1 == strcmp(curPopMenu, 'left'))
        leftOver = 0; 
        LeftFrameRunning = 0;
    else
        rightOver = 0;
        RightFrameRunning = 0;
    end
end
set(handles.LeftPlay, 'string','>>')
ListName = get(hObject,'UserData');
CurrentVideo = char(ListName(get(hObject,'Value')));
VideoMedia = VideoReader(strcat('Video\',CurrentVideo));
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;
Position = get(AxesHandle,'Position');
AxesWidth = floor(Position(3));
AxesHeight = floor(Position(4));
mov = struct('cdata', zeros(AxesHeight, AxesWidth, 3, 'uint8'));
h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
h2 = floor(AxesWidth * videoHeight / videoWidth);
P = read(VideoMedia, 1);
mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
axes(AxesHandle);
imshow(mov.cdata);
% ��ȡPopMenu�µ�����.
function FillPopMemuData(hObject, VideoName)
dirs1 = dir('Video\*.mp4');
dirs2 = dir('Video\*.avi');
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
if(get(hObject, 'Value') == 1)
    set(handles.SourceMatteButton, 'Enable', 'on');
else
    set(handles.SourceMatteButton, 'Enable', 'off');
    set(handles.SourceMatteButton, 'Value', 0);
    set(handles.SourceVideoButton, 'Value', 1);
end
% ����Ŀ���ɰ濪��״̬.
function OpenTargetMatte_Callback(hObject, eventdata, handles)
if(get(hObject, 'Value') == 1)
    set(handles.TargetMatteButton, 'Enable', 'on');
    set(handles.OpenBackMatte, 'Enable', 'on');
else
    set(handles.TargetMatteButton, 'Enable', 'off');
    set(handles.TargetMatteButton, 'Value', 0);
    set(handles.TargetVideoButton, 'Value', 1);
    set(handles.TargetBackMatte, 'Enable', 'off');
    set(handles.TargetBackMatte, 'Value', 0);
    set(handles.BackVideo, 'Enable', 'off');
    set(handles.BackVideo, 'Value', 0);
    set(handles.OpenBackMatte, 'Enable', 'off');
    set(handles.OpenBackMatte, 'Value', 0);
end
% ����Ŀ�걳���ɰ�.
function OpenBackMatte_Callback(hObject, eventdata, handles)
if(get(hObject, 'Value') == 1)
    set(handles.TargetBackMatte, 'Enable', 'on');
    set(handles.BackVideo, 'Enable', 'on');
else
    set(handles.TargetBackMatte, 'Enable', 'off');
    set(handles.BackVideo, 'Enable', 'off');
    set(handles.BackVideo, 'Value', 0);
    set(handles.TargetBackMatte, 'Value', 0);
    set(handles.TargetMatteButton, 'Value', 1);
    set(handles.TargetVideoButton, 'Value', 0);
end


%% ���ò��Ű�ť.
% ִ������Ƶ������ͣ.
function LeftPlay_Callback(hObject, eventdata, handles)
global LeftFrameRunning;
global leftOver;
if( LeftFrameRunning == 0)
    ListName = get(handles.SourceVideoMenu, 'UserData');
    CurrentVideo = char(ListName(get(handles.SourceVideoMenu, 'Value')));
    set(hObject,'string','| |')
    PlayLeftVideoData(handles.SourceVideoAxes, hObject, handles, CurrentVideo);
end
PausePlay(hObject, handles.VideoGrading);
if(leftOver == 1)
    if(ishandle(hObject))
        set(hObject,'string','>>')
        LeftFrameRunning = 0;
    else
        return;
    end
end
% ִ���ҷ���Ƶ������ͣ.
function RightPlay_Callback(hObject, eventdata, handles)
global RightFrameRunning;
global rightOver;
if( RightFrameRunning == 0)
    ListName = get(handles.TargetVideoMenu, 'UserData');
    CurrentVideo = char(ListName(get(handles.TargetVideoMenu, 'Value')));
    set(hObject,'string','| |')
    PlayRightVideoData(handles.TargetVideoAxes, hObject, handles, CurrentVideo);
end
PausePlay(hObject, handles.VideoGrading);
if(rightOver == 1)
    if(ishandle(hObject))
        set(hObject,'string','>>')
        RightFrameRunning = 0;
    else
        return;
    end
end


% ��ʼ���������.
function LeftVideoProgress_CreateFcn(hObject, eventdata, handles)
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');
% ��ʼ���ҽ�����.
function RightVideoProgress_CreateFcn(hObject, eventdata, handles)
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');


%%�ر���Ƶ����.
% �ر������Ƶ����.
function CloseLeft_Callback(hObject, eventdata, handles)
global LeftFrameRunning;
LeftFrameRunning = 0;
global leftOver;
leftOver = 1;
uiresume(handles.VideoGrading);
cla(handles.LeftVideoProgress);
axes(handles.LeftVideoProgress);
set(handles.LeftVideoProgress,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');
cla(handles.SourceVideoAxes);
axes(handles.SourceVideoAxes);
set(handles.SourceVideoAxes,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.SourceVideoAxes, 'Visible', 'on');
uiresume(handles.VideoGrading);
% �ر��Ҳ���Ƶ����.
function CloseRight_Callback(hObject, eventdata, handles)
global RightFrameRunning;
RightFrameRunning = 0;
global rightOver;
rightOver = 1;
uiresume(handles.VideoGrading);
cla(handles.RightVideoProgress);
axes(handles.RightVideoProgress);
set(handles.RightVideoProgress,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');
cla(handles.TargetVideoAxes);
axes(handles.TargetVideoAxes);
set(handles.TargetVideoAxes,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetVideoAxes, 'Visible', 'on');
uiresume(handles.VideoGrading);


%% ��ȡ����Ƶ���еĹؼ�֡.
function LeftKeyFrames_Callback(hObject, eventdata, handles)
ListName = get(handles.SourceVideoMenu, 'UserData');
VideoName = char(ListName(get(handles.SourceVideoMenu, 'Value')));
LoadVideoData(VideoName);
ExtractKeyFrames(VideoName);
% ��ȡ����Ƶ�еĹؼ�֡.
function RightKeyFrames_Callback(hObject, eventdata, handles)
ListName = get(handles.TargetVideoMenu, 'UserData');
VideoName = char(ListName(get(handles.TargetVideoMenu, 'Value')));
LoadVideoData(VideoName);
ExtractKeyFrames(VideoName);


% ִ��ϵͳ��Դ�ͷ�.
function LeftVideoProgress_DeleteFcn(hObject, eventdata, handles)
global leftOver;
leftOver = 1;
uiresume(handles.VideoGrading);
function SourceVideoAxes_DeleteFcn(hObject, eventdata, handles)
global leftOver;
leftOver = 1;
uiresume(handles.VideoGrading);
