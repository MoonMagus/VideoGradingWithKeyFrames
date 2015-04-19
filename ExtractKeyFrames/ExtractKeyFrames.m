function  BestMedoids = ExtractKeyFrames(VideoName, DirName)
global StatusBarHandle;
% 计算指定视频流中的帧特征矩阵.
%dirs1 = dir('C:\Users\devil\Desktop\pics1\*.jpg');
%dirs2 = dir('C:\Users\devil\Desktop\pics1\*.bmp');
if(strcmp(DirName, 'left') == 1)
    SclicesDir = 'VideoSlices\LeftSlices\';
    KeyframesDir = 'KeyFrames\LeftKeyFrames\';
elseif(strcmp(DirName, 'right') == 1)
    SclicesDir = 'VideoSlices\RightSlices\';
    KeyframesDir = 'KeyFrames\RightKeyFrames\';
elseif(strcmp(DirName, 'TargetFore') == 1)
    SclicesDir = 'VideoSlices\TargetForeSlices\';
    KeyframesDir = 'KeyFrames\TargetForeKeyFrames\';
elseif(strcmp(DirName, 'TargetForeMatte') == 1)
    SclicesDir = 'VideoSlices\TargetForeMatteSlices\';
    KeyframesDir = 'KeyFrames\TargetForeMatteKeyFrames\';
elseif(strcmp(DirName,'TargetBack') == 1)
    SclicesDir = 'VideoSlices\TargetBackSlices\';
    KeyframesDir = 'KeyFrames\TargetBackKeyFrames\';
elseif(strcmp(DirName,'TargetBackMatte') == 1)
    SclicesDir = 'VideoSlices\TargetBackMatteSlices\';
    KeyframesDir = 'KeyFrames\TargetBackMatteKeyFrames\';
end
dirs1 = dir(strcat(SclicesDir, '*.jpg'));
dirs2 = dir(strcat(SclicesDir, '*.bmp'));
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
n = size(filenames,1);
Frames(1,n) = struct('MS',[],'ES',[],'MM',[],'EM',[],'MH',[],'EH',[]);
E = zeros(1,n);
M = zeros(1,n);
MetricMatrix = zeros(n,n);
VideoName = strcat('VideoData\',VideoName(1:end - 4),'Feature.mat');
fid = fopen(VideoName);
if(fid ~= -1)
    Frames = load(VideoName);
    filenames = Frames.filenames;
    MetricMatrix =Frames.MetricMatrix;
    Frames = Frames.Frames;
    FreshListBox('正在提取真序列Feature，准备计算测地线最优距离 ', StatusBarHandle);
    FreshListBox('Feature计算结束，开始计算测地线最优距离 ', StatusBarHandle);
    FreshListBox('Metric计算结束，开始中心点聚类 ', StatusBarHandle);
    fclose('all');
else
    FreshListBox('正在提取真序列Feature，准备计算测地线最优距离 ', StatusBarHandle);
    for i = 1 : n
        Frames(i) = ExtractLABBandFeature(strcat(SclicesDir,char(filenames(i))))';
    end
    FreshListBox('Feature计算结束，开始计算测地线最优距离 ', StatusBarHandle);
    for i = 1:n
        for j = 1:i-1
            MetricMatrix(i,j) = MetricDistance(Frames(i),Frames(j));
        end
    end
    for i = 1:n
        for j = i+1:n
            MetricMatrix(i,j) =MetricMatrix(j,i);
        end
    end
    FreshListBox('Metric计算结束，开始中心点聚类 ', StatusBarHandle);
    save(VideoName,'Frames','filenames','MetricMatrix');
end
[~, n] = size(Frames);
for i = 1 : n
        E(i) = trace(Frames(i).ES + Frames(i).EM + Frames(i).EH);
        M(i) = sum(Frames(i).MS + Frames(i).MM + Frames(i).MH);
end

disp('Feature计算结束，开始计算测地线最优距离 ');
disp('Metric计算结束，开始中心点聚类 ');

% 清空关键帧目录.
keyDelDir = strcat(KeyframesDir, '*.jpg');
delete(keyDelDir);

% MetricMatrix
Data(1,:) = E;
Data(2,:) = M;	
[~, BestMedoids, MedoidsSize] = KMedoids(MetricMatrix, Data, floor(n/30));
KeyFrames = size(BestMedoids,2);
for i = 1:KeyFrames
    if  MedoidsSize(i) >= 30
        f = imread(strcat(SclicesDir, char(filenames(BestMedoids(i)))));
        imwrite(f,strcat(KeyframesDir, char(filenames(BestMedoids(i)))));
    end
end
