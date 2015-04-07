function varargout = ColorGrading(varargin)
%COLORGRADING M-file for ColorGrading.fig
%      COLORGRADING, by itself, creates a new COLORGRADING or raises the existing
%      singleton*.
%
%      H = COLORGRADING returns the handle to a new COLORGRADING or the handle to
%      the existing singleton*.
%
%      COLORGRADING('Property','Value',...) creates a new COLORGRADING using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ColorGrading_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      COLORGRADING('CALLBACK') and COLORGRADING('CALLBACK',hObject,...) call the
%      local function named CALLBACK in COLORGRADING.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ColorGrading

% Last Modified by GUIDE v2.5 15-Jan-2015 09:19:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ColorGrading_OpeningFcn, ...
                   'gui_OutputFcn',  @ColorGrading_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ColorGrading is made visible.
function ColorGrading_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

%%
set(hObject,'Name','基于光照一致的色调融合');

%% 设置下拉菜单属性.
dirs1 = dir('*.jpg');
dirs2 = dir('*.bmp');
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
[x,y] = size(filenames);
if x > 0 
    ListImage = char(filenames(1));
else
    ListImage = '';
end
for i = 2:x
    ListImage = strcat(ListImage,'|',char(filenames(i)));
end
SourceImagePopHandle = findobj('Tag','SourcePopMenu');
for i=1:x
    if strcmp(char(filenames(i)),'云南.jpg')==1
        break;
    end
end
set(SourceImagePopHandle,'String',ListImage);
set(SourceImagePopHandle,'UserData',filenames);
set(SourceImagePopHandle,'Value',i);
TargetImagePopHandle = findobj('Tag','TargetPopMenu');
for j=1:x
    if strcmp(char(filenames(j)),'马尔代夫.jpg') == 1
        break;
    end
end
set(TargetImagePopHandle,'String',ListImage);
set(TargetImagePopHandle,'UserData',filenames);
set(TargetImagePopHandle,'Value',j);

%% 设置对照下拉菜单属性.
ContrastListImages = '马尔代夫.jpg|云南.jpg|辐照度迁移结果.jpg|色调同步结果.jpg';
ContrastUserData = {'马尔代夫.jpg';'云南.jpg';'辐照度迁移结果.jpg';'色调同步结果.jpg'};
ContrastLeftPopMenuHandle = findobj('Tag','ContrastLeftPopMenu');
set(ContrastLeftPopMenuHandle,'String',ContrastListImages);
set(ContrastLeftPopMenuHandle,'UserData',ContrastUserData);
set(ContrastLeftPopMenuHandle,'Value',2);
ContrastRightPopMenuHandle = findobj('Tag','ContrastRightPopMenu');
set(ContrastRightPopMenuHandle,'String',ContrastListImages);
set(ContrastRightPopMenuHandle,'UserData',ContrastUserData);
set(ContrastRightPopMenuHandle,'Value',3);

%% 设置图像框架属性.
handles.ImageHandle = hObject;
handles.SourcePopHandle = SourceImagePopHandle;
handles.TargetPopHandle = TargetImagePopHandle;
handles.GaussFilterHandle = findobj('Tag','GaussFilter');
handles.SigmaTextHandle = findobj('Tag','SigmaText');
handles.WidthTextHandle = findobj('Tag','WidthText');
handles.HeightTextHandle = findobj('Tag','HeightText');
handles.HueSyncHandle = findobj('Tag','HueSync');
handles.TargetPanelHandle = findobj('Tag','TargetPanel');
handles.ColorTargetAxisHandle = findobj('Tag','ColorTargetAxis');
handles.HistTargetAxisHandle = findobj('Tag','HistTargetAxis');
handles.LuminanceTargetAxisHandle = findobj('Tag','LuminanceTargetAxis');
handles.SourcePanelHandle = findobj('Tag','SourcePanel');
handles.ColorSourceAxisHandle = findobj('Tag','ColorSourceAxis');
handles.HistSourceAxisHandle = findobj('Tag','HistSourceAxis');
handles.LuminanceSourceAxisHandle = findobj('Tag','LuminanceSourceAxis');
handles.ResultPanelHandle = findobj('Tag','ResultPanel');
handles.ColorMatchedAxisHandle = findobj('Tag','ColorMatchedAxis');
handles.HistMatchedAxisHandle = findobj('Tag','HistMatchedAxis');
handles.LuminanceMatchedAxisHandle = findobj('Tag','LuminanceMatchedAxis');
handles.ContrastPanelHandle = findobj('Tag','ContrastPanel');
handles.ImageLeftAxisHandle = findobj('Tag','ImageLeftAxis');
handles.ImageRightAxisHandle = findobj('Tag','ImageRightAxis');
handles.LeftContrastHandle = findobj('Tag','LeftContrastHandle');
handles.RightContrastHandle = findobj('Tag','RightContrastHandle');


%% 载入源图像和目标图像.
s = imread('云南.jpg');
t = imread('马尔代夫.jpg');
handles.CurrentSource = '云南.jpg';
handles.CurrentTarget = '马尔代夫.jpg';
handles.sname = '云南.jpg';
handles.tname = '马尔代夫.jpg';
handles = PlotAxis(handles,s,t);

%% Choose default command line output for ColorGrading
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ColorGrading wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ColorGrading_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% 各坐标轴对象绘制函数.
function handle = PlotAxis(handles,s,t)
% 此函数用于根据源图像和目标图像绘制各坐标轴对象.
% 载入目标图像和源图像.
TargetPreprocessed = RGB2Lab(t);   
TargetChannelL = TargetPreprocessed(:,:,1);
TargetChannelA = TargetPreprocessed(:,:,2);
TargetChannelB = TargetPreprocessed(:,:,3);
SourcePreprocessed = RGB2Lab(s);   
SourceChannelL = SourcePreprocessed(:,:,1);
SourceChannelA = SourcePreprocessed(:,:,2);
SourceChannelB = SourcePreprocessed(:,:,3);


% 设置目标图像坐标轴.
CurrentImage = handles.ImageHandle;
figure(CurrentImage);
ColorTargetHandle = findobj(CurrentImage,'Tag','ColorTargetAxis');
if size(ColorTargetHandle) ~= 0
   handles.ColorTargetHandle = ColorTargetHandle; 
else 
    ColorTargetHandle = handles.ColorTargetHandle;
end
set(ColorTargetHandle,'Units','Pixels',...
                      'XTick',[],...
                      'YTick',[]);
axes(ColorTargetHandle);
imshow(t);
handles.TargetImage = t;
% 设置目标图像直方图坐标轴.
HistTargetHandle = findobj(CurrentImage,'Tag','HistTargetAxis');
if size(HistTargetHandle) ~= 0
   handles.HistTargetHandle = HistTargetHandle; 
else 
    HistTargetHandle = handles.HistTargetHandle;
end
set(HistTargetHandle,'Units','Pixels',...
                     'XTick',[],...
                     'YTick',[]);
axes(HistTargetHandle);
LuminanceData = mat2gray(TargetChannelL,[0 100]);
LuminanceData = im2uint8(LuminanceData);
imhist(LuminanceData);
histCount = imhist(LuminanceData);
handles.LuminanceData = LuminanceData;
% 设置目标图像辐照度坐标轴.                 
LuminanceTargetHandle = findobj(CurrentImage,'Tag','LuminanceTargetAxis');
if size(LuminanceTargetHandle) ~= 0
   handles.LuminanceTargetHandle = LuminanceTargetHandle; 
else 
    LuminanceTargetHandle = handles.LuminanceTargetHandle;
end
set(LuminanceTargetHandle, 'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
axes(LuminanceTargetHandle);
imshow(LuminanceData);
handles.LuminanceData = LuminanceData;

% 设置源图像坐标轴.
ColorSourceHandle = findobj(CurrentImage,'Tag','ColorSourceAxis');
if size(ColorSourceHandle) ~= 0
   handles.ColorSourceHandle = ColorSourceHandle; 
else 
    ColorSourceHandle = handles.ColorSourceHandle;
end
set(ColorSourceHandle,'Units','Pixels',...
                      'XTick',[],...
                      'YTick',[]);
axes(ColorSourceHandle);
imshow(s);
handles.SourceImage = s;
% 设置源图像直方图坐标轴.
HistSourceHandle = findobj(CurrentImage,'Tag','HistSourceAxis');
if size(HistSourceHandle) ~= 0
   handles.HistSourceHandle = HistSourceHandle; 
else 
    HistSourceHandle = handles.HistSourceHandle;
end
set(HistSourceHandle,'Units','Pixels',...
                     'XTick',[],...
                     'YTick',[]);  
LuminanceSource = mat2gray(SourceChannelL,[0 100]);
LuminanceSource = im2uint8(LuminanceSource);
axes(HistSourceHandle);
imhist(LuminanceSource);
handles.LuminanceSource = LuminanceSource;
% 设置源图像辐照度坐标轴.                  
LuminanceSourceHandle = findobj(CurrentImage,'Tag','LuminanceSourceAxis');
if size(LuminanceSourceHandle) ~= 0
   handles.LuminanceSourceHandle = LuminanceSourceHandle; 
else 
    LuminanceSourceHandle = handles.LuminanceSourceHandle;
end
set(LuminanceSourceHandle, 'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
axes(LuminanceSourceHandle);
imshow(LuminanceSource);


% 设置匹配图像直方图坐标轴.
HistMatchedHandle = findobj(CurrentImage,'Tag','HistMatchedAxis');
if size(HistMatchedHandle) ~= 0
   handles.HistMatchedHandle = HistMatchedHandle; 
else 
    HistMatchedHandle = handles.HistMatchedHandle;
end
set(HistMatchedHandle,'Units','Pixels',...
                     'XTick',[],...
                     'YTick',[]);
histCount = mat2gray(histCount);
resultImage = histeq(LuminanceSource,histCount);
axes(HistMatchedHandle);
imhist(resultImage,256);
handles.ResultImage = resultImage;
% 设置匹配图像辐照度坐标轴.
LuminanceMatchedHandle = findobj(CurrentImage,'Tag','LuminanceMatchedAxis');
if size(LuminanceMatchedHandle) ~= 0
   handles.LuminanceMatchedHandle = LuminanceMatchedHandle; 
else 
    LuminanceMatchedHandle = handles.LuminanceMatchedHandle;
end
set(LuminanceMatchedHandle,'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
resultImageDouble = mat2gray(resultImage,[0 255]);
resultImage = im2uint8(resultImageDouble);
axes(LuminanceMatchedHandle);
imshow(resultImage);
% 设置匹配图像坐标轴.
ColorMatchedHandle = findobj(CurrentImage,'Tag','ColorMatchedAxis');
if size(ColorMatchedHandle) ~= 0
   handles.ColorMatchedHandle = ColorMatchedHandle; 
else 
    ColorMatchedHandle = handles.ColorMatchedHandle;
end
set(ColorMatchedHandle,'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
resultImageDouble = mat2gray(resultImage,[0 255]);
resultImageDouble = resultImageDouble*100;

%检测是否执行色调同步.
HueSyncHandle = findobj(CurrentImage,'Tag','HueSync');
if size(HueSyncHandle) ~= 0
   handles.HueSyncHandle = HueSyncHandle; 
else 
   HueSyncHandle =  handles.HueSyncHandle;
end
HueSyncSwitch = get(HueSyncHandle,'Value');
Luminance_Result_image = Lab2RGB(resultImageDouble,SourceChannelA,SourceChannelB);
[SourceChannelA , SourceChannelB] = ...
ChrominanceTransform(SourceChannelL,...
                     SourceChannelA,...
                     SourceChannelB,...
                     TargetChannelL,...
                     TargetChannelA,...
                     TargetChannelB);
Huesync_Result_image = Lab2RGB(resultImageDouble,SourceChannelA,SourceChannelB);

%获取过滤器的参数值.
GaussFilterHandle = findobj(CurrentImage,'Tag','GaussFilter');
if size(GaussFilterHandle) ~= 0
   handles.GaussFilterHandle = GaussFilterHandle; 
else 
   GaussFilterHandle =  handles.GaussFilterHandle;
end
FilterSwitch = get(GaussFilterHandle,'Value');
if FilterSwitch == 1 
    SigmaTextHandle = findobj(CurrentImage,'Tag','SigmaText');
    if size(SigmaTextHandle) ~= 0
       handles.SigmaTextHandle = SigmaTextHandle; 
    else 
       SigmaTextHandle = handles.SigmaTextHandle;
    end
    sigma = get(SigmaTextHandle,'String');
    WidthTextHandle = findobj(CurrentImage,'Tag','WidthText');
    if size(WidthTextHandle) ~= 0
       handles.WidthTextHandle = WidthTextHandle; 
    else 
       WidthTextHandle = handles.WidthTextHandle;
    end
    width = get(WidthTextHandle,'String');
    HeightTextHandle = findobj(CurrentImage,'Tag','HeightText');
    if size(HeightTextHandle) ~= 0
       handles.HeightTextHandle = HeightTextHandle; 
    else 
       HeightTextHandle = handles.HeightTextHandle;
    end
    height = get(HeightTextHandle,'String'); 
    sizef = [double(width) double(height)];
    sigma = str2double(sigma);
    gausFilter = fspecial('gaussian',sizef,sigma);
    if HueSyncSwitch == 0
        Luminance_Result_image = imfilter(Luminance_Result_image,gausFilter,'replicate');
    else
        Huesync_Result_image = imfilter(Huesync_Result_image,gausFilter,'replicate');
    end
end
axes(ColorMatchedHandle);
if HueSyncSwitch == 1
    imshow(Huesync_Result_image);
    handles.Result_image = Huesync_Result_image;
else
    imshow(Luminance_Result_image);
    handles.Result_image = Luminance_Result_image;
end
handles.Luminance_Result_image = Luminance_Result_image;
handles.Huesync_Result_image = Huesync_Result_image;
imwrite(Luminance_Result_image,'辐照度迁移结果.jpg');
imwrite(Huesync_Result_image,'色调同步结果.jpg');
handle = handles;
guidata(CurrentImage,handles);


% --- Executes on selection change in SourcePopMenu.
function SourcePopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SourcePopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SourcePopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SourcePopMenu


% --- Executes during object creation, after setting all properties.
function SourcePopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourcePopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TargetPopMenu.
function TargetPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to TargetPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TargetPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TargetPopMenu


% --- Executes during object creation, after setting all properties.
function TargetPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TargetPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BeginButton.
function BeginButton_Callback(hObject, eventdata, handles)
% hObject    handle to BeginButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DetailButtonHandle = findobj('Tag','DetailButton');
DetailButtonValue = get(DetailButtonHandle,'Value');
if  DetailButtonValue ==1
    CurrentImage = handles.ImageHandle;
    SourceImagePopHandle = findobj(gcf,'Tag','SourcePopMenu');
    ListName = get(SourceImagePopHandle,'UserData');
    sname = char(ListName(get(SourceImagePopHandle,'Value')));
    s = imread(sname);
    TargetImagePopHandle = findobj(gcf,'Tag','TargetPopMenu');
    ListName = get(TargetImagePopHandle,'UserData');
    tname = char(ListName(get(TargetImagePopHandle,'Value')));
    t = imread(tname);
    handles.sname = sname;
    handles.tname = tname;
    guidata(CurrentImage,handles);
    ContrastListImages = strcat(tname,'|',sname,'|','辐照度迁移结果.jpg','|','色调同步结果.jpg');
    ContrastUserData = {tname;sname;'辐照度迁移结果.jpg';'色调同步结果.jpg'};
    ContrastLeftPopMenuHandle = findobj('Tag','ContrastLeftPopMenu');
    set(ContrastLeftPopMenuHandle,'String',ContrastListImages);
    set(ContrastLeftPopMenuHandle,'UserData',ContrastUserData);
    set(ContrastLeftPopMenuHandle,'Value',2);
    ContrastRightPopMenuHandle = findobj('Tag','ContrastRightPopMenu');
    set(ContrastRightPopMenuHandle,'String',ContrastListImages);
    set(ContrastRightPopMenuHandle,'UserData',ContrastUserData);
    set(ContrastRightPopMenuHandle,'Value',3);
    PlotAxis(handles,s,t);
end



% --- Executes on slider movement.
function WidthSlider_Callback(hObject, eventdata, handles)
% hObject    handle to WidthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WidthValue = get(hObject,'Value');
WidthTextHandle = findobj(gcf,'Tag','WidthText');
set(WidthTextHandle,'String',ceil(WidthValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function WidthSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WidthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function HeightSlider_Callback(hObject, eventdata, handles)
% hObject    handle to HeightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HeightValue = get(hObject,'Value');
HeightTextHandle = findobj(gcf,'Tag','HeightText');
set(HeightTextHandle,'String',ceil(HeightValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function HeightSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HeightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function WidthText_Callback(hObject, eventdata, handles)
% hObject    handle to WidthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WidthValue = get(hObject,'String');
WidthSliderHandle = findobj(gcf,'Tag','WidthSlider');
set(WidthSliderHandle,'Value',ceil(str2double(WidthValue)));
% Hints: get(hObject,'String') returns contents of WidthText as text
%        str2double(get(hObject,'String')) returns contents of WidthText as a double


% --- Executes during object creation, after setting all properties.
function WidthText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WidthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HeightText_Callback(hObject, eventdata, handles)
% hObject    handle to HeightText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HeightValue = get(hObject,'String');
HeightSliderHandle = findobj(gcf,'Tag','HeightSlider');
set(HeightSliderHandle,'Value',ceil(str2double(HeightValue)));
% Hints: get(hObject,'String') returns contents of HeightText as text
%        str2double(get(hObject,'String')) returns contents of HeightText as a double


% --- Executes during object creation, after setting all properties.
function HeightText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HeightText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GaussFilter.
function GaussFilter_Callback(hObject, eventdata, handles)
% hObject    handle to GaussFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GaussFilter



function SigmaText_Callback(hObject, eventdata, handles)
% hObject    handle to SigmaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SigmaText as text
%        str2double(get(hObject,'String')) returns contents of SigmaText as a double


% --- Executes during object creation, after setting all properties.
function SigmaText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SigmaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in HueSync.
function HueSync_Callback(hObject, eventdata, handles)
% hObject    handle to HueSync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HueSync


%% --- Executes on button press in DetailButton.
function DetailButton_Callback(hObject, eventdata, handles)
% hObject    handle to DetailButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ContrastButtonHandle = findobj('Tag','ContrastButton');
ContrastButtonValue = get(ContrastButtonHandle,'Value');
if ContrastButtonValue ==1
   set(ContrastButtonHandle,'Value',0);
end
CurrentImage = handles.ImageHandle;
figure(CurrentImage);
%设置目标源图像坐标轴.
ColorTargetHandle = findobj(CurrentImage,'Tag','ColorTargetAxis');
if size(ColorTargetHandle) ~= 0
   handles.ColorTargetHandle = ColorTargetHandle; 
else 
   ColorTargetHandle = handles.ColorTargetHandle;
end
axes(ColorTargetHandle);
cla reset;
set(ColorTargetHandle,'Visible','on');
TargetImage = handles.TargetImage;
imshow(TargetImage);
%设置目标直方图.
HistTargetHandle = findobj(CurrentImage,'Tag','HistTargetAxis');
if size(HistTargetHandle) ~= 0
   handles.HistTargetHandle = HistTargetHandle; 
else 
   HistTargetHandle = handles.HistTargetHandle;
end
axes(HistTargetHandle);
cla reset;
set(HistTargetHandle,'Visible','on');
LuminanceData = handles.LuminanceData;
imhist(LuminanceData);
%设置目标辐照图坐标轴.
LuminanceTargetHandle = findobj(CurrentImage,'Tag','LuminanceTargetAxis');
if size(LuminanceTargetHandle) ~= 0
   handles.LuminanceTargetHandle = LuminanceTargetHandle; 
else 
    LuminanceTargetHandle = handles.LuminanceTargetHandle;
end
axes(LuminanceTargetHandle);
cla reset;
set(LuminanceTargetHandle,'Visible','on');
imshow(LuminanceData);
%设置目标面板.
TargetPanelHandle = findobj('Tag','TargetPanel');
if size(TargetPanelHandle) ~= 0
   handles.TargetPanelHandle = TargetPanelHandle; 
else 
   TargetPanelHandle = handles.TargetPanelHandle;
end
set(TargetPanelHandle,'Visible','on');

%设置源图像坐标轴.
ColorSourceHandle = findobj(CurrentImage,'Tag','ColorSourceAxis');
if size(ColorSourceHandle) ~= 0
   handles.ColorSourceHandle = ColorSourceHandle; 
else 
    ColorSourceHandle = handles.ColorSourceHandle;
end
axes(ColorSourceHandle);
cla reset;
set(ColorSourceHandle,'Visible','on');
SourceImage = handles.SourceImage;
imshow(SourceImage);
%设置源图像直方图坐标轴.
HistSourceHandle = findobj(CurrentImage,'Tag','HistSourceAxis');
if size(HistSourceHandle) ~= 0
   handles.HistSourceHandle = HistSourceHandle; 
else 
    HistSourceHandle = handles.HistSourceHandle;
end
axes(HistSourceHandle);
cla reset;
set(HistSourceHandle,'Visible','on');
LuminanceSource = handles.LuminanceSource;
imhist(LuminanceSource);
%设置源图像辐照度坐标轴.
LuminanceSourceHandle = findobj(CurrentImage,'Tag','LuminanceSourceAxis');
if size(LuminanceSourceHandle) ~= 0
   handles.LuminanceSourceHandle = LuminanceSourceHandle; 
else 
    LuminanceSourceHandle = handles.LuminanceSourceHandle;
end
axes(LuminanceSourceHandle);
cla reset;
set(LuminanceSourceHandle,'Visible','on')
imshow(LuminanceSource);
% 设置源面板.
SourcePanelHandle = findobj('Tag','SourcePanel');
if size(SourcePanelHandle) ~= 0
   handles.SourcePanelHandle = SourcePanelHandle; 
else 
   SourcePanelHandle = handles.SourcePanelHandle;
end
set(SourcePanelHandle,'Visible','on');

%设置匹配图像坐标轴.
ColorMatchedHandle = findobj(CurrentImage,'Tag','ColorMatchedAxis');
if size(ColorMatchedHandle) ~= 0
   handles.ColorMatchedHandle = ColorMatchedHandle; 
else 
    ColorMatchedHandle = handles.ColorMatchedHandle;
end
axes(ColorMatchedHandle);
cla reset;
set(ColorMatchedHandle,'Visible','on');
ResultImage = handles.Result_image;
imshow(ResultImage);
%设置匹配图像直方图坐标轴.
HistMatchedHandle = findobj(CurrentImage,'Tag','HistMatchedAxis');
if size(HistMatchedHandle) ~= 0
   handles.HistMatchedHandle = HistMatchedHandle; 
else 
    HistMatchedHandle = handles.HistMatchedHandle;
end
axes(HistMatchedHandle);
cla reset;
set(HistMatchedHandle,'Visible','on');
TargetLuminance = handles.ResultImage;
imhist(TargetLuminance);
%设置匹配图像辐照度坐标轴.
LuminanceMatchedHandle = findobj(CurrentImage,'Tag','LuminanceMatchedAxis');
if size(LuminanceMatchedHandle) ~= 0
   handles.LuminanceMatchedHandle = LuminanceMatchedHandle; 
else 
    LuminanceMatchedHandle = handles.LuminanceMatchedHandle;
end
axes(LuminanceMatchedHandle);
cla reset;
set(LuminanceMatchedHandle,'Visible','on');
imshow(TargetLuminance);
% 设置匹配面板.
ResultPanelHandle = findobj('Tag','ResultPanel');
if size(ResultPanelHandle) ~= 0
   handles.ResultPanelHandle = ResultPanelHandle; 
else 
   ResultPanelHandle = handles.ResultPanelHandle;
end
set(ResultPanelHandle,'Visible','on');

% 显示对比面板,
ContrastPanelHandle = findobj('Tag','ContrastPanel');
if size(ContrastPanelHandle) ~= 0
   handles.ContrastPanelHandle = ContrastPanelHandle; 
else 
   ContrastPanelHandle = handles.ContrastPanelHandle;
end
set(ContrastPanelHandle,'Visible','off');

% 显示左对照面板.
LeftContrastHandle = findobj('Tag','LeftContrast');
if size(LeftContrastHandle) ~= 0
   handles.LeftContrastHandle = LeftContrastHandle; 
else 
   LeftContrastHandle = handles.LeftContrastHandle;
end
set(LeftContrastHandle,'Visible','off');
% 显示左图像坐标轴.
ImageLeftAxisHandle = findobj('Tag','ImageLeftAxis');
if size(ImageLeftAxisHandle) ~= 0
   handles.ImageLeftAxisHandle = ImageLeftAxisHandle; 
else 
   ImageLeftAxisHandle = handles.ImageLeftAxisHandle;
end
set(ImageLeftAxisHandle,'Visible','off');

% 显示右对照面板.
RightContrastHandle = findobj('Tag','RightContrast');
if size(RightContrastHandle) ~= 0
   handles.RightContrastHandle = RightContrastHandle; 
else 
   RightContrastHandle = handles.RightContrastHandle;
end
set(RightContrastHandle,'Visible','off');
% 显示右图像坐标轴.
ImageRightAxisHandle = findobj('Tag','ImageRightAxis');
if size(ImageRightAxisHandle) ~= 0
   handles.ImageRightAxisHandle = ImageRightAxisHandle; 
else 
   ImageRightAxisHandle = handles.ImageRightAxisHandle;
end
set(ImageRightAxisHandle,'Visible','off');

% 隐藏对照控制坐标轴.
% 显示对照控制面板.
ContrastControlPanelHandle = findobj('Tag','ContrastControlPanel');
set(ContrastControlPanelHandle,'Visible','off');
ChannelControlPanelHandle = findobj('Tag','ChannelControlPanel');
set(ChannelControlPanelHandle,'Visible','off');
LHandle = findobj('Tag','L');
set(LHandle,'Visible','off');
AHandle = findobj('Tag','A');
set(AHandle,'Visible','off');
BHandle = findobj('Tag','B');
set(BHandle,'Visible','off');
SliderLHandle = findobj('Tag','SliderL');
set(SliderLHandle,'Visible','off');
SliderAHandle = findobj('Tag','SliderA');
set(SliderAHandle,'Visible','off');
SliderBHandle = findobj('Tag','SliderB');
set(SliderBHandle,'Visible','off');
TextLHandle = findobj('Tag','TextL');
set(TextLHandle,'Visible','off');
TextAHandle = findobj('Tag','TextA');
set(TextAHandle,'Visible','off');
TextBHandle = findobj('Tag','TextB');
set(TextBHandle,'Visible','off');
text18Handle = findobj('Tag','text18');
set(text18Handle,'Visible','off');
text22Handle = findobj('Tag','text22');
set(text22Handle,'Visible','off');
text20Handle = findobj('Tag','text20');
set(text20Handle,'Visible','off');
IntialScailingHandle = findobj('Tag','IntialScailing');
set(IntialScailingHandle,'Visible','off');
EndScailingHandle = findobj('Tag','EndScailing');
set(EndScailingHandle,'Visible','off');
SaveImagesHandle = findobj('Tag','SaveImages');
set(SaveImagesHandle,'Visible','off');
BeginAjustHandle = findobj('Tag','BeginAjust');
set(BeginAjustHandle,'Visible','off');
greenTextHandle = findobj('Tag','greenText');
set(greenTextHandle,'Visible','off');
redtextHandle = findobj('Tag','redtext');
set(redtextHandle,'Visible','off');
bluetextHandle = findobj('Tag','bluetext');
set(bluetextHandle,'Visible','off');
yellowtextHandle = findobj('Tag','yellowtext');
set(yellowtextHandle,'Visible','off');
% Hint: get(hObject,'Value') returns toggle state of DetailButton


%% --- Executes on button press in ContrastButton.
function ContrastButton_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DetailButtonHandle = findobj('Tag','DetailButton');
DetailButtonValue = get(DetailButtonHandle,'Value');
if DetailButtonValue ==1
   set(DetailButtonHandle,'Value',0);
end
CurrentImage = handles.ImageHandle;
figure(CurrentImage);
%设置目标源图像坐标轴.
ColorTargetHandle = findobj(CurrentImage,'Tag','ColorTargetAxis');
if size(ColorTargetHandle) ~= 0
   handles.ColorTargetHandle = ColorTargetHandle; 
else 
    ColorTargetHandle = handles.ColorTargetHandle;
end
axes(ColorTargetHandle);
cla reset;
set(ColorTargetHandle,'Visible','off');
%设置目标直方图.
HistTargetHandle = findobj(CurrentImage,'Tag','HistTargetAxis');
if size(HistTargetHandle) ~= 0
   handles.HistTargetHandle = HistTargetHandle; 
else 
    HistTargetHandle = handles.HistTargetHandle;
end
axes(HistTargetHandle);
cla reset;
set(HistTargetHandle,'Visible','off');
%设置目标辐照图坐标轴.
LuminanceTargetHandle = findobj(CurrentImage,'Tag','LuminanceTargetAxis');
if size(LuminanceTargetHandle) ~= 0
   handles.LuminanceTargetHandle = LuminanceTargetHandle; 
else 
    LuminanceTargetHandle = handles.LuminanceTargetHandle;
end
axes(LuminanceTargetHandle);
cla reset;
set(LuminanceTargetHandle,'Visible','off');
%设置目标面板.
TargetPanelHandle = findobj('Tag','TargetPanel');
if size(TargetPanelHandle) ~= 0
   handles.TargetPanelHandle = TargetPanelHandle; 
else 
   TargetPanelHandle = handles.TargetPanelHandle;
end
set(TargetPanelHandle,'Visible','off');

%设置源图像坐标轴.
ColorSourceHandle = findobj(CurrentImage,'Tag','ColorSourceAxis');
if size(ColorSourceHandle) ~= 0
   handles.ColorSourceHandle = ColorSourceHandle; 
else 
    ColorSourceHandle = handles.ColorSourceHandle;
end
axes(ColorSourceHandle);
cla reset;
set(ColorSourceHandle,'Visible','off');
%设置源图像直方图坐标轴.
HistSourceHandle = findobj(CurrentImage,'Tag','HistSourceAxis');
if size(HistSourceHandle) ~= 0
   handles.HistSourceHandle = HistSourceHandle; 
else 
    HistSourceHandle = handles.HistSourceHandle;
end
axes(HistSourceHandle);
cla reset;
set(HistSourceHandle,'Visible','off');
%设置源图像辐照度坐标轴.
LuminanceSourceHandle = findobj(CurrentImage,'Tag','LuminanceSourceAxis');
if size(LuminanceSourceHandle) ~= 0
   handles.LuminanceSourceHandle = LuminanceSourceHandle; 
else 
    LuminanceSourceHandle = handles.LuminanceSourceHandle;
end
axes(LuminanceSourceHandle);
cla reset;
set(LuminanceSourceHandle,'Visible','off')
% 设置源面板.
SourcePanelHandle = findobj('Tag','SourcePanel');
if size(SourcePanelHandle) ~= 0
   handles.SourcePanelHandle = SourcePanelHandle; 
else 
   SourcePanelHandle = handles.SourcePanelHandle;
end
set(SourcePanelHandle,'Visible','off');
%设置匹配图像坐标轴.
ColorMatchedHandle = findobj(CurrentImage,'Tag','ColorMatchedAxis');
if size(ColorMatchedHandle) ~= 0
   handles.ColorMatchedHandle = ColorMatchedHandle; 
else 
    ColorMatchedHandle = handles.ColorMatchedHandle;
end
axes(ColorMatchedHandle);
cla reset;
set(ColorMatchedHandle,'Visible','off');
%设置匹配图像直方图坐标轴.
HistMatchedHandle = findobj(CurrentImage,'Tag','HistMatchedAxis');
if size(HistMatchedHandle) ~= 0
   handles.HistMatchedHandle = HistMatchedHandle; 
else 
    HistMatchedHandle = handles.HistMatchedHandle;
end
axes(HistMatchedHandle);
cla reset;
set(HistMatchedHandle,'Visible','off');
%设置匹配图像辐照度坐标轴.
LuminanceMatchedHandle = findobj(CurrentImage,'Tag','LuminanceMatchedAxis');
if size(LuminanceMatchedHandle) ~= 0
   handles.LuminanceMatchedHandle = LuminanceMatchedHandle; 
else 
    LuminanceMatchedHandle = handles.LuminanceMatchedHandle;
end
axes(LuminanceMatchedHandle);
cla reset;
set(LuminanceMatchedHandle,'Visible','off');
% 设置匹配面板.
ResultPanelHandle = findobj('Tag','ResultPanel');
if size(ResultPanelHandle) ~= 0
   handles.ResultPanelHandle = ResultPanelHandle; 
else 
   ResultPanelHandle = handles.ResultPanelHandle;
end
set(ResultPanelHandle,'Visible','off');

% 显示对比面板,
ContrastPanelHandle = findobj('Tag','ContrastPanel');
if size(ContrastPanelHandle) ~= 0
   handles.ContrastPanelHandle = ContrastPanelHandle; 
else 
   ContrastPanelHandle = handles.ContrastPanelHandle;
end
set(ContrastPanelHandle,'Visible','on');

% 显示左对照面板.
LeftContrastHandle = findobj('Tag','LeftContrast');
if size(LeftContrastHandle) ~= 0
   handles.LeftContrastHandle = LeftContrastHandle; 
else 
   LeftContrastHandle = handles.LeftContrastHandle;
end
set(LeftContrastHandle,'Visible','on');
% 显示左图像坐标轴.
ImageLeftAxisHandle = findobj('Tag','ImageLeftAxis');
if size(ImageLeftAxisHandle) ~= 0
   handles.ImageLeftAxisHandle = ImageLeftAxisHandle; 
else 
   ImageLeftAxisHandle = handles.ImageLeftAxisHandle;
end
set(ImageLeftAxisHandle,'Visible','on');
axes(ImageLeftAxisHandle);
cla reset;
ContrastLeftPopMenuHandle = findobj(gcf,'Tag','ContrastLeftPopMenu');
ListName = get(ContrastLeftPopMenuHandle,'UserData');
sname = char(ListName(get(ContrastLeftPopMenuHandle,'Value')));
s = imread(sname);
imshow(s);

% 显示右对照面板.
RightContrastHandle = findobj('Tag','RightContrast');
if size(RightContrastHandle) ~= 0
   handles.RightContrastHandle = RightContrastHandle; 
else 
   RightContrastHandle = handles.RightContrastHandle;
end
set(RightContrastHandle,'Visible','on');
% 显示右图像坐标轴.
ImageRightAxisHandle = findobj('Tag','ImageRightAxis');
if size(ImageRightAxisHandle) ~= 0
   handles.ImageRightAxisHandle = ImageRightAxisHandle; 
else 
   ImageRightAxisHandle = handles.ImageRightAxisHandle;
end
set(ImageRightAxisHandle,'Visible','on');
axes(ImageRightAxisHandle);
cla reset;
g = imread('辐照度迁移结果.jpg');
imshow(g);

% 显示对照控制面板.
ContrastControlPanelHandle = findobj('Tag','ContrastControlPanel');
set(ContrastControlPanelHandle,'Visible','on');
ChannelControlPanelHandle = findobj('Tag','ChannelControlPanel');
set(ChannelControlPanelHandle,'Visible','on');
LHandle = findobj('Tag','L');
set(LHandle,'Visible','on');
AHandle = findobj('Tag','A');
set(AHandle,'Visible','on');
BHandle = findobj('Tag','B');
set(BHandle,'Visible','on');
SliderLHandle = findobj('Tag','SliderL');
set(SliderLHandle,'Visible','on');
SliderAHandle = findobj('Tag','SliderA');
set(SliderAHandle,'Visible','on');
SliderBHandle = findobj('Tag','SliderB');
set(SliderBHandle,'Visible','on');
TextLHandle = findobj('Tag','TextL');
set(TextLHandle,'Visible','on');
TextAHandle = findobj('Tag','TextA');
set(TextAHandle,'Visible','on');
TextBHandle = findobj('Tag','TextB');
set(TextBHandle,'Visible','on');
text18Handle = findobj('Tag','text18');
set(text18Handle,'Visible','on');
text22Handle = findobj('Tag','text22');
set(text22Handle,'Visible','on');
text20Handle = findobj('Tag','text20');
set(text20Handle,'Visible','on');
IntialScailingHandle = findobj('Tag','IntialScailing');
set(IntialScailingHandle,'Visible','on');
EndScailingHandle = findobj('Tag','EndScailing');
set(EndScailingHandle,'Visible','on');
SaveImagesHandle = findobj('Tag','SaveImages');
set(SaveImagesHandle,'Visible','on');
BeginAjustHandle = findobj('Tag','BeginAjust');
set(BeginAjustHandle,'Visible','on');
greenTextHandle = findobj('Tag','greenText');
set(greenTextHandle,'Visible','on');
redtextHandle = findobj('Tag','redtext');
set(redtextHandle,'Visible','on');
bluetextHandle = findobj('Tag','bluetext');
set(bluetextHandle,'Visible','on');
yellowtextHandle = findobj('Tag','yellowtext');
set(yellowtextHandle,'Visible','on');
% Hint: get(hObject,'Value') returns toggle state of ContrastButton


% --- Executes on selection change in ContrastLeftPopMenu.
function ContrastLeftPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastLeftPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImageLeftAxisHandle = findobj('Tag','ImageLeftAxis');
if size(ImageLeftAxisHandle) ~= 0
   handles.ImageLeftAxisHandle = ImageLeftAxisHandle; 
else 
   ImageLeftAxisHandle = handles.ImageLeftAxisHandle;
end
axes(ImageLeftAxisHandle);
cla reset;
ContrastLeftPopMenuHandle = findobj(gcf,'Tag','ContrastLeftPopMenu');
ListName = get(ContrastLeftPopMenuHandle,'UserData');
lname = char(ListName(get(ContrastLeftPopMenuHandle,'Value')));
l = imread(lname);
imshow(l);
% Hints: contents = cellstr(get(hObject,'String')) returns ContrastLeftPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ContrastLeftPopMenu


% --- Executes during object creation, after setting all properties.
function ContrastLeftPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ContrastLeftPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ContrastRightPopMenu.
function ContrastRightPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastRightPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImageRightAxisHandle = findobj('Tag','ImageRightAxis');
if size(ImageRightAxisHandle) ~= 0
   handles.ImageRightAxisHandle = ImageRightAxisHandle; 
else 
   ImageRightAxisHandle = handles.ImageRightAxisHandle;
end
axes(ImageRightAxisHandle);
ContrastRightPopMenuHandle = findobj(gcf,'Tag','ContrastRightPopMenu');
ListName = get(ContrastRightPopMenuHandle,'UserData');
rname = char(ListName(get(ContrastRightPopMenuHandle,'Value')));
r = imread(rname);
imshow(r);
% Hints: contents = cellstr(get(hObject,'String')) returns ContrastRightPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ContrastRightPopMenu


% --- Executes during object creation, after setting all properties.
function ContrastRightPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ContrastRightPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function SliderL_Callback(hObject, eventdata, handles)
% hObject    handle to SliderL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LuminanceValue = get(hObject,'Value');
TextLHandle = findobj(gcf,'Tag','TextL');
set(TextLHandle,'String',ceil(LuminanceValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function TextL_Callback(hObject, eventdata, handles)
% hObject    handle to TextL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LValue = get(hObject,'String');
SliderLHandle = findobj(gcf,'Tag','SliderL');
set(SliderLHandle,'Value',ceil(str2double(LValue)));
% Hints: get(hObject,'String') returns contents of TextL as text
%        str2double(get(hObject,'String')) returns contents of TextL as a double


% --- Executes during object creation, after setting all properties.
function TextL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TextL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function SliderA_Callback(hObject, eventdata, handles)
% hObject    handle to SliderA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AValue = get(hObject,'Value');
TextAHandle = findobj(gcf,'Tag','TextA');
set(TextAHandle,'String',ceil(AValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function TextA_Callback(hObject, eventdata, handles)
% hObject    handle to TextA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AValue = get(hObject,'String');
SliderAHandle = findobj(gcf,'Tag','SliderA');
set(SliderAHandle,'Value',ceil(str2double(AValue)));
% Hints: get(hObject,'String') returns contents of TextA as text
%        str2double(get(hObject,'String')) returns contents of TextA as a double


% --- Executes during object creation, after setting all properties.
function TextA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TextA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function SliderB_Callback(hObject, eventdata, handles)
% hObject    handle to SliderB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BValue = get(hObject,'Value');
TextBHandle = findobj(gcf,'Tag','TextB');
set(TextBHandle,'String',ceil(BValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function TextB_Callback(hObject, eventdata, handles)
% hObject    handle to TextB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BValue = get(hObject,'String');
SliderBHandle = findobj(gcf,'Tag','SliderB');
set(SliderBHandle,'Value',ceil(str2double(BValue)));
% Hints: get(hObject,'String') returns contents of TextB as text
%        str2double(get(hObject,'String')) returns contents of TextB as a double


% --- Executes during object creation, after setting all properties.
function TextB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TextB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveImages.
function SaveImages_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dirname = uigetdir('C:\Users\devil\Desktop\实验结果','浏览文件夹');
ContrastLeftPopMenuHandle = findobj('Tag','ContrastLeftPopMenu');
UserData = get(ContrastLeftPopMenuHandle,'UserData');
ContrastRightPopMenuHandle = findobj(gcf,'Tag','ContrastRightPopMenu');
ListName = get(ContrastRightPopMenuHandle,'UserData');
CurrentName = char(ListName(get(ContrastRightPopMenuHandle,'Value')));
t = imread(char(UserData(1)));
TargetName = strcat(dirname,'\','1.参考图像.jpg');
imwrite(t,TargetName);
s = imread(char(UserData(2)));
SourceName = strcat(dirname,'\','2.源图像.jpg');
imwrite(s,SourceName);
l = imread(char(UserData(3)));
if strcmp(CurrentName,'辐照度迁移结果.jpg') == 1
   LuminanceName = strcat(dirname,'\','3-1.辐照度迁移图像.jpg');
   imwrite(l,LuminanceName);
end
h = imread(char(UserData(4)));
if strcmp(CurrentName,'色调同步结果.jpg') == 1
   HuesyncName = strcat(dirname,'\','4-1.色调同步图像.jpg');
   imwrite(h,HuesyncName);
end

% --- Executes on button press in ControlOpenSwitch.
function ControlOpenSwitch_Callback(hObject, eventdata, handles)
% hObject    handle to ControlOpenSwitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImageLeftAxisHandle = findobj('Tag','ImageLeftAxis');
axes(ImageLeftAxisHandle);
s = imread(handles.sname);
imshow(s);
ImageLeftAxisHandle = findobj('Tag','ImageLeftAxis');
axes(ImageLeftAxisHandle);
s = imread(handles.sname);
imshow(s);

% Hint: get(hObject,'Value') returns toggle state of ControlOpenSwitch


% --- Executes on button press in BeginAjust.
function BeginAjust_Callback(hObject, eventdata, handles)
% hObject    handle to BeginAjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ContrastRightPopMenuHandle = findobj(gcf,'Tag','ContrastRightPopMenu');
ListName = get(ContrastRightPopMenuHandle,'UserData');
rname = char(ListName(get(ContrastRightPopMenuHandle,'Value')));
if strcmp(rname,'辐照度迁移结果.jpg') == 1 || strcmp(rname,'色调同步结果.jpg')
   if strcmp(rname,'辐照度迁移结果.jpg') == 1
       f = handles.Luminance_Result_image;
   else
       f = handles.Huesync_Result_image;
   end
   LAB = RGB2Lab(f);
   TextLHandle = findobj('Tag','TextL');
   LScale = get(TextLHandle,'String');
   LScale = str2double(LScale)/100;
   TextAHandle = findobj('Tag','TextA');
   AScale = get(TextAHandle,'String');
   AScale = str2double(AScale)/100;
   TextBHandle = findobj('Tag','TextB');
   BScale = get(TextBHandle,'String');
   BScale = str2double(BScale)/100;
   LuminanceImage = Lab2RGB(LAB(:,:,1)*LScale,LAB(:,:,2)*AScale,LAB(:,:,3)*BScale);
   if strcmp(rname,'辐照度迁移结果.jpg') == 1
      imwrite(LuminanceImage,'辐照度迁移结果.jpg');
   else
      imwrite(LuminanceImage,'色调同步结果.jpg');
   end
end
if strcmp(rname,'辐照度迁移结果.jpg') == 1 || strcmp(rname,'色调同步结果.jpg')
ImageRightAxisHandle = findobj('Tag','ImageRightAxis');
if size(ImageRightAxisHandle) ~= 0
   handles.ImageRightAxisHandle = ImageRightAxisHandle; 
else 
   ImageRightAxisHandle = handles.ImageRightAxisHandle;
end
axes(ImageRightAxisHandle);
g =  imread(rname);
imshow(g);
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dirname = uigetdir('C:\Users\devil\Desktop\实验结果','浏览文件夹');
ContrastLeftPopMenuHandle = findobj('Tag','ContrastLeftPopMenu');
UserData = get(ContrastLeftPopMenuHandle,'UserData');
t = imread(char(UserData(1)));
TargetName = strcat(dirname,'\','1.参考图像.jpg');
imwrite(t,TargetName);
s = imread(char(UserData(2)));
SourceName = strcat(dirname,'\','2.源图像.jpg');
imwrite(s,SourceName);
l = imread(char(UserData(3)));
LuminanceName = strcat(dirname,'\','3.辐照度迁移图像.jpg');
imwrite(l,LuminanceName);
h = imread(char(UserData(4)));
HuesyncName = strcat(dirname,'\','4.色调同步图像.jpg');
imwrite(h,HuesyncName);
