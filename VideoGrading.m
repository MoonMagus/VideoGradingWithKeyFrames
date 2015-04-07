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
global leftClose;
global curFrame;
function VideoGrading_OpeningFcn(hObject, eventdata, handles, varargin)
global leftClose;
global curFrame;
handles.output = hObject;
guidata(hObject, handles);
leftClose = 0;
curFrame = 0;
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


% 进度状态信息窗口.
function StatusWindow_Callback(hObject, eventdata, handles)
function StatusWindow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% 进度条.
function ProgressbarAxes_CreateFcn(hObject, eventdata, handles)
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');


%% 填充预览窗口和下拉菜单.
% 填充预览窗口.
function FillPreviewWindow(hObject, AxesHandle, handles)
global leftClose;
leftClose = 1;
leftClose = 0;
global curFrame;
curFrame = 0;
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
WaitBarControl(0,'',handles.LeftVideoProgress, handles.VideoGrading);
axes(AxesHandle);
imshow(mov.cdata);

% 拉取PopMenu下的内容.
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


% 显示源Video下拉列表.
function SourceVideoMenu_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject, handles.SourceVideoAxes, handles);
function SourceVideoMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);

% 显示目标Video下拉列表.
function TargetVideoMenu_Callback(hObject, eventdata, handles)
function TargetVideoMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%激活RadioButton.
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
if(get(hObject, 'Value') == 1)
    set(handles.SourceMatteButton, 'Enable', 'on');
else
    set(handles.SourceMatteButton, 'Enable', 'off');
    set(handles.SourceMatteButton, 'Value', 0);
    set(handles.SourceVideoButton, 'Value', 1);
end


% 设置目标蒙版开启状态.
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
% 开启目标背景蒙版.
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


% 执行左方视频播放暂停.
function LeftPlay_Callback(hObject, eventdata, handles)
global curFrame;
global over;
if(curFrame == 0)
    ListName = get(handles.SourceVideoMenu, 'UserData');
    CurrentVideo = char(ListName(get(handles.SourceVideoMenu, 'Value')));
    set(hObject,'string','| |')
    PlayVideoData(handles.SourceVideoAxes, hObject, handles, CurrentVideo);
end
PausePlay(hObject, handles.VideoGrading);
if(over == 1)
    set(hObject,'string','>>')
end


% 执行右方视频播放暂停.
function RightPlay_Callback(hObject, eventdata, handles)


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


% 提取左视频流中的关键帧.
function LeftKeyFrames_Callback(hObject, eventdata, handles)
ListName = get(handles.SourceVideoMenu, 'UserData');
VideoName = char(ListName(get(handles.SourceVideoMenu, 'Value')));
LoadVideoData(VideoName);
ExtractKeyFrames(VideoName);


% 关闭左侧视频窗口.
function CloseLeft_Callback(hObject, eventdata, handles)
global leftClose;
leftClose = 1;
global curFrame;
curFrame = 0;
global over;
over = 1;
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
%set(handles.LeftPlay,'string','>>')


% --- Executes during object deletion, before destroying properties.
function LeftVideoProgress_DeleteFcn(hObject, eventdata, handles)
global leftClose;
leftClose = 1;
uiresume(handles.VideoGrading);
pause(0.2);


% --- Executes during object deletion, before destroying properties.
function SourceVideoAxes_DeleteFcn(hObject, eventdata, handles)
global leftClose;
leftClose = 1;
uiresume(handles.VideoGrading);

