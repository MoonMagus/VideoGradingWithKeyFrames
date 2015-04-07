function varargout = Waitbar(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Waitbar_OpeningFcn, ...
                   'gui_OutputFcn',  @Waitbar_OutputFcn, ...
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


function Waitbar_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = Waitbar_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function ShowWaitbar_Callback(hObject, eventdata, handles)
WaitBarControl(0,'Please Wait...',handles.WaitbarAxis, handles.WaitbarFigure);
TheEndTime = 600; 
for t = 1:TheEndTime
       WaitBarControl(t/TheEndTime,[num2str(floor(t*100/TheEndTime)),'%'],handles.WaitbarAxis,handles.WaitbarFigure);
end


function WaitbarAxis_CreateFcn(hObject, eventdata, handles)
set(hObject,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];
line(xline,yline,'EraseMode','none','Color','k');
