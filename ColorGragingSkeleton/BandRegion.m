function BandRegion(Target, Source, OpenMatteT, OpenMatteS, MatteT, MatteS)
%%-----------------------------------------------------------------------
% ��ͼ��Ե��ɰ�������оֲ��任:
%     Target : Ŀ��ͼ��.
%     MatteT : Ŀ��ͼ���ɰ�.
%     Source : Դͼ��.
%     MatteS : Դͼ���ɰ�.
%%-----------------------------------------------------------------------  
%  Author: ������
%  CreateTime: 2015-01-25 
%%------------------------------------------------------------------------
if nargin == 0
    Target = 'Images/��̨.jpg';
    MatteT = 'Images/transformersMatte.jpg';
    Source = 'Images/amelie.jpg';
    MatteS = 'Images/interviewMatte.jpg';
    OpenMatteT = 0;
    OpenMatteS = 0;
end

%% ���ɰ���ӵ�Ŀ��ͼ����.
t = imread(Target);
if OpenMatteT == 1
    dt = im2double(t);
    mt = imread(MatteT);
    dmt = mat2gray(mt,[0 255]);
    bmt = im2bw(dmt,0.5);
    rmt = double(repmat(bmt,[1 1 3]));
    rt = im2uint8(dt.*rmt);
end

% ��ȡĿ���ɰ���Ч����.
if  OpenMatteT == 1
    LABTargetMatteImage = RGB2Lab(rt);
else
    LABTargetMatteImage = RGB2Lab(t);
end
LABTargetMatteChannelL = LABTargetMatteImage(:,:,1);
eps = 0.001;
if OpenMatteT == 1
    IndexTargetMatte = find(LABTargetMatteChannelL > eps);
else
    IndexTargetMatte = find(LABTargetMatteChannelL > -1);
end
ChannelLTargetLocalMatte = LABTargetMatteChannelL(IndexTargetMatte);


%% ���ɰ���ӵ�Դͼ����.
s = imread(Source);
if  OpenMatteS == 1
    ds = im2double(s);
    ms = imread(MatteS);
    dms = mat2gray(ms,[0 255]);
    bms = im2bw(dms,0.5);
    rms = double(repmat(bms,[1 1 3]));
    rs = im2uint8(ds.*rms);
    figure,imshow(rs);
else
    figure,imshow(s);
end

% ��ȡԴͼ���ɰ���Ч����.
if  OpenMatteS == 1
    LABSourceMatteImage = RGB2Lab(rs);
else
    LABSourceMatteImage = RGB2Lab(s);
end
LABSourceMatteChannelL = LABSourceMatteImage(:,:,1);
LABSourceMatteChannelA = LABSourceMatteImage(:,:,2);
LABSourceMatteChannelB = LABSourceMatteImage(:,:,3);
eps = 0.001;
if  OpenMatteS == 1
    IndexSourceMatte = find(LABSourceMatteChannelL > eps);
else
    IndexSourceMatte = find(LABSourceMatteChannelL > -1);
end;
ChannelLSourceLocalMatte = LABSourceMatteChannelL(IndexSourceMatte);
[~, IndexSourceLocalMatte] = sort(ChannelLSourceLocalMatte);
SizeSourceLocalMatte = size(IndexSourceLocalMatte,1);


%���з��ն�����.
TargetMatteLuminanceData = im2uint8(mat2gray(ChannelLTargetLocalMatte,[0 100]));
TargetHistCount = imhist(TargetMatteLuminanceData);
SourceMatteLuminanceData = im2uint8(mat2gray(ChannelLSourceLocalMatte,[0 100]));
TargetHistCount = mat2gray(TargetHistCount);
SourceMatteLuminanceTranferResult = histeq(SourceMatteLuminanceData,TargetHistCount);
resultImageDouble = mat2gray(SourceMatteLuminanceTranferResult,[0 255]);
resultImageDouble = resultImageDouble*100;
LABSourceMatteChannelL(IndexSourceMatte) = resultImageDouble;



LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3))))= 0;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)))) = 0;
% �����м���任���a,bֵ.

LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))) = 0;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))) = 0;

% ����������任���a,bֵ.

LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))) = 0;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))) = 0;

 mins = min(LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)))))
 maxs = max(LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)))))
 minm = min(LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))))
 maxm = max(LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))))
 minh = min(LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))))
 maxh = max(LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))))
LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)))) = 20;
LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))) = 60;
LABSourceMatteChannelL(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))) = 100;
%% �ϳ������.
Result = Lab2RGB(LABSourceMatteChannelL, LABSourceMatteChannelA, LABSourceMatteChannelB);
figure,imshow(Result);

