function varargout = ColorGrading(varargin)
%%-----------------------------------------------------------------------  
% ColorGrading.
% Author: ������
% CreateTime: 2015-01-29 
%%------------------------------------------------------------------------  
%% ��ʼ������,����༭.
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ColorGrading_OpeningFcn, ...
                   'gui_OutputFcn',  @ColorGrading_OutputFcn, ...
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
function ColorGrading_OpeningFcn(hObject, eventdata, handles, varargin)
global MainColor
global SecondaryColor
MainColor = [0.804,0.878,0.969];
SecondaryColor  = [0.831,0.816,0.784];
handles.output = hObject;
guidata(hObject, handles);
InitialAxes(handles);


%% ��������ص�������.
function varargout = ColorGrading_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%% ����л�.
% �л�������ͼ���.
function SkeletonPanel_ButtonDownFcn(hObject, eventdata, handles)
SwitchSkeletonPanel(handles);
function SkeletonText_ButtonDownFcn(hObject, eventdata, handles)
SwitchSkeletonPanel(handles);
% �л���ϸ��ͼ���.
function DetailText_ButtonDownFcn(hObject, eventdata, handles)
SwitchDetailPanel(handles);
function DetailPanel_ButtonDownFcn(hObject, eventdata, handles)
SwitchDetailPanel(handles);
% �л��ؼ�֡���.
function KeyFrameText_ButtonDownFcn(hObject, eventdata, handles)
SwitchKeyFramePanel(handles);
function KeyFramePanel_ButtonDownFcn(hObject, eventdata, handles)
SwitchKeyFramePanel(handles);


% ���ƹ�������л�.
function SwitchSkeletonPanel(handles)
global MainColor
global SecondaryColor

set(handles.SkeletonPanel,'BackgroundColor',MainColor);
set(handles.SkeletonPanel,'BorderType','beveledout');
set(handles.SkeletonText,'BackgroundColor',MainColor);

set(handles.DetailPanel,'BackgroundColor',SecondaryColor);
set(handles.DetailPanel,'BorderType','beveledin');
set(handles.DetailText,'BackgroundColor',SecondaryColor);

set(handles.KeyFramePanel,'BackgroundColor',SecondaryColor);
set(handles.KeyFramePanel,'BorderType','beveledin');
set(handles.KeyFrameText,'BackgroundColor',SecondaryColor);

set(handles.TransitionSkeleton,'Visible','on');
set(handles.TransitionDetail,'Visible','off');
set(handles.TransitionKeyframe,'Visible','off');

DisplaySkeletonPanel(handles,1);
DisplayDetailPanel(handles,0);
DisplayKeyFramePanel(handles,0);

%������ϸ����л�.
function SwitchDetailPanel(handles)
global MainColor
global SecondaryColor

set(handles.DetailPanel,'BackgroundColor',MainColor);
set(handles.DetailPanel,'BorderType','beveledout');
set(handles.DetailText,'BackgroundColor',MainColor);

set(handles.SkeletonPanel,'BackgroundColor',SecondaryColor);
set(handles.SkeletonPanel,'BorderType','beveledin');
set(handles.SkeletonText,'BackgroundColor',SecondaryColor);

set(handles.KeyFramePanel,'BackgroundColor',SecondaryColor);
set(handles.KeyFramePanel,'BorderType','beveledin');
set(handles.KeyFrameText,'BackgroundColor',SecondaryColor);

set(handles.TransitionSkeleton,'Visible','off');
set(handles.TransitionDetail,'Visible','on');
set(handles.TransitionKeyframe,'Visible','off');

DisplaySkeletonPanel(handles,0);
DisplayDetailPanel(handles,1);
DisplayKeyFramePanel(handles,0);
FillDetailPopMemuData(handles.LeftImage);
FillDetailPopMemuData(handles.RightImage);

%���ƹؼ�֡����л�.
function SwitchKeyFramePanel(handles)
global MainColor
global SecondaryColor

set(handles.DetailPanel,'BackgroundColor',SecondaryColor);
set(handles.DetailPanel,'BorderType','beveledin');
set(handles.DetailText,'BackgroundColor',SecondaryColor);

set(handles.SkeletonPanel,'BackgroundColor',SecondaryColor);
set(handles.SkeletonPanel,'BorderType','beveledin');
set(handles.SkeletonText,'BackgroundColor',SecondaryColor);

set(handles.KeyFramePanel,'BackgroundColor',MainColor);
set(handles.KeyFramePanel,'BorderType','beveledout');
set(handles.KeyFrameText,'BackgroundColor',MainColor);

set(handles.TransitionSkeleton,'Visible','off');
set(handles.TransitionDetail,'Visible','off');
set(handles.TransitionKeyframe,'Visible','on');

DisplaySkeletonPanel(handles,0);
DisplayDetailPanel(handles,0);
DisplayKeyFramePanel(handles,1);

%����ϸ����ʾ�������.
function DisplaySkeletonPanel(handles, DisplayOpen)
if DisplayOpen == 1
    set(handles.TargetPanel,'Visible','on'); 
    set(handles.SourcePanel,'Visible','on');
    set(handles.ResultPanel,'Visible','on');
    set(handles.SkeletonStatusPanel,'Visible','on');
    set(handles.ControlPanel,'Visible','on');
else
    set(handles.TargetPanel,'Visible','off'); 
    set(handles.SourcePanel,'Visible','off');
    set(handles.ResultPanel,'Visible','off');
    set(handles.SkeletonStatusPanel,'Visible','off');
    set(handles.ControlPanel,'Visible','off');
end

function DisplayDetailPanel(handles,DisplayOpen)
if  DisplayOpen == 1
    set(handles.DetailDisplayPanel,'Visible','on');
else
    set(handles.DetailDisplayPanel,'Visible','off');
end

%�ؼ�֡��ʾ�������.
function DisplayKeyFramePanel(handles, DisplayOpen)

function InitialAxes(handles)
% Դͼ���ɰ������ص�����.
set(handles.ColorTargetAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.HistTargetAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.LuminanceTargetAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.ColorSourceAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.HistSourceAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.LuminanceSourceAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.ColorMatchedAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.HistMatchedAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.LuminanceMatchedAxis,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.SourcePreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.SourceMattePreview,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetPreview1,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetMattePreview1,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetPreview2,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.TargetMattePreview2,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.ContrastLeft,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
set(handles.ContrastRight,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);


% ����Դͼ���ɰ�����.
function SourceMatteCheck_Callback(hObject, eventdata, handles)

%% ���Ԥ�����ں������˵�.
% ���Ԥ������.
function FillPreviewWindow(hObject, AxesHandle)
ListName = get(hObject,'UserData');
CurrentImageName = char(ListName(get(hObject,'Value')));
CurImage = imread(strcat('Images\',CurrentImageName));
axes(AxesHandle);
imshow(CurImage);

% ��ȡPopMenu�µ�����.
function FillPopMemuData(hObject, ImageName)
dirs1 = dir('Images\*.jpg');
dirs2 = dir('Images\*.bmp');
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
        if strcmp(char(filenames(i)),ImageName)==1
            break;
        end
    end
end
set(hObject,'String',ListImage);
set(hObject,'UserData',filenames);
set(hObject,'Value',i);


% ��ʼ��PopMenu.
% Դͼ������.
function SourcePopMenu_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject,handles.SourcePreview);
function SourcePopMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);


% Դͼ���ɰ�����.
function SourceMattePopMenu_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject,handles.SourceMattePreview);
function SourceMattePopMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);

% Ŀ������1.
function TargetPopMenu1_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject,handles.TargetPreview1);
function TargetPopMenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);

% Ŀ���ɰ�����1.
function TargetMattePopMenu1_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject,handles.TargetMattePreview1);
function TargetMattePopMenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);

% Ŀ������2.
function TargetPopMenu2_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject,handles.TargetPreview2);
function TargetPopMenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);

% Ŀ���ɰ�����2.
function TargetMattePopMenu2_Callback(hObject, eventdata, handles)
FillPreviewWindow(hObject,handles.TargetMattePreview2);
function TargetMattePopMenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillPopMemuData(hObject);


%% ������Ⱦ.
function Render_Callback(hObject, eventdata, handles)
%% �������ݳ��μ���.
ListName = get(handles.SourcePopMenu,'UserData');
sname = char(ListName(get(handles.SourcePopMenu,'Value')));
Source = imread(sname);
if  get(handles.SourceMatteCheck,'Value') == 1
    OpenMatteS = 1;
    ListName = get(handles.SourceMattePopMenu,'UserData');
    smname = char(ListName(get(handles.SourceMattePopMenu,'Value')));
    MatteS = imread(smname);
else
    OpenMatteS = 0;
    MatteS = 0;
end

ListName = get(handles.TargetPopMenu1,'UserData');
tname = char(ListName(get(handles.TargetPopMenu1,'Value')));
Target = imread(tname);
if  get(handles.TargetMatteCheck1,'Value') == 1
    OpenMatteT = 1;
    ListName = get(handles.TargetMattePopMenu1,'UserData');
    tmname = char(ListName(get(handles.TargetMattePopMenu1,'Value')));
    MatteT = imread(tmname);
else
    OpenMatteT = 0;
    MatteT = 0;
end
[WholeLuminOnlyResult, WholeHueOnlyResult, WholeHueSynResult, LuminaOnlyResult, HueOnlyResult, HueSynResult,rs ,rt, ls, lsh, lt, lth, lr, lrh, SynSL, SynRL] = ...
LocalTransformation(Target, Source, OpenMatteT, OpenMatteS, MatteT, MatteS,1,0.1);
handles.WholeLuminOnlyResult = WholeLuminOnlyResult;
handles.WholeHueOnlyResult =WholeHueOnlyResult;
handles.WholeHueSynResult = WholeHueSynResult;
handles.LuminaOnlyResult = LuminaOnlyResult;
handles.HueOnlyResult = HueOnlyResult;
handles.HueSynResult = HueSynResult;
% ����ü����Դͼ�����ɰ��򱣴�ԭʼԴͼ��.
handles.rs = rs;
% ����ü����Ŀ��ͼ�����ɰ��򱣴�ԭʼĿ��ͼ��.
handles.rt = rt;
% ����ü���Դͼ���ֱ��ͼ�ֲ�.
handles.ls = ls;
handles.lsh = lsh;
% ����ü���Ŀ��ͼ���ֱ��ͼ�ֲ�.
handles.lt = lt;
handles.lth = lth;
% ����ü�����ͼ���ֱ��ͼ�ֲ�.
handles.lr = lr;
handles.lrh = lrh;
% ����δ�ü�ͼ���Lͨ������.
handles.SynSL = SynSL;
% ����δ�ü�ͼ���ɰ�����������Lͨ������.
handles.SynRL = SynRL;
handles.Source = Source;

%% ���������ٴμ���.
if  get(handles.SourceMatteCheck,'Value') == 1 && get(handles.SourceBackSyn,'Value') == 1
    SourceAgain = Source;
    SourceMAgain = 255 - MatteS;
    OpenMatteS = 1;
    if  get(handles.TargetMatteCheck1,'Value') == 1 && get(handles.TargetBackSyn,'Value') == 1 
        TargetAgain = Target;
        TargetMAgain = 255 -MatteT;
        OpenMatteT = 1;
    else
        ListName = get(handles.TargetPopMenu2,'UserData');
        tname = char(ListName(get(handles.TargetPopMenu2,'Value')));
        TargetAgain = imread(tname);
        if  get(handles.TargetMatteCheck2,'Value') == 1
            ListName = get(handles.TargetMattePopMenu2,'UserData');
            tmname = char(ListName(get(handles.TargetMattePopMenu2,'Value')));
            TargetMAgain = imread(tmname);
            OpenMatteT = 1;
        else
            TargetMAgain = 0;
            OpenMatteT = 0;
        end
    end
    [WholeLuminOnlyResultAgain, WholeHueOnlyResultAgain, WholeHueSynResultAgain, LuminaOnlyResultAgain, HueOnlyResultAgain, HueSynResultAgain,rsa ,rta, lsa, lsha, lta, ltha, lra, lrha] = ...
    LocalTransformation(TargetAgain, SourceAgain, OpenMatteT, OpenMatteS, TargetMAgain, SourceMAgain, 1, 0.1);
    handles.WholeLuminOnlyResultAgain = WholeLuminOnlyResultAgain;
    handles.WholeHueOnlyResultAgain = WholeHueOnlyResultAgain;
    handles.WholeHueSynResultAgain = WholeHueSynResultAgain;
    handles.LuminaOnlyResultAgain = LuminaOnlyResultAgain;
    handles.HueOnlyResultAgain = HueOnlyResultAgain;
    handles.HueSynResultAgain = HueSynResultAgain; 
    handles.rsa = rsa;
    handles.rta = rta;
    handles.lsa = lsa;
    handles.lsha = lsha;
    handles.lta = lta;
    handles.ltha = ltha;
    handles.lra = lra;
    handles.lrha = lrha;
    CompositeLuminOnlyResult = CatImageMatteRegion(WholeLuminOnlyResult, WholeLuminOnlyResultAgain, MatteS);
    handles.CompositeLuminOnly = CompositeLuminOnlyResult;
    CompostiteHueOnlyResult =  CatImageMatteRegion(WholeHueOnlyResult, WholeHueOnlyResultAgain, MatteS);
    handles.CompostiteHueOnlyResult =CompostiteHueOnlyResult;
    CompositeHueSynResult = CatImageMatteRegion(WholeHueSynResult, WholeHueSynResultAgain, MatteS);
    handles.CompositeHueSynResult = CompositeHueSynResult;
end
guidata(hObject, handles);
ShowSourceAndResultPanel(handles);
ShowTargetPanel(handles);


%% ��ʾԴͼ��ͽ�����.
function ShowSourceAndResultPanel(handles)
% ��ʾԴͼ��ͽ��ͼ�����.
if  get(handles.SourceForegroundButton,'Value') == 1
    axes(handles.ColorSourceAxis);
    imshow(handles.rs);
    axes(handles.HistSourceAxis);
    LuminanceSourceHist = im2uint8(mat2gray(handles.lsh,[0 100]));
    imhist(LuminanceSourceHist);
    axes(handles.LuminanceSourceAxis);
    LuminanceSource = im2uint8(mat2gray(handles.ls,[0 100]));
    imshow(LuminanceSource);

    axes(handles.ColorMatchedAxis);
    imshow(handles.HueSynResult);
    axes(handles.HistMatchedAxis);
    LuminanceResultHist = im2uint8(mat2gray(handles.lrh,[0 100]));
    imhist(LuminanceResultHist);
    axes(handles.LuminanceMatchedAxis);
    LuminanceResult =  im2uint8(mat2gray(handles.lr,[0 100]));
    imshow(LuminanceResult);
else if get(handles.SourceBackgroundButton,'Value') == 1
        axes(handles.ColorSourceAxis);
        imshow(handles.rsa);
        axes(handles.HistSourceAxis);
        LuminanceSourceHist = im2uint8(mat2gray(handles.lsha,[0 100]));
        imhist(LuminanceSourceHist);
        axes(handles.LuminanceSourceAxis);
        LuminanceSource = im2uint8(mat2gray(handles.lsa,[0 100]));
        imshow(LuminanceSource);

        axes(handles.ColorMatchedAxis);
        imshow(handles.HueSynResultAgain);
        axes(handles.HistMatchedAxis);
        LuminanceResultHist = im2uint8(mat2gray(handles.lrha,[0 100]));
        imhist(LuminanceResultHist);
        axes(handles.LuminanceMatchedAxis);
        LuminanceResult =  im2uint8(mat2gray(handles.lra,[0 100]));
        imshow(LuminanceResult);
    else if get(handles.SourceSynButton,'Value') == 1
        axes(handles.ColorSourceAxis);
        imshow(handles.Source);
        axes(handles.HistSourceAxis);
        LuminanceSourceHist = im2uint8(mat2gray(handles.SynSL,[0 100]));
        imhist(LuminanceSourceHist);
        axes(handles.LuminanceSourceAxis);
        imshow(LuminanceSourceHist);

        %��Ҫ����.
        axes(handles.ColorMatchedAxis);
        imshow(handles.CompositeHueSynResult);
        axes(handles.HistMatchedAxis);
        LuminanceResultHist = im2uint8(mat2gray(handles.SynRL,[0 100]));
        imhist(LuminanceResultHist);
        axes(handles.LuminanceMatchedAxis);
        imshow(LuminanceResultHist);
        end
    end
end
    
%% ��ʾĿ��ͼ�����.
function ShowTargetPanel(handles)
if  get(handles.TargetForegroundButton,'Value') == 1
    axes(handles.ColorTargetAxis);
    imshow(handles.rt);
    axes(handles.HistTargetAxis);
    LuminanceTargetHist = im2uint8(mat2gray(handles.lth,[0 100]));
    imhist(LuminanceTargetHist);
    axes(handles.LuminanceTargetAxis);
    LuminanceTarget =  im2uint8(mat2gray(handles.lt,[0 100]));
    imshow(LuminanceTarget);
else if get(handles.TargetBackgroundButton,'Value') == 1
        axes(handles.ColorTargetAxis);
        imshow(handles.rta);
        axes(handles.HistTargetAxis);
        LuminanceTargetHist = im2uint8(mat2gray(handles.ltha,[0 100]));
        imhist(LuminanceTargetHist);
        axes(handles.LuminanceTargetAxis);
        LuminanceTarget =  im2uint8(mat2gray(handles.lta,[0 100]));
        imshow(LuminanceTarget);
    end
end

% ����ָ����ͼ��.
function Save_Callback(hObject, eventdata, handles)
dirname = uigetdir('C:\Users\devil\Desktop\����','����ļ���');
deleteName = strcat(dirname,'\*.jpg');
delete(deleteName);
name = strcat(dirname,'\','00.ԭʼͼ��.jpg');
imwrite(handles.Source,name);
name = strcat(dirname,'\','01.Դǰ��ͼ��.jpg');
imwrite(handles.rs,name);
name = strcat(dirname,'\','02.Ŀ��ǰ��ͼ��.jpg');
imwrite(handles.rt,name);
name = strcat(dirname,'\','03.ǰ��ɫ��ͬ��ͼ��.jpg');
imwrite(handles.HueSynResult,name);
name = strcat(dirname,'\','04.ǰ�����ն�ͼ��.jpg');
imwrite(handles.LuminaOnlyResult,name);
name = strcat(dirname,'\','05.ǰ��ɫ��ͼ��.jpg');
imwrite(handles.HueOnlyResult,name);
if  get(handles.SourceMatteCheck,'Value') == 1
    name = strcat(dirname,'\','06.����ǰ��ɫ��ͬ��ͼ��.jpg');
    imwrite(handles.WholeHueSynResult,name);
    name = strcat(dirname,'\','07.����ǰ�����ն�ͼ��.jpg');
    imwrite(handles.WholeLuminOnlyResult,name);
    name = strcat(dirname,'\','08.����ǰ��ɫ��ͼ��.jpg');
    imwrite(handles.WholeHueOnlyResult,name);
end
if  get(handles.SourceMatteCheck,'Value') == 1 && get(handles.SourceBackSyn,'Value') == 1
    name = strcat(dirname,'\','09.Դ����ͼ��.jpg');
    imwrite(handles.rsa,name);
    name = strcat(dirname,'\','10.Ŀ�걳��ͼ��.jpg');
    imwrite(handles.rta,name);
    name = strcat(dirname,'\','11.����ɫ��ͬ��ͼ��.jpg');
    imwrite(handles.HueSynResultAgain,name);
    name = strcat(dirname,'\','12.�������ն�ͼ��.jpg');
    imwrite(handles.LuminaOnlyResultAgain,name);
    name = strcat(dirname,'\','13.����ɫ��ͼ��.jpg');
    imwrite(handles.HueOnlyResultAgain,name);
    name = strcat(dirname,'\','14.��������ɫ��ͬ��ͼ��.jpg');
    imwrite(handles.WholeHueSynResultAgain,name);
    name = strcat(dirname,'\','15.�����������ն�ͼ��.jpg');
    imwrite(handles.WholeLuminOnlyResultAgain,name);
    name = strcat(dirname,'\','16.��������ɫ��ͼ��.jpg');
    imwrite(handles.WholeHueOnlyResultAgain,name);
    name = strcat(dirname,'\','17.���ɫ��ͬ��ͼ��.jpg');
    imwrite(handles.CompositeHueSynResult,name);
    name = strcat(dirname,'\','18.������ն�ͼ��.jpg');
    imwrite(handles.CompositeLuminOnly,name);
    name = strcat(dirname,'\','19.���ɫ��ͼ��.jpg');
    imwrite(handles.CompostiteHueOnlyResult,name);
end



% ѡ����ͼ������.
function ResultTypeSelect_Callback(hObject, eventdata, handles)
axes(handles.ColorMatchedAxis);
ListNumber = get(hObject,'UserData');
if  ListNumber(get(hObject,'Value')) == 2
    if  get(handles.SourceForegroundButton,'Value') == 1
        imshow(handles.LuminaOnlyResult);
    else if get(handles.SourceBackgroundButton,'Value') == 1
            imshow(handles.LuminaOnlyResultAgain);
        else if get(handles.SourceSynButton,'Value') == 1
                imshow(handles.WholeLuminOnlyResult);
            end
        end
    end
else if ListNumber(get(hObject,'Value')) == 1
         if  get(handles.SourceForegroundButton,'Value') == 1
            imshow(handles.HueSynResult);
         else if get(handles.SourceBackgroundButton,'Value') == 1
                imshow(handles.HueSynResultAgain);
             else if get(handles.SourceSynButton,'Value') == 1
                    imshow(handles.WholeHueSynResultAgain);
                 end
             end
         end
    else if ListNumber(get(hObject,'Value')) == 3
             if  get(handles.SourceForegroundButton,'Value') == 1
                imshow(handles.HueOnlyResult);
             else if get(handles.SourceBackgroundButton,'Value') == 1
                    imshow(handles.HueOnlyResultAgain);
                 else if get(handles.SourceSynButton,'Value') == 1
                        imshow(handles.WholeHueOnlyResultAgain);
                     end
                 end
             end
        end
    end
end


function ResultTypeSelect_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
ListImage = 'ɫ��ͬ��ͼ��|���ն�ͼ��|ɫ��ͼ��';
filenames = [1 2 3];
set(hObject,'String',ListImage);
set(hObject,'UserData',filenames);
set(hObject,'Value',1);


% ����Ŀ���ɰ�1.
function TargetMatteCheck1_Callback(hObject, eventdata, handles)

% ����Ŀ������ͬ��.
function TargetBackSyn_Callback(hObject, eventdata, handles)

% ����Ŀ���ɰ�2.
function TargetMatteCheck2_Callback(hObject, eventdata, handles)

% ����ԭͼ��ǰ���ɰ�ͬ��.
function SourceBackSyn_Callback(hObject, eventdata, handles)
SourceBackSynSwitch  = get(handles.SourceBackSyn,'Value');
if  SourceBackSynSwitch == 0
    set(handles.TargetPopMenu2,'Enable','off');
    set(handles.TargetMattePopMenu2,'Enable','off');
    set(handles.TargetMatteCheck2,'Enable','off');
    set(handles.SourceBackgroundButton,'Enable','off');
    set(handles.SourceSynButton,'Enable','off');
    set(handles.TargetBackgroundButton,'Enable','off');
    axes(handles.TargetPreview2);
    cla reset;
    set(handles.TargetPreview2,...
    'Units','Pixels',...
    'XTick',[],'YTick',[]);
    axes(handles.TargetMattePreview2);
    cla reset;
    set(handles.TargetMattePreview2,...
        'Units','Pixels',...
        'XTick',[],'YTick',[]);
else
    if  get(handles.SourceMatteCheck,'Value') == 1
        set(handles.TargetPopMenu2,'Enable','on');
        set(handles.TargetMattePopMenu2,'Enable','on');
        set(handles.TargetMatteCheck2,'Enable','on');
        set(handles.SourceBackgroundButton,'Enable','on');
        set(handles.SourceSynButton,'Enable','on');
        set(handles.TargetBackgroundButton,'Enable','on');
    end
end


%% ����Ŀ����ʾ�л���ť��.
function TargetForegroundButton_Callback(hObject, eventdata, handles)
    if  get(hObject,'Value') == 1
        set(handles.TargetBackgroundButton,'Value',0);
        ShowTargetPanel(handles);
        set(handles.ResultTypeSelect,'Value',1);
    end
function TargetBackgroundButton_Callback(hObject, eventdata, handles)
    if  get(hObject,'Value') == 1     
        set(handles.TargetForegroundButton,'Value',0);
        ShowTargetPanel(handles);
        set(handles.ResultTypeSelect,'Value',1);
    end


%% ����Դͼ����ʾ�л���ť��.
function SourceForegroundButton_Callback(hObject, eventdata, handles)
    if  get(hObject,'Value') == 1
        set(handles.SourceBackgroundButton,'Value',0);
        set(handles.SourceSynButton,'Value',0);
        ShowSourceAndResultPanel(handles);
        set(handles.ResultTypeSelect,'Value',1);
    end
function SourceBackgroundButton_Callback(hObject, eventdata, handles)
    if  get(hObject,'Value') == 1
        set(handles.SourceForegroundButton,'Value',0);       
        set(handles.SourceSynButton,'Value',0);
        ShowSourceAndResultPanel(handles);
        set(handles.ResultTypeSelect,'Value',1);
    end
function SourceSynButton_Callback(hObject, eventdata, handles)
    if  get(hObject,'Value') == 1
        set(handles.SourceForegroundButton,'Value',0);
        set(handles.SourceBackgroundButton,'Value',0);
        ShowSourceAndResultPanel(handles);
        set(handles.ResultTypeSelect,'Value',1);
    end

% ���ϸ�ڴ���.
function FillDetailWindow(hObject, AxesHandle)
ListName = get(hObject,'UserData');
CurrentImageName = char(ListName(get(hObject,'Value')));
CurImage = imread(strcat('C:\Users\devil\Desktop\����\',CurrentImageName));
axes(AxesHandle);
imshow(CurImage);

% ��ȡDetailPopMenu�µ�����.
function FillDetailPopMemuData(hObject, ImageName)
dirs1 = dir('C:\Users\devil\Desktop\����\*.jpg');
dirs2 = dir('C:\Users\devil\Desktop\����\*.bmp');
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
        if strcmp(char(filenames(i)),ImageName)==1
            break;
        end
    end
end
set(hObject,'String',ListImage);
set(hObject,'UserData',filenames);
set(hObject,'Value',i);

function LeftImage_Callback(hObject, eventdata, handles)
FillDetailWindow(hObject,handles.ContrastLeft);
function LeftImage_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillDetailPopMemuData(hObject);

function RightImage_Callback(hObject, eventdata, handles)
FillDetailWindow(hObject,handles.ContrastRight);
function RightImage_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FillDetailPopMemuData(hObject);
