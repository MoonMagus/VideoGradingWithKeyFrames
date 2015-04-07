function  ExtractKeyFrames(VideoName)
% ����ָ����Ƶ���е�֡��������.
%dirs1 = dir('C:\Users\devil\Desktop\pics1\*.jpg');
%dirs2 = dir('C:\Users\devil\Desktop\pics1\*.bmp');
dirs1 = dir('VideoSlices\*.jpg');
dirs2 = dir('VideoSlices\*.bmp');
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
    fclose('all');
else
    for i = 1 : n
        Frames(i) = ExtractLABBandFeature(strcat('VideoSlices\',char(filenames(i))))';
    end
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
    save(VideoName,'Frames','filenames','MetricMatrix');
end
[~, n] = size(Frames);
for i = 1 : n
        E(i) = trace(Frames(i).ES + Frames(i).EM + Frames(i).EH);
        M(i) = sum(Frames(i).MS + Frames(i).MM + Frames(i).MH);
end
disp('Feature�����������ʼ�����������ž��� ');
disp('Metric�����������ʼ���ĵ���� ');

% ��չؼ�֡Ŀ¼.
delete 'KeyFrames/*.jpg';

% MetricMatrix
Data(1,:) = E;
Data(2,:) = M;	
[~, BestMedoids, MedoidsSize] = KMedoids(MetricMatrix, Data, floor(n/30));
KeyFrames = size(BestMedoids,2);
for i = 1:KeyFrames
    if  MedoidsSize(i) >= 30
        f = imread(strcat('VideoSlices\',char(filenames(BestMedoids(i)))));
        imwrite(f,strcat('KeyFrames\',char(filenames(BestMedoids(i)))));
    end
end