%%-----------------------------------------------------------------------  
% ColorGrading.
% Author: ������
% CreateTime: 2015-05-21 
%%------------------------------------------------------------------------  
function R = ColorTransferWithVideoReinhard(Source, OpenMatteS, MatteS, TargetKeyframes, nFrames, foreOrBack, FileNames, OpenMatteT)
if nargin < 6
    foreOrBack = 1;
    OpenMatteT = 0;
end
Alpha = 0;
% ���ɰ���ӵ�Դͼ����.
s = Source;
if OpenMatteS == 1
    ms = MatteS;
    ds = im2double(s);
    dms = mat2gray(ms,[0 255]);
    bms = im2bw(dms,0.5); 
    rms = double(repmat(bms,[1 1 3]));
    rs = im2uint8(ds.*rms);
else
    rs = Source;
end
R.rs = rs;

% ��ȡԴͼ���ɰ���Ч����.
if  OpenMatteS == 1
    LABSourceMatteImage = RGB2Lab(rs);
    %��Դͼ�����ָ��ģ�壬����ԭʼͼ���������.
    LABSourceImage = RGB2Lab(s);
else
    LABSourceMatteImage = RGB2Lab(s);
end
LABSourceMatteChannelL = LABSourceMatteImage(:,:,1);
LABSourceMatteChannelA = LABSourceMatteImage(:,:,2);
LABSourceMatteChannelB = LABSourceMatteImage(:,:,3);
MatteOriginal = LABSourceMatteChannelL;
% ����Ŀ�������A��Bͨ���������.
LABSourceMatteLuminanceOnlyChannelA = LABSourceMatteChannelA;
LABSourceMatteLuminanceOnlyChannelB = LABSourceMatteChannelB;
if OpenMatteS == 1
    LABSourceChannelL = LABSourceImage(:,:,1);
    LABSourceChannelA = LABSourceImage(:,:,2);
    LABSourceChannelB = LABSourceImage(:,:,3);
    SourceOriginal = LABSourceChannelL;
    % ���������Դͼ���ɰ�,����Դͼ���Lͨ������ֱ��ͼͳ��.
    SynSL = LABSourceChannelL;
    R.SynSL = SynSL;
    LABSourceLuminanceOnlyChannelA = LABSourceChannelA;
    LABSourceLuminanceOnlyChannelB = LABSourceChannelB;
else 
    SynSL = 0;
    R.SynSL = SynSL;
end
eps = 0.001;
if  OpenMatteS == 1
    IndexSourceMatte = find(LABSourceMatteChannelL > eps);
else
    IndexSourceMatte = find(LABSourceMatteChannelL > -1);
end;
ChannelLSourceLocalMatte = LABSourceMatteChannelL(IndexSourceMatte);
ChannelASourceLocalMatte = LABSourceMatteChannelA(IndexSourceMatte);
ChannelBSourceLocalMatte = LABSourceMatteChannelB(IndexSourceMatte);
[~, IndexSourceLocalMatte] = sort(ChannelLSourceLocalMatte);
SizeSourceLocalMatte = size(IndexSourceLocalMatte,1);
% SourceMatteͼ���Lͨ��ͼ��.
ls = LABSourceMatteChannelL;
R.ls = ls;
% SourceMatteͼ���Lͨ��ͳ��ֱ��ͼ.
lsh = ChannelLSourceLocalMatte;
R.lsh = lsh;


%% ����Ŀ��ͼ����������.
% ����Դͼ����Ӱ��ƽ��ֵ��Э�������.
ShadowLSourceLocalMatte = ChannelLSourceLocalMatte(IndexSourceLocalMatte(1:floor((1+Alpha)*SizeSourceLocalMatte/3)));
ShadowASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(1:floor((1+Alpha)*SizeSourceLocalMatte/3)));
ShadowBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(1:floor((1+Alpha)*SizeSourceLocalMatte/3)));
MeanShadowLSourceLocalMatte = sum(ShadowLSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanShadowASourceLocalMatte = sum(ShadowASourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanShadowBSourceLocalMatte = sum(ShadowBSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
CovShadow(:,1) = ShadowLSourceLocalMatte';
CovShadow(:,2) = ShadowASourceLocalMatte';
CovShadow(:,3) = ShadowBSourceLocalMatte';
CovShadowSourceLocalMatte   = cov(CovShadow);
% ����Դͼ���м��ƽ��ֵ��Э�������.
MiddleLSourceLocalMatte = ChannelLSourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MiddleASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MiddleBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MeanMiddleLSourceLocalMatte = sum(MiddleLSourceLocalMatte)/((1+2*Alpha)*SizeSourceLocalMatte/3);
MeanMiddleASourceLocalMatte = sum(MiddleASourceLocalMatte)/((1+2*Alpha)*SizeSourceLocalMatte/3);
MeanMiddleBSourceLocalMatte = sum(MiddleBSourceLocalMatte)/((1+2*Alpha)*SizeSourceLocalMatte/3);
CovMiddle(:,1) = MiddleLSourceLocalMatte';
CovMiddle(:,2) = MiddleASourceLocalMatte';
CovMiddle(:,3) = MiddleBSourceLocalMatte';
CovMiddleSourceLocalMatte   =  cov(CovMiddle);
% ����Դͼ�������ƽ��ֵ��Э�������.
HighLSourceLocalMatte = ChannelLSourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
HighASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
HighBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
MeanHighLSourceLocalMatte = sum(HighLSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanHighASourceLocalMatte = sum(HighASourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanHighBSourceLocalMatte = sum(HighBSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
CovHigh(:,1) = HighLSourceLocalMatte';
CovHigh(:,2) = HighASourceLocalMatte';
CovHigh(:,3) = HighBSourceLocalMatte';
CovHighSourceLocalMatte = cov(CovHigh);


%% ����������ʾ
SMSL = MeanShadowLSourceLocalMatte;
SMSA = MeanShadowASourceLocalMatte;
SMSB = MeanShadowBSourceLocalMatte;
SMML = MeanMiddleLSourceLocalMatte;
SMMA = MeanMiddleASourceLocalMatte;
SMMB = MeanMiddleBSourceLocalMatte;
SMHL = MeanHighLSourceLocalMatte;
SMHA = MeanHighASourceLocalMatte;
SMHB = MeanHighBSourceLocalMatte;

%% ����LAB��ɫ�ռ������ֵ����.
%��Ӱ��.
MS = [SMSL;SMSA;SMSB];
ES  = CovShadowSourceLocalMatte;
%�м��.
MM = [SMML;SMMA;SMMB];
EM  = CovMiddleSourceLocalMatte;
%������.
MH = [SMHL;SMHA;SMHB];
EH  = CovHighSourceLocalMatte;
F.MS = MS;
F.ES = ES;
F.MM = MM;
F.EM = EM;
F.MH = MH;
F.EH = EH;

index = FindTheNeededKeyFrame(F, TargetKeyframes, nFrames);
R.index = index;
if foreOrBack == 1
    forename = strcat('KeyFrames\TargetForeKeyFrames\',FileNames(index));
    target = imread(char(forename));
    if OpenMatteT == 1
        forematteName = strcat('KeyFrames\TargetForeMatteKeyFrames\',FileNames(index));
        TargetMatte = imread(char(forematteName));
    end
else
    backname = strcat('KeyFrames\TargetBackKeyFrames\',FileNames(index));
    target = imread(char(backname));
    if OpenMatteT == 1
        backmatteName = strcat('KeyFrames\TargetBackKeyFrames\',FileNames(index));
        TargetMatte = imread(char(backmatteName));
    end
end


% �����ͨ���ı�׼ƫ���ƽ��ֵ.
std1=std(ChannelLSourceLocalMatte,1);          
std2=std(ChannelASourceLocalMatte,1);          
std3=std(ChannelBSourceLocalMatte,1);
m1=mean(mean(ChannelLSourceLocalMatte)); 
m2=mean(mean(ChannelASourceLocalMatte)); 
m3=mean(mean(ChannelBSourceLocalMatte));
% ���ɰ���ӵ�Ŀ��ͼ����.
if OpenMatteT == 1
    t = target;
    mt = TargetMatte;
    dt = im2double(t);
    dmt = mat2gray(mt, [0 255]);
    bmt = im2bw(dmt, 0.5);
    rmt = double(repmat(bmt, [1 1 3]));
    rt = im2uint8(dt.*rmt);
else
    rt = target;
end


% ����Ŀ��ͼ�����ͨ��ֵ.
LABTargetImage = RGB2Lab(rt);    
TarLuminChannel = LABTargetImage(:,:,1);
TarAChannel = LABTargetImage(:,:,2);
TarBChannel = LABTargetImage(:,:,3);
eps = 0.001;
IndexTargetMatte = TarLuminChannel > eps;
TarMatteLuminanceChannel = TarLuminChannel(IndexTargetMatte);
TarMatteAChannel = TarAChannel(IndexTargetMatte);
TarMatteBChannel = TarBChannel(IndexTargetMatte);
% �����ͨ���ı�׼ƫ���ƽ��ֵ.
std4=std(TarMatteLuminanceChannel,1);           
std5=std(TarMatteAChannel,1);          
std6=std(TarMatteBChannel,1);
m4=mean(mean(TarMatteLuminanceChannel)); 
m5=mean(mean(TarMatteAChannel)); 
m6=mean(mean(TarMatteBChannel));


% ����ɫ��Ǩ�ƽ��.
LABSourceMatteChannelL(IndexSourceMatte) = (LABSourceMatteChannelL(IndexSourceMatte) - m1)*(std4 / std1) + m4;
LABSourceMatteChannelA(IndexSourceMatte) = (LABSourceMatteChannelA(IndexSourceMatte) - m2)*(std5 / std2) + m5;
LABSourceMatteChannelB(IndexSourceMatte) = (LABSourceMatteChannelB(IndexSourceMatte) - m3)*(std6 / std3) + m6;
if OpenMatteS == 1
    LABSourceChannelL(IndexSourceMatte) = (LABSourceChannelL(IndexSourceMatte) - m1)*(std4 / std1) + m4;
    LABSourceChannelA(IndexSourceMatte) = (LABSourceChannelA(IndexSourceMatte) - m2)*(std5 / std2) + m5;
    LABSourceChannelB(IndexSourceMatte) = (LABSourceChannelB(IndexSourceMatte) - m3)*(std6 / std3) + m6;
end

%% �ϳ������.
if OpenMatteS == 1
    % whole�ĺ���������ɰ����ɰ�������д������ؽ��ʱ�����ɰ�����֮���ԭʼ����ʹͼ������û���и�.
    WholeLuminOnlyResult = Lab2RGB(LABSourceChannelL,LABSourceLuminanceOnlyChannelA,LABSourceLuminanceOnlyChannelB);
    R.WholeLuminOnlyResult = WholeLuminOnlyResult;
    WholeHueOnlyResult = Lab2RGB(SourceOriginal,LABSourceChannelA,LABSourceChannelB);
    R.WholeHueOnlyResult = WholeHueOnlyResult;
    WholeHueSynResult = Lab2RGB(LABSourceChannelL,LABSourceChannelA,LABSourceChannelB);
    R.WholeHueSynResult = WholeHueSynResult;
else 
    WholeLuminOnlyResult =0;
    R.WholeLuminOnlyResult = WholeLuminOnlyResult;
    WholeHueOnlyResult = 0;
    R.WholeHueOnlyResult = WholeHueOnlyResult;
    WholeHueSynResult = 0;
    R.WholeHueSynResult = WholeHueSynResult;
end
LuminaOnlyResult = Lab2RGB(LABSourceMatteChannelL,LABSourceMatteLuminanceOnlyChannelA,LABSourceMatteLuminanceOnlyChannelB);
R.LuminaOnlyResult = LuminaOnlyResult;
HueOnlyResult = Lab2RGB(MatteOriginal,LABSourceMatteChannelA, LABSourceMatteChannelB);
R.HueOnlyResult = HueOnlyResult;
HueSynResult = Lab2RGB(LABSourceMatteChannelL, LABSourceMatteChannelA, LABSourceMatteChannelB);
R.HueSynResult = HueSynResult;
