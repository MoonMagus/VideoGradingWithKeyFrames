function varargout = VideoGrading(varargin)
%%-----------------------------------------------------------------------  
% ColorGrading.
% Author: 冯亚男
% CreateTime: 2015-01-29 
%%------------------------------------------------------------------------  
%% 初始化代码,请勿编辑.
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
% 结束初始化.


%% 在ColorGrading可视化之前执行.
global LeftFrameRunning;
global leftOver;
global RightFrameRunning;
global rightOver;
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
global ForeStruct;
global BackStruct;
global ResultStruct;
global UiStatus;
global VOStatus;
global BackMatteHasBeenAdd;
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
function VideoGrading_OpeningFcn(hObject, eventdata, handles, varargin)
global LeftFrameRunning;
LeftFrameRunning = 0;
global leftOver;
leftOver = 0;
global RightFrameRunning;
RightFrameRunning = 0;
global rightOver;
rightOver = 0;
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
handles.output = hObject;
guidata(hObject, handles);
InitialAxes(handles);


%% 将输出返回到命令行.
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



% 进度状态信息窗口.
function StatusWindow_Callback(hObject, eventdata, handles)
function StatusWindow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global StatusBarHandle;
StatusBarHandle = hObject;


% 进度条.
function ProgressbarAxes_CreateFcn(hObject, eventdata, handles)
global StatusProgressBarHandle;
StatusProgressBarHandle = hObject;
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');


%% 填充预览窗口和下拉菜单.
% 填充预览窗口.
function FillPreviewWindow(hObject, AxesHandle, handles, curPopMenu)
global leftOver;
global LeftFrameRunning;
global rightOver;
global RightFrameRunning;
%获得左右视频标签.
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
VideoMedia = VideoReader(strcat('Video\StartVideo\',CurrentVideo));
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;
nFrames = VideoMedia.NumberOfFrames;
if(1 == strcmp(curPopMenu, 'left'))
    set(handles.LeftFrameNum, 'string',strcat('共',num2str(nFrames),'帧'));
else
    set(handles.RightFrameNum, 'string',strcat('共',num2str(nFrames),'帧'));
end
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
% 拉取PopMenu下的内容.
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


% 显示源Video下拉列表.
function SourceVideoMenu_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject, handles.SourceVideoAxes, handles, 'left');
function SourceVideoMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);
% 显示目标Video下拉列表.
function TargetVideoMenu_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject, handles.TargetVideoAxes, handles, 'right');
function TargetVideoMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);





%% 设置播放按钮.
% 执行左方视频播放暂停.
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
% 执行右方视频播放暂停.
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


% 初始化左进度条.
function LeftVideoProgress_CreateFcn(hObject, eventdata, handles)
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');
% 初始化右进度条.
function RightVideoProgress_CreateFcn(hObject, eventdata, handles)
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');


%%关闭视频窗口.
% 关闭左侧视频窗口.
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
% 关闭右侧视频窗口.
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


%% 提取左视频流中的关键帧.
function LeftKeyFrames_Callback(hObject, eventdata, handles)
% 设置触发节点非使能状态.
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.5);
% 开始提取关键帧.
ListName = get(handles.SourceVideoMenu, 'UserData');
VideoName = char(ListName(get(handles.SourceVideoMenu, 'Value')));
LoadVideoData(strcat('Video\StartVideo\',VideoName), 'left');
ExtractKeyFrames(VideoName, 'left');
% 恢复触发节点使能状态.
UIStatusSwitch(0, handles);
set(handles.Render, 'Enable', 'on');
set(handles.Stop, 'Enable', 'on');

% 提取右视频中的关键帧.
function RightKeyFrames_Callback(hObject, eventdata, handles)
% 设置触发节点非使能状态.
UIStatusSwitch(1, handles);
set(handles.Render, 'Enable', 'off');
set(handles.Stop, 'Enable', 'off');
pause(0.5);
% 开始提取关键帧.
ListName = get(handles.TargetVideoMenu, 'UserData');
VideoName = char(ListName(get(handles.TargetVideoMenu, 'Value')));
LoadVideoData(strcat('Video\StartVideo\',VideoName), 'right');
ExtractKeyFrames(VideoName, 'right');
% 恢复触发节点使能状态.
UIStatusSwitch(0, handles);
set(handles.Render, 'Enable', 'on');
set(handles.Stop, 'Enable', 'on');


%% 执行系统资源释放.
function LeftVideoProgress_DeleteFcn(hObject, eventdata, handles)
global leftOver;
leftOver = 1;
uiresume(handles.VideoGrading);
function SourceVideoAxes_DeleteFcn(hObject, eventdata, handles)
global leftOver;
leftOver = 1;
uiresume(handles.VideoGrading);


%% 激活RadioButton.
% 源Video激活按钮.
function SourceVideoButton_Callback(hObject, eventdata, handles)
SwitchSourceButton(handles,1);
% 源VideoMatte激活按钮.
function SourceMatteButton_Callback(hObject, eventdata, handles)
SwitchSourceButton(handles,0);
% 目标Video激活按钮.
function TargetVideoButton_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 1);
% 目标VideoMatte激活按钮.
function TargetMatteButton_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 2);
% 目标BackVideo激活按钮.
function BackVideo_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 3);
% 目标BackMatte激活按钮.
function TargetBackMatte_Callback(hObject, eventdata, handles)
SwitchTargetButton(handles, 4);
% 源视频流切换.
function SwitchSourceButton(handles, CurButton)
if(CurButton == 1)
    set(handles.SourceMatteButton, 'Value', 0);
else
    set(handles.SourceVideoButton, 'Value', 0);
end
% 目标视频流切换.
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
% 设置源蒙版开启状态.
function OpenSourceMatte_Callback(hObject, eventdata, handles)
global SourceMatteName;
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
SourceSynOpen = get(handles.SourceSyn, 'Value');
TargetForeMatteOpen = get(handles.OpenTargetMatte, 'Value');
TargetBackMatteOpen = get(handles.OpenBackMatte, 'Value');
TargetSynOpen = get(handles.TargetSyn, 'Value');
VideoStatusSwitch(handles);
if(get(hObject, 'Value') == 1)
    set(handles.SourceMatteButton, 'Enable', 'on');
    set(handles.SourceMatte, 'Enable', 'on');
    if(SourceSynOpen == 0)
        set(handles.OpenBackMatte, 'Enable', 'off');
        set(handles.OpenBackMatte, 'Value', 0);
        set(handles.TargetSyn, 'Enable', 'off');
        set(handles.TargetSyn, 'Value', 0);
    else
        set(handles.OpenTargetMatte, 'Value', 1);
        set(handles.TargetSyn, 'Enable', 'on');
        set(handles.TargetSyn, 'Value', 1);
        set(handles.OpenBackMatte, 'Enable', 'off');
        set(handles.OpenBackMatte, 'Value', 0);
        set(handles.TargetMatteButton, 'Enable', 'on');
        set(handles.TargetForeMatte, 'Enable', 'on');
    end
else
    set(handles.SourceMatteButton, 'Enable', 'off');
    set(handles.SourceMatteButton, 'Value', 0);
    set(handles.SourceVideoButton, 'Value', 1);
    set(handles.SourceMatte, 'Enable', 'off');
    set(handles.SourceSyn, 'Value', 0);
%     set(handles.OpenBackMatte, 'Enable', 'off');
%     set(handles.OpenBackMatte, 'Value', 0);
%     set(handles.TargetSyn, 'Enable', 'off');
%     set(handles.TargetSyn, 'Value', 0);
    SourceSyn_Callback(handles.SourceSyn, eventdata, handles);
    % 刷新源视频流渲染池.
    SourceMatteName = '';
    cla(handles.SourceMattePreview);
    axes(handles.SourceMattePreview);
    set(handles.SourceMattePreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.SourceMattePreview, 'Visible', 'on');
%     SourceVideoName = '';
%     cla(handles.SourceVideoAxes);
%     axes(handles.SourceVideoAxes);
%     set(handles.SourceVideoAxes,...
%         'Units','Pixels',...
%         'XTick',[],'YTick',[]);
%     set(handles.SourceVideoAxes, 'Visible', 'on');
end
% 设置目标蒙版开启状态.
function OpenTargetMatte_Callback(hObject, eventdata, handles)
global TargetForeMatteName;
global TargetBackVideoName;
global TargetBackMatteName;
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
SourceSynOpen = get(handles.SourceSyn, 'Value');
TargetForeMatteOpen = get(handles.OpenTargetMatte, 'Value');
TargetBackMatteOpen = get(handles.OpenBackMatte, 'Value');
TargetSynOpen = get(handles.TargetSyn, 'Value');
if(get(hObject, 'Value') == 1)
    set(handles.TargetMatteButton, 'Enable', 'on');
    if(get(handles.TargetSyn, 'Value') == 0 && get(handles.SourceSyn, 'Value') == 1)
        set(handles.OpenBackMatte, 'Enable', 'on');
    end
    set(handles.TargetForeMatte, 'Enable', 'on');
    set(handles.OpenForeMatteReverse,'Enable', 'on');
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
    set(handles.TargetForeMatte, 'Enable', 'off');
    set(handles.TargetBackTag, 'Enable', 'off');
    set(handles.TargetBackMatteTag, 'Enable', 'off');
    set(handles.TargetSyn, 'Value', 0);
    set(handles.UpdateBackKeyframes, 'Enable', 'off');
    set(handles.OpenForeMatteReverse,'Enable', 'off');
    set(handles.OpenBackMatteReverse,'Enable', 'off');
    set(handles.BackMatteHasAdded, 'Enable', 'off');
    set(handles.OpenForeMatteReverse, 'Value', 0);
    set(handles.BackMatteHasAdded, 'Value', 0);
    set(handles.OpenBackMatteReverse, 'Value', 0);
    %刷新目标视频流渲染池.
    %     cla(handles.TargetVideoAxes);
    %     axes(handles.TargetVideoAxes);
    %     set(handles.TargetVideoAxes,...
    %         'Units','Pixels',...
    %         'XTick',[],'YTick',[]);
    %     set(handles.TargetVideoAxes, 'Visible', 'on');
    TargetForeMatteName = '';
    cla(handles.TargetForeMattePreview);
    axes(handles.TargetForeMattePreview);
    set(handles.TargetForeMattePreview,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
    set(handles.TargetForeMattePreview, 'Visible', 'on');
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
% 开启目标背景蒙版.
function OpenBackMatte_Callback(hObject, eventdata, handles)
global TargetBackVideoName;
global TargetBackMatteName;
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
SourceSynOpen = get(handles.SourceSyn, 'Value');
TargetForeMatteOpen = get(handles.OpenTargetMatte, 'Value');
TargetBackMatteOpen = get(handles.OpenBackMatte, 'Value');
TargetSynOpen = get(handles.TargetSyn, 'Value');
if(get(handles.TargetSyn, 'Value') == 0)
    if(get(hObject, 'Value') == 1)
        set(handles.TargetBackMatte, 'Enable', 'on');
        set(handles.BackVideo, 'Enable', 'on');
        set(handles.TargetBackTag, 'Enable', 'on');
        set(handles.TargetBackMatteTag, 'Enable', 'on');
        set(handles.UpdateBackKeyframes, 'Enable', 'on');
        set(handles.OpenBackMatteReverse,'Enable', 'on');
        set(handles.BackMatteHasAdded, 'Enable', 'on');
    else
        set(handles.TargetBackMatte, 'Enable', 'off');
        set(handles.BackVideo, 'Enable', 'off');
        set(handles.BackVideo, 'Value', 0);
        set(handles.TargetBackMatte, 'Value', 0);
        if(get(handles.TargetVideoButton, 'Value') ==0 && get(handles.TargetMatteButton, 'Value') == 0)
            set(handles.TargetVideoButton, 'Value', 1);
        end
        set(handles.TargetBackTag, 'Enable', 'off');
        set(handles.TargetBackMatteTag, 'Enable', 'off');
        set(handles.UpdateBackKeyframes, 'Enable', 'off');
        set(handles.OpenBackMatteReverse,'Enable', 'off');
        set(handles.BackMatteHasAdded, 'Enable', 'off');
        set(handles.OpenBackMatteReverse, 'Value', 0);
        set(handles.BackMatteHasAdded, 'Value', 0);
        %刷新目标视频流渲染池.
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
    set(handles.TargetBackMatte, 'Enable', 'off');
    set(handles.TargetBackMatte, 'Value', 0);
    set(handles.BackVideo, 'Enable', 'off');
    set(handles.BackVideo, 'Value', 0);
    if(get(handles.TargetVideoButton, 'Value') ==0 && get(handles.TargetMatteButton, 'Value') == 0)
        set(handles.TargetVideoButton, 'Value', 1);
    end
    set(handles.TargetBackTag, 'Enable', 'off');
    set(handles.TargetBackMatteTag, 'Enable', 'off');
    set(handles.UpdateBackKeyframes, 'Enable', 'off');
    set(handles.BackMatteHasAdded, 'Enable', 'off');
    set(handles.OpenBackMatteReverse,'Enable', 'off');
    set(handles.BackMatteHasAdded, 'Value', 0);
    set(handles.OpenBackMatteReverse, 'Value', 0);
    %刷新目标视频流渲染池.
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
% 开启源前后背景同步.
function SourceSyn_Callback(hObject, eventdata, handles)
global TargetBackVideoName;
global TargetBackMatteName;
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
SourceSynOpen = get(handles.SourceSyn, 'Value');
TargetForeMatteOpen = get(handles.OpenTargetMatte, 'Value');
TargetBackMatteOpen = get(handles.OpenBackMatte, 'Value');
TargetSynOpen = get(handles.TargetSyn, 'Value');
VideoStatusSwitch(handles);

if(get(hObject, 'Value') == 1)
    set(handles.OpenSourceMatte, 'Value', 1);
    OpenSourceMatte_Callback(handles.OpenSourceMatte, eventdata, handles);
    set(handles.OpenForeMatteReverse,'Enable', 'on');
else
    set(handles.TargetSyn, 'Value', 0);
    set(handles.TargetSyn, 'Enable', 'off');
    set(handles.OpenBackMatte, 'Value', 0);
    set(handles.OpenBackMatte, 'Enable', 'off');
    set(handles.BackVideo, 'Enable', 'off');
    set(handles.BackVideo, 'Value', 0);
    set(handles.TargetBackMatte, 'Enable', 'off');
    set(handles.TargetBackMatte, 'Value', 0);
    if(get(handles.TargetVideoButton, 'Value') ==0 && get(handles.TargetMatteButton, 'Value') == 0)
        set(handles.TargetVideoButton, 'Value', 1);
    end
    set(handles.TargetBackTag, 'Enable', 'off');
    set(handles.TargetBackMatteTag, 'Enable', 'off');
    set(handles.UpdateBackKeyframes, 'Enable', 'off');
    set(handles.OpenBackMatteReverse,'Enable', 'off');
    set(handles.BackMatteHasAdded, 'Enable', 'off');
    set(handles.BackMatteHasAdded, 'Value', 0);
    set(handles.OpenBackMatteReverse, 'Value', 0);
    if(get(handles.OpenTargetMatte, 'Value') == 0)
        set(handles.OpenForeMatteReverse,'Enable', 'off');
    end
    %刷新目标视频流渲染池.
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
% 开启目标前后背景同步.
function TargetSyn_Callback(hObject, eventdata, handles)
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
SourceSynOpen = get(handles.SourceSyn, 'Value');
TargetForeMatteOpen = get(handles.OpenTargetMatte, 'Value');
TargetBackMatteOpen = get(handles.OpenBackMatte, 'Value');
TargetSynOpen = get(handles.TargetSyn, 'Value');
if(get(hObject, 'Value') == 1)
    set(handles.OpenTargetMatte, 'Value', 1);
    OpenTargetMatte_Callback(handles.OpenTargetMatte, eventdata, handles);
    set(handles.OpenBackMatte, 'Value', 0);
    set(handles.OpenBackMatte, 'Enable', 'off');
    OpenBackMatte_Callback(handles.OpenBackMatte, eventdata, handles);
else
    if(get(handles.OpenTargetMatte, 'Value') == 1)
        OpenTargetMatte_Callback(handles.OpenTargetMatte, eventdata, handles);
    end
end
% 设置BackMatte视频流的添加与否.
function BackMatteHasAdded_Callback(hObject, eventdata, handles)
global BackMatteHasBeenAdd;
global TargetBackMatteName;
BackMatteHasBeenAdd = get(hObject, 'Value');
if(BackMatteHasBeenAdd == 0)
    TargetBackMatteName = '';
end


%% 向渲染池中添加视频流.
% 将左边的原视频流添加到渲染池中.
function LeftAddVideoButton_Callback(hObject, eventdata, handles)
global SourceVideoName;
global SourceMatteName;
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
axes(AxesHandle);
imshow(mov.cdata);
if(get(handles.SourceVideoButton, 'Value') == 1)
    SourceVideoName = CurrentVideo;
    axes(handles.SourcePreview);
    imshow(mov.cdata);
else
    SourceMatteName = CurrentVideo;
    axes(handles.SourceMattePreview);
    imshow(mov.cdata);
end
% 将右边的原视频流添加到渲染池中.
function RightAddVideoButton_Callback(hObject, eventdata, handles)
global TargetForeVideoName;
global TargetForeMatteName;
global TargetBackVideoName;
global TargetBackMatteName;
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
h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
h2 = floor(AxesWidth * videoHeight / videoWidth);
P = read(VideoMedia, 1);
mov.cdata(h1 : h1 + h2 - 1, :, :) = imresize(P,[h2, AxesWidth]);
axes(AxesHandle);
imshow(mov.cdata);
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


% 启动视频流渲染.
function Render_Callback(hObject, eventdata, handles)
global rendering;
global BackMatteHasBeenAdd;
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
global OpenFilter;
global OpenUpdateForeKeyFrames;
global OpenUpdateBackKeyFrames;
global OpenForeMatteReverseSwitch;
global OpenBackMatteReverseSwitch;
% global StatusBarHandle;
% global BackMatteHasBeenAdd;
% global TargetForeVideoName;
% global TargetForeMatteName;
% global TargetBackVideoName;
% global TargetBackMatteName;
if(rendering == 0)
    rendering = 1;
    UIStatusSwitch(1, handles);
    set(handles.Render, 'Enable', 'off');
    pause(0.5);
    % 初始化渲染状态变量.
    OpenForeMatteReverseSwitch = get(handles.OpenForeMatteReverse, 'Value');
    OpenBackMatteReverseSwitch = get(handles.OpenBackMatteReverse, 'Value');
    OpenUpdateForeKeyFrames = get(handles.UpdateForeKeyframes, 'Value');
    OpenUpdateBackKeyFrames = get(handles.UpdateBackKeyframes, 'Value');
    OpenFilter = get(handles.OpenFilter, 'Value');
    SourceMatteOpen = get(handles.OpenSourceMatte, 'Value');
    SourceSynOpen = get(handles.SourceSyn, 'Value');
    TargetForeMatteOpen = get(handles.OpenTargetMatte, 'Value');
    TargetBackMatteOpen = get(handles.OpenBackMatte, 'Value');
    TargetSynOpen = get(handles.TargetSyn, 'Value');
    BackMatteHasBeenAdd = get(handles.BackMatteHasAdded, 'Value');
    %StatusBarHandle = get(handles.StatusWindow, 'Tag');
    GetAllVideoOutputStatus(handles);
%     ColorTransferWithinPerframe();
%     SaveRenderedVideoSlice();
    ColorTransferWithinVideo();
    UIStatusSwitch(0, handles);
    set(handles.Render, 'Enable', 'on');
    rendering = 0;
end
% 终止视频流渲染.
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

% 打开SourceVideo目录.
function OutputSourceVideo_Callback(hObject, eventdata, handles)
function SouceVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SourceVideo');
function SourceVideoSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SourceVideoSlices');

% 打开SourceForeVideo目录.
function OutputSourceForeVideo_Callback(hObject, eventdata, handles)
function SouceForeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SourceForeVideo');
function SouceForeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SouceForeVideoSlices');

% 打开SourceBackVideo目录.
function OutputSourceBackVideo_Callback(hObject, eventdata, handles)
function SouceBackVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SourceBackVideo');
function SouceBackVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SouceBackVideoSlices');

% 打开LuminaVideo目录.
function OutputLuminaVideo_Callback(hObject, eventdata, handles)
function LuminaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\LuminaVideo');
function LuminaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\LuminaVideoSlices');

% 打开ChrominaVideo目录.
function OutputChrominaVideo_Callback(hObject, eventdata, handles)
function ChrominaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ChrominaVideo');
function ChrominaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ChrominaVideoSlices');

% 打开SyncVideo目录.
function OutputSyncVideo_Callback(hObject, eventdata, handles)
function SyncVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\SyncVideo');
function SyncVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\SyncVideoSlices');

% 打开ForeLuminaVideo目录.
function OutputForeLuminaVideo_Callback(hObject, eventdata, handles)
function ForeLuminaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeLuminaVideo');
function ForeLuminaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeLuminaVideoSlices');

% 打开ForeChrominaVideo目录.
function OutputForeChrominaVideo_Callback(hObject, eventdata, handles)
function ForeChrominaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeChrominaVideo');
function ForeChrominaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeChrominaVideoSlices');

% 打开ForeSyncVideo目录.
function OutputForeSyncVideo_Callback(hObject, eventdata, handles)
function ForeSyncVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeSyncVideo');
function ForeSyncVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeSyncVideoSlices');

% 打开BackLuminaVideo目录.
function OutputBackLuminaVideo_Callback(hObject, eventdata, handles)
function BackLuminaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackLuminaVideo');
function BackLuminaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackLuminaVideoSlices');

% 打开BackChrominaVideo目录.
function OutputBackChrominaVideo_Callback(hObject, eventdata, handles)
function BackChrominaVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackChrominaVideo');
function BackChrominaVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackChrominaVideoSlices');

% 打开BackSyncVideo目录.
function OutputBackSyncVideo_Callback(hObject, eventdata, handles)
function BackSyncVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackSyncVideo');
function BackSyncVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackSyncVideoSlices');

% 打开ForeLumWholeVideo目录.
function OutputForeLumWholeVideo_Callback(hObject, eventdata, handles)
function ForeLumiWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeLumiWholeVideo');
function ForeLumiWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeLumiWholeVideoSlices');

% 打开ForeChroWholeVideo目录.
function OutputForeChroWholeVideo_Callback(hObject, eventdata, handles)
function ForeChrominaWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeChrominaWholeVideo');
function ForeChrominaWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeChrominaWholeVideoSlices');

% 打开ForeSyncWholeVideo目录.
function OutputForeSyncWholeVideo_Callback(hObject, eventdata, handles)
function ForeSyncWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\ForeSyncWholeVideo');
function ForeSyncWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\ForeSyncWholeVideoSlices');

% 打开BackLumWholeVideo目录.
function OutputBackLumWholeVideo_Callback(hObject, eventdata, handles)
function BackLuminaWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackLuminaWholeVideo');
function BackLuminaWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackLuminaWholeVideoSlices');

% 打开BackChroWholeVideo目录.
function OutputBackChroWholeVideo_Callback(hObject, eventdata, handles)
function BackChrominaWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackChrominaWholeVideo');
function BackChrominaWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackChrominaWholeVideoSlices');

% 打开BackSyncWholeVideo目录.
function OutputBackSyncWholeVideo_Callback(hObject, eventdata, handles)
function BackSyncWholeVideoDir_Callback(hObject, eventdata, handles)
winopen('Video\ResultVideo\BackSyncWholeVideo');
function BackSyncWholeVideoSlices_Callback(hObject, eventdata, handles)
winopen('VideoSlices\BackSyncWholeVideoSlices');


% 打开目标视频前景关键帧目录.
function TargetForeKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetForeKeyFrames');
% 打开目标视频前景序列目录.
function TargetForeSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetForeSlices');
% 打开目标视频前景蒙版关键帧目录.
function TargetForeMatteKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetForeMatteKeyFrames');
% 打开目标视频前景蒙版序列目录.
function TargetForeMatteSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetForeMatteSlices');
% 打开目标视频背景序列目录.
function TargetBackKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetBackKeyFrames');
% 打开目标视频背景序列目录.
function TargetBackSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetBackSlices');
% 打开目标视频背景景蒙版关键帧目录.
function TargetBackMatteKeyFramesDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/TargetBackMatteKeyFrames');
% 打开目标视频背景蒙版序列目录.
function TargetBackMatteSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/TargetBackMatteSlices');
% 打开左视频关键帧目录.
function LeftKeyframeDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/LeftKeyFrames');
% 打开左视频帧序列目录.
function LeftVideoSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/LeftSlices');
% 打开右视频关键帧目录..
function RightKeyframeDir_Callback(hObject, eventdata, handles)
winopen('KeyFrames/RightKeyFrames');
% 打开右视频帧序列目录.
function RightVideoSlicesDir_Callback(hObject, eventdata, handles)
winopen('VideoSlices/RightSlices');


% 左视频窗口创建.
function SourceVideoAxes_CreateFcn(hObject, eventdata, handles)
global LeftAxisHandle;
LeftAxisHandle = hObject;
% 右视频窗口创建.
function TargetVideoAxes_CreateFcn(hObject, eventdata, handles)
global RightAxisHandle;
RightAxisHandle = hObject;


% Video重组控制面板.
function RebuildVideo_Callback(hObject, eventdata, handles)
function RebuildVideo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);


% 分割视频.
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

% 重组视频.
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
