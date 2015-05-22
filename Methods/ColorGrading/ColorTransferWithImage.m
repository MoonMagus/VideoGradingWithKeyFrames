function R = ColorTransferWithImage(Source, OpenMatteS, MatteS, TF, HistData, OpenFilter, Alpha)
%%-----------------------------------------------------------------------
% ��ͼ��Ե��ɰ�������оֲ��任:
%     Source : Դͼ��.
%     OpenMatteS : ����ԭͼ���ɰ�.
%     MatteS : Դͼ���ɰ�.
%     TF : Ŀ��ͼ����������.
%     HistData : Ŀ��ͼ������ֱ��ͼ.
%     OpenFilter : ����ͼ���˲�.
%     Alpha : �ص�����ı���.
%%-----------------------------------------------------------------------  
%  Author: ������
%  CreateTime: 2015-05-22 
%%------------------------------------------------------------------------
% �������������.

if nargin < 6
    OpenFilter = 1;
    Alpha = 0;
end
Alpha = 0;
% OpenFilter = 0;
%% ���ɰ���ӵ�Դͼ����.
s = Source;
if  OpenMatteS == 1
    ds = im2double(s);
    ms = MatteS;
    dms = mat2gray(ms,[0 255]);
    bms = im2bw(dms,0.5);
    rms = double(repmat(bms,[1 1 3]));
    rs = im2uint8(ds.*rms);
else
    rs = s;
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
MeanShadowASourceLocalMatte = sum(ShadowASourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanShadowBSourceLocalMatte = sum(ShadowBSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
CovShadow(:,1) = ShadowLSourceLocalMatte';
CovShadow(:,2) = ShadowASourceLocalMatte';
CovShadow(:,3) = ShadowBSourceLocalMatte';
CovShadowSourceLocalMatte   = cov(CovShadow);
CovShadow = CovShadowSourceLocalMatte(2:3,2:3);
% ����Դͼ���м��ƽ��ֵ��Э�������.
MiddleLSourceLocalMatte = ChannelLSourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MiddleASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MiddleBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MeanMiddleASourceLocalMatte = sum(MiddleASourceLocalMatte)/((1+2*Alpha)*SizeSourceLocalMatte/3);
MeanMiddleBSourceLocalMatte = sum(MiddleBSourceLocalMatte)/((1+2*Alpha)*SizeSourceLocalMatte/3);
CovMiddle(:,1) = MiddleLSourceLocalMatte';
CovMiddle(:,2) = MiddleASourceLocalMatte';
CovMiddle(:,3) = MiddleBSourceLocalMatte';
CovMiddleSourceLocalMatte   =  cov(CovMiddle);
CovMiddle = CovMiddleSourceLocalMatte(2:3,2:3);
% ����Դͼ�������ƽ��ֵ��Э�������.
HighLSourceLocalMatte = ChannelLSourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
HighASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
HighBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
MeanHighASourceLocalMatte = sum(HighASourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanHighBSourceLocalMatte = sum(HighBSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
CovHigh(:,1) = HighLSourceLocalMatte';
CovHigh(:,2) = HighASourceLocalMatte';
CovHigh(:,3) = HighBSourceLocalMatte';
CovHighSourceLocalMatte = cov(CovHigh);
CovHigh = CovHighSourceLocalMatte(2:3,2:3);


%% ����������ʾ
SMSA = MeanShadowASourceLocalMatte;
SMSB = MeanShadowBSourceLocalMatte;
SES  = CovShadow;
SMMA = MeanMiddleASourceLocalMatte;
SMMB = MeanMiddleBSourceLocalMatte;
SEM  = CovMiddle;
SMHA = MeanHighASourceLocalMatte;
SMHB = MeanHighBSourceLocalMatte;
SEH  = CovHigh;


HISTDATA = HistData;
%���з��ն�����.
TargetMatteLuminanceData = im2uint8(mat2gray(HISTDATA, [0 100]));
TargetHistCount = imhist(TargetMatteLuminanceData);
SourceMatteLuminanceData = im2uint8(mat2gray(ChannelLSourceLocalMatte,[0 100]));
TargetHistCount = mat2gray(TargetHistCount);
SourceMatteLuminanceTranferResult = histeq(SourceMatteLuminanceData,TargetHistCount);
resultImageDouble = mat2gray(SourceMatteLuminanceTranferResult,[0 255]);
resultImageDouble = resultImageDouble*100;
LABSourceMatteChannelL(IndexSourceMatte) = resultImageDouble;
% ����Luminanceͨ���˲�.
if  OpenFilter == 1
    LuminanceBlurRegion = im2uint8(mat2gray(LABSourceMatteChannelL,[0 100]));
    gausFilter = fspecial('gaussian',[2 2],0.5);
    LuminanceBlurRegion = imfilter(LuminanceBlurRegion,gausFilter,'replicate');
    LABSourceMatteChannelA = imfilter(LABSourceMatteChannelA,gausFilter,'replicate');
    LABSourceMatteChannelB = imfilter(LABSourceMatteChannelB,gausFilter,'replicate');
%     ChannelASourceLocalMatte = LABSourceMatteChannelA(IndexSourceMatte);
%     ChannelBSourceLocalMatte = LABSourceMatteChannelB(IndexSourceMatte);
    LuminanceBlurRegion = 100*mat2gray(LuminanceBlurRegion,[0,255]);
    resultImageDouble = LuminanceBlurRegion(IndexSourceMatte);
    LABSourceMatteChannelL(IndexSourceMatte) = resultImageDouble;
end
if  OpenMatteS == 1 
    LABSourceChannelL(IndexSourceMatte) = resultImageDouble;
     % ����������ɰ棬����Դͼ���ɰ沿��������Lͨ������ֱ��ͼͳ�ƣ��ɰ�֮��Ĳ��ֱ���.
    SynRL = LABSourceChannelL;
    R.SynRL = SynRL;
else 
    SynRL = 0;
    R.SynRL = SynRL;
end
% ResultMatteͼ���Lͨ��ͼ������������ɰ棬����Դͼ���ɰ沿��������Lͨ������ֱ��ͼͳ�ƣ��ɰ�֮��Ĳ����޳�.
lr = LABSourceMatteChannelL;
R.lr = lr;
% ResultMatteͼ���Lͨ��ͳ��ֱ��ͼ������������ɰ棬����Դͼ���ɰ沿��������Lͨ��һά��������ֱ��ͼͳ�ƣ��ɰ�֮��Ĳ����޳�.
lrh = resultImageDouble;
R.lrh = lrh;


% ����Ŀ��ͼ�����������.
TMSA = TF.MS(2);
TMSB = TF.MS(3);
TES  = TF.ES(2:3, 2:3);
TMMA = TF.MM(2);
TMMB = TF.MM(3);
TEM  = TF.EM(2:3, 2:3);
TMHA = TF.MH(2);
TMHB = TF.MH(3);
TEH  = TF.EH(2:3, 2:3);
%% ���㲻ͬ���ȴ��ı任����.
ShadowTransformMatrix = SES^(-1/2)*(SES^(1/2)*TES*SES^(1/2))^(1/2)*SES^(-1/2);
MiddleTransformMatrix = SEM^(-1/2)*(SEM^(1/2)*TEM*SEM^(1/2))^(1/2)*SEM^(-1/2);
HighTransformMatrix   = SEH^(-1/2)*(SEH^(1/2)*TEH*SEH^(1/2))^(1/2)*SEH^(-1/2);


%% ����任��Ĳ�ͬ���ȴ�a,bֵ.
% ������Ӱ���任���a,bֵ.
SA = ShadowASourceLocalMatte;
SB = ShadowBSourceLocalMatte;
TransformShadowData = [SA' - SMSA;SB' - SMSB];
MatrixShadow = ShadowTransformMatrix*TransformShadowData;
ShadowA = MatrixShadow(1,:) + TMSA;
ShadowB = MatrixShadow(2,:) + TMSB;
numShadow = floor((1-Alpha)*SizeSourceLocalMatte/3);
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(1:numShadow))) = ShadowA(1:numShadow);
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(1:numShadow))) = ShadowB(1:numShadow);
if  OpenMatteS == 1
    LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(1:numShadow))) = ShadowA(1:numShadow);
    LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(1:numShadow))) = ShadowA(1:numShadow);
end
% �����м���任���a,bֵ.
MA = MiddleASourceLocalMatte;
MB = MiddleBSourceLocalMatte;
TransformMiddleData = [MA' - SMMA;MB' - SMMB];
MatrixMiddle = MiddleTransformMatrix*TransformMiddleData;
MiddleA = MatrixMiddle(1,:) + TMMA;
MiddleB = MatrixMiddle(2,:) + TMMB;
numMiddle = floor(SizeSourceLocalMatte/3) - floor(2*Alpha*SizeSourceLocalMatte/3);
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor((1+Alpha)*SizeSourceLocalMatte/3)+1:floor((1+Alpha)*SizeSourceLocalMatte/3)+numMiddle))) = MiddleA(floor(2*Alpha*SizeSourceLocalMatte/3)+1:2*Alpha*SizeSourceLocalMatte/3+numMiddle);
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor((1+Alpha)*SizeSourceLocalMatte/3)+1:floor((1+Alpha)*SizeSourceLocalMatte/3)+numMiddle))) = MiddleB(floor(2*Alpha*SizeSourceLocalMatte/3)+1:2*Alpha*SizeSourceLocalMatte/3+numMiddle);
if  OpenMatteS == 1
    LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor((1+Alpha)*SizeSourceLocalMatte/3)+1:floor((1+Alpha)*SizeSourceLocalMatte/3)+numMiddle))) = MiddleA(floor(2*Alpha*SizeSourceLocalMatte/3)+1:2*Alpha*SizeSourceLocalMatte/3+numMiddle);
    LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor((1+Alpha)*SizeSourceLocalMatte/3)+1:floor((1+Alpha)*SizeSourceLocalMatte/3)+numMiddle))) = MiddleB(floor(2*Alpha*SizeSourceLocalMatte/3)+1:2*Alpha*SizeSourceLocalMatte/3+numMiddle);
end

% ����������任���a,bֵ.
HA = HighASourceLocalMatte;
HB = HighBSourceLocalMatte;
TransformHighData = [HA' - SMHA;HB' - SMHB];
MatrixHigh = HighTransformMatrix*TransformHighData;
HighA = MatrixHigh(1,:) + TMHA;
HighB = MatrixHigh(2,:) + TMHB;
numHigh = SizeSourceLocalMatte - floor((2+Alpha)*SizeSourceLocalMatte/3);
beginHigh = floor((2+Alpha)*SizeSourceLocalMatte/3)+1;
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(beginHigh:beginHigh + numHigh -1))) = HighA(floor(2*Alpha*SizeSourceLocalMatte/3)+1:floor(2*Alpha*SizeSourceLocalMatte/3)+numHigh);
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(beginHigh:beginHigh + numHigh -1))) = HighB(floor(2*Alpha*SizeSourceLocalMatte/3)+1:floor(2*Alpha*SizeSourceLocalMatte/3)+numHigh);
if  OpenMatteS == 1
    LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(beginHigh:beginHigh + numHigh -1))) = HighA(floor(2*Alpha*SizeSourceLocalMatte/3)+1:floor(2*Alpha*SizeSourceLocalMatte/3)+numHigh);
    LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(beginHigh:beginHigh + numHigh -1))) = HighB(floor(2*Alpha*SizeSourceLocalMatte/3)+1:floor(2*Alpha*SizeSourceLocalMatte/3)+numHigh);
end
%% ��ȡ����Ӱ���Ľ������.

% ����Ȩ�ؾ���.
WeightSize = 2 * floor(Alpha*SizeSourceLocalMatte/3);
WeightDescend = WeightSize:-1:1;
WeightDescend = (WeightDescend/WeightSize).^3;
WeightAscend = 1:WeightSize;
WeightAscend = (WeightAscend/WeightSize).^3;
Weight = WeightDescend + WeightAscend;
WeightDescend = WeightDescend./Weight;
WeightAscend = WeightAscend./Weight;

% ��ȡ��Ӱ�ҽ�������м��󽥱��.
numShadowMiddle = WeightSize;
ShadowRightA = ShadowA(end - numShadowMiddle + 1:end);
ShadowRightB = ShadowB(end - numShadowMiddle + 1:end);
MiddleLeftA = MiddleA(1:numShadowMiddle);
MiddleLeftB = MiddleB(1:numShadowMiddle);
ShadowMiddleTransitionA = ShadowRightA.*WeightDescend + MiddleLeftA.*WeightAscend;
ShadowMiddleTransitionB = ShadowRightB.*WeightDescend + MiddleLeftB.*WeightAscend;
beginShadowMiddle = floor((1-Alpha)*SizeSourceLocalMatte/3) + 1;
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(beginShadowMiddle:beginShadowMiddle + numShadowMiddle -1))) = ShadowMiddleTransitionA;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(beginShadowMiddle:beginShadowMiddle + numShadowMiddle -1))) = ShadowMiddleTransitionB;
if  OpenMatteS == 1
    LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(beginShadowMiddle:beginShadowMiddle + numShadowMiddle -1))) = ShadowMiddleTransitionA;
    LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(beginShadowMiddle:beginShadowMiddle + numShadowMiddle -1))) = ShadowMiddleTransitionB;
end

% ��ȡ�м��ҽ�����͸����󽥱��.
numMiddleHigh = WeightSize;
MiddleRightA = MiddleA(end - numMiddleHigh + 1:end);
MiddleRightB = MiddleB(end - numMiddleHigh + 1:end);
HighLeftA = HighA(1:numMiddleHigh);
HighLeftB = HighB(1:numMiddleHigh);
MiddleHighTransitionA = MiddleRightA.*WeightDescend + HighLeftA.*WeightDescend;
MiddleHighTransitionB = MiddleRightB.*WeightDescend + HighLeftB.*WeightDescend;
beginMiddleHigh = floor((2-Alpha)*SizeSourceLocalMatte/3)+1;
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(beginMiddleHigh:beginMiddleHigh + numMiddleHigh -1))) = MiddleHighTransitionA;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(beginMiddleHigh:beginMiddleHigh + numMiddleHigh -1))) = MiddleHighTransitionB;
if  OpenMatteS == 1
    LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(beginMiddleHigh:beginMiddleHigh + numMiddleHigh -1))) = MiddleHighTransitionA;
    LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(beginMiddleHigh:beginMiddleHigh + numMiddleHigh -1))) = MiddleHighTransitionB;
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