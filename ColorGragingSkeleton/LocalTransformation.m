function [WholeLuminOnlyResult, WholeHueOnlyResult, WholeHueSynResult, LuminaOnlyResult, HueOnlyResult, HueSynResult,rs ,rt, ls, lsh, lt, lth, lr, lrh, SynSL, SynRL] = LocalTransformation(Target, Source, OpenMatteT, OpenMatteS, MatteT, MatteS, OpenFilter, Alpha)
%%-----------------------------------------------------------------------
% 对图像对的蒙版区域进行局部变换:
%     Target : 目标图像.
%     MatteT : 目标图像蒙版.
%     OpenMatteT : 开启目标蒙版.
%     Source : 源图像.
%     MatteS : 源图像蒙版.
%     OpenMatteS : 开启原图像蒙版.
%%-----------------------------------------------------------------------  
%  Author: 冯亚男
%  CreateTime: 2015-01-25 
%%------------------------------------------------------------------------
if nargin == 0
    Target = imread('Images/transformers.jpg');
    MatteT = imread('Images/transformersMatte.jpg');
    Source = imread('Images/interview.jpg');
    MatteS = imread('Images/interviewMatte.jpg');
    OpenMatteT = 1;
    OpenMatteS = 1;
else if nargin < 6
        OpenFilter = 1;
        Alpha = 0.1;
    end
end
Alpha = 0;
% OpenFilter = 0;
%% 将蒙版叠加到目标图像上.
t = Target;
if OpenMatteT == 1
    dt = im2double(t);
    mt = MatteT;
    dmt = mat2gray(mt,[0 255]);
    bmt = im2bw(dmt,0.5);
    rmt = double(repmat(bmt,[1 1 3]));
    rt = im2uint8(dt.*rmt);
else
    rt = t;
end

% 抽取目标蒙版有效区域.
if  OpenMatteT == 1
    LABTargetMatteImage = RGB2Lab(rt);
else
    LABTargetMatteImage = RGB2Lab(t);
end
LABTargetMatteChannelL = LABTargetMatteImage(:,:,1);
LABTargetMatteChannelA = LABTargetMatteImage(:,:,2);
LABTargetMatteChannelB = LABTargetMatteImage(:,:,3);
eps = 0.001;
if OpenMatteT == 1
    IndexTargetMatte = find(LABTargetMatteChannelL > eps);
else
    IndexTargetMatte = find(LABTargetMatteChannelL > -1);
end
ChannelLTargetLocalMatte = LABTargetMatteChannelL(IndexTargetMatte);
ChannelATargetLocalMatte = LABTargetMatteChannelA(IndexTargetMatte);
ChannelBTargetLocalMatte = LABTargetMatteChannelB(IndexTargetMatte);
[~, IndexTargetLocalMatte] = sort(ChannelLTargetLocalMatte);
SizeTargetLocalMatte = size(IndexTargetLocalMatte,1);
% TargetMatte图像的L通道图像.
lt = LABTargetMatteChannelL;
% TargetMatte图像的L通道统计直方图.
lth = ChannelLTargetLocalMatte;

% 计算目标图像特征矩阵.
% 计算目标阴影带平均值和协方差矩阵.
ShadowATargetLocalMatte = ChannelATargetLocalMatte(IndexTargetLocalMatte(1:floor((1+Alpha)*SizeTargetLocalMatte/3)));
ShadowBTargetLocalMatte = ChannelBTargetLocalMatte(IndexTargetLocalMatte(1:floor((1+Alpha)*SizeTargetLocalMatte/3)));
MeanShadowATargetLocalMatte = sum(ShadowATargetLocalMatte)/((1+Alpha)*SizeTargetLocalMatte/3);
MeanShadowBTargetLocalMatte = sum(ShadowBTargetLocalMatte)/((1+Alpha)*SizeTargetLocalMatte/3);
CovShadowTargetLocalMatte   = cov(ShadowATargetLocalMatte,ShadowBTargetLocalMatte);
% 计算目标中间带平均值和协方差矩阵.
MiddleATargetLocalMatte = ChannelATargetLocalMatte(IndexTargetLocalMatte(floor((1-Alpha)*SizeTargetLocalMatte/3)+1:floor((2+Alpha)*SizeTargetLocalMatte/3)));
MiddleBTargetLocalMatte = ChannelBTargetLocalMatte(IndexTargetLocalMatte(floor((1-Alpha)*SizeTargetLocalMatte/3)+1:floor((2+Alpha)*SizeTargetLocalMatte/3)));
MeanMiddleATargetLocalMatte = sum(MiddleATargetLocalMatte)/((1+2*Alpha)*SizeTargetLocalMatte/3);
MeanMiddleBTargetLocalMatte = sum(MiddleBTargetLocalMatte)/((1+2*Alpha)*SizeTargetLocalMatte/3);
CovMiddleTargetLocalMatte   = cov(MiddleATargetLocalMatte,MiddleBTargetLocalMatte);
% 计算目标高亮带平均值和协方差矩阵.
HighATargetLocalMatte = ChannelATargetLocalMatte(IndexTargetLocalMatte(floor((2-Alpha)*SizeTargetLocalMatte/3)+1:SizeTargetLocalMatte));
HighBTargetLocalMatte = ChannelBTargetLocalMatte(IndexTargetLocalMatte(floor((2-Alpha)*SizeTargetLocalMatte/3)+1:SizeTargetLocalMatte));
MeanHighATargetLocalMatte = sum(HighATargetLocalMatte)/((1+Alpha)*SizeTargetLocalMatte/3);
MeanHighBTargetLocalMatte = sum(HighBTargetLocalMatte)/((1+Alpha)*SizeTargetLocalMatte/3);
CovHighTargetLocalMatte = cov(HighATargetLocalMatte,HighBTargetLocalMatte);




%% 将蒙版叠加到源图像上.
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

% 抽取源图像蒙版有效区域.
if  OpenMatteS == 1
    LABSourceMatteImage = RGB2Lab(rs);
    %若源图像具有指定模板，则定义原始图像用于输出.
    LABSourceImage = RGB2Lab(s);
else
    LABSourceMatteImage = RGB2Lab(s);
end
LABSourceMatteChannelL = LABSourceMatteImage(:,:,1);
LABSourceMatteChannelA = LABSourceMatteImage(:,:,2);
LABSourceMatteChannelB = LABSourceMatteImage(:,:,3);
MatteOriginal = LABSourceMatteChannelL;
% 保持目标区域的A、B通道用于输出.
LABSourceMatteLuminanceOnlyChannelA = LABSourceMatteChannelA;
LABSourceMatteLuminanceOnlyChannelB = LABSourceMatteChannelB;
if OpenMatteS == 1
    LABSourceChannelL = LABSourceImage(:,:,1);
    LABSourceChannelA = LABSourceImage(:,:,2);
    LABSourceChannelB = LABSourceImage(:,:,3);
    SourceOriginal = LABSourceChannelL;
    % 保存源图像的L通道用于直方图统计.
    SynSL = LABSourceChannelL;
    LABSourceLuminanceOnlyChannelA = LABSourceChannelA;
    LABSourceLuminanceOnlyChannelB = LABSourceChannelB;
else 
    SynSL = 0;
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
% SourceMatte图像的L通道图像.
ls = LABSourceMatteChannelL;
% SourceMatte图像的L通道统计直方图.
lsh = ChannelLSourceLocalMatte;


%进行辐照度拉伸.
TargetMatteLuminanceData = im2uint8(mat2gray(ChannelLTargetLocalMatte,[0 100]));
TargetHistCount = imhist(TargetMatteLuminanceData);
SourceMatteLuminanceData = im2uint8(mat2gray(ChannelLSourceLocalMatte,[0 100]));
TargetHistCount = mat2gray(TargetHistCount);
SourceMatteLuminanceTranferResult = histeq(SourceMatteLuminanceData,TargetHistCount);
resultImageDouble = mat2gray(SourceMatteLuminanceTranferResult,[0 255]);
resultImageDouble = resultImageDouble*100;
LABSourceMatteChannelL(IndexSourceMatte) = resultImageDouble;
% 开启Luminance通道滤波.
if  OpenFilter == 1
    LuminanceBlurRegion = im2uint8(mat2gray(LABSourceMatteChannelL,[0 100]));
    gausFilter = fspecial('gaussian',[2 2],0.5);
    LuminanceBlurRegion = imfilter(LuminanceBlurRegion,gausFilter,'replicate');
    LABSourceMatteChannelA = imfilter(LABSourceMatteChannelA,gausFilter,'replicate');
    LABSourceMatteChannelB = imfilter(LABSourceMatteChannelB,gausFilter,'replicate');
    ChannelASourceLocalMatte = LABSourceMatteChannelA(IndexSourceMatte);
    ChannelBSourceLocalMatte = LABSourceMatteChannelB(IndexSourceMatte);
    LuminanceBlurRegion = 100*mat2gray(LuminanceBlurRegion,[0,255]);
    resultImageDouble = LuminanceBlurRegion(IndexSourceMatte);
    LABSourceMatteChannelL(IndexSourceMatte) = resultImageDouble;
end
if  OpenMatteS == 1 
    LABSourceChannelL(IndexSourceMatte) = resultImageDouble;
     % 保存源图像拉伸后的L通道用于直方图统计.
    SynRL = LABSourceChannelL;
else 
    SynRL = 0;
end
% ResultMatte图像的L通道图像.
lr = LABSourceMatteChannelL;
% ResultMatte图像的L通道统计直方图.
lrh = resultImageDouble;


% 计算目标图像特征矩阵.
% 计算源图像阴影带平均值和协方差矩阵.
ShadowASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(1:floor((1+Alpha)*SizeSourceLocalMatte/3)));
ShadowBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(1:floor((1+Alpha)*SizeSourceLocalMatte/3)));
MeanShadowASourceLocalMatte = sum(ShadowASourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanShadowBSourceLocalMatte = sum(ShadowBSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
CovShadowSourceLocalMatte   = cov(ShadowASourceLocalMatte,ShadowBSourceLocalMatte);
% 计算源图像中间带平均值和协方差矩阵.
MiddleASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MiddleBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor((1-Alpha)*SizeSourceLocalMatte/3)+1:floor((2+Alpha)*SizeSourceLocalMatte/3)));
MeanMiddleASourceLocalMatte = sum(MiddleASourceLocalMatte)/((1+2*Alpha)*SizeSourceLocalMatte/3);
MeanMiddleBSourceLocalMatte = sum(MiddleBSourceLocalMatte)/((1+2*Alpha)*SizeSourceLocalMatte/3);
CovMiddleSourceLocalMatte   = cov(MiddleASourceLocalMatte,MiddleBSourceLocalMatte);
% 计算源图像高亮带平均值和协方差矩阵.
HighASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
HighBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor((2-Alpha)*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
MeanHighASourceLocalMatte = sum(HighASourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
MeanHighBSourceLocalMatte = sum(HighBSourceLocalMatte)/((1+Alpha)*SizeSourceLocalMatte/3);
CovHighSourceLocalMatte = cov(HighASourceLocalMatte,HighBSourceLocalMatte);



%% 特征参数表示
TMSA = MeanShadowATargetLocalMatte;
TMSB = MeanShadowBTargetLocalMatte;
TES  = CovShadowTargetLocalMatte;
TMMA = MeanMiddleATargetLocalMatte;
TMMB = MeanMiddleBTargetLocalMatte;
TEM  = CovMiddleTargetLocalMatte;
TMHA = MeanHighATargetLocalMatte;
TMHB = MeanHighBTargetLocalMatte;
TEH  = CovHighTargetLocalMatte;
SMSA = MeanShadowASourceLocalMatte;
SMSB = MeanShadowBSourceLocalMatte;
SES  = CovShadowSourceLocalMatte;
SMMA = MeanMiddleASourceLocalMatte;
SMMB = MeanMiddleBSourceLocalMatte;
SEM  = CovMiddleSourceLocalMatte;
SMHA = MeanHighASourceLocalMatte;
SMHB = MeanHighBSourceLocalMatte;
SEH  = CovHighSourceLocalMatte;


%% 计算不同亮度带的变换矩阵.
ShadowTransformMatrix = SES^(-1/2)*(SES^(1/2)*TES*SES^(1/2))^(1/2)*SES^(-1/2);
MiddleTransformMatrix = SEM^(-1/2)*(SEM^(1/2)*TEM*SEM^(1/2))^(1/2)*SEM^(-1/2);
HighTransformMatrix   = SEH^(-1/2)*(SEH^(1/2)*TEH*SEH^(1/2))^(1/2)*SEH^(-1/2);


%% 计算变换后的不同亮度带a,b值.
% 计算阴影带变换后的a,b值.
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
% 计算中间带变换后的a,b值.
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

% 计算高亮带变换后的a,b值.
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
%% 抽取各阴影带的渐变矩阵.

% 定义权重矩阵.
WeightSize = 2 * floor(Alpha*SizeSourceLocalMatte/3);
WeightDescend = WeightSize:-1:1;
WeightDescend = (WeightDescend/WeightSize).^3;
WeightAscend = 1:WeightSize;
WeightAscend = (WeightAscend/WeightSize).^3;
Weight = WeightDescend + WeightAscend;
WeightDescend = WeightDescend./Weight;
WeightAscend = WeightAscend./Weight;

% 提取阴影右渐变带和中间左渐变带.
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

% 提取中间右渐变带和高亮左渐变带.
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

%% 合成最后结果.
if OpenMatteS == 1
    WholeLuminOnlyResult = Lab2RGB(LABSourceChannelL,LABSourceLuminanceOnlyChannelA,LABSourceLuminanceOnlyChannelB);
    WholeHueOnlyResult = Lab2RGB(SourceOriginal,LABSourceChannelA,LABSourceChannelB);
    WholeHueSynResult = Lab2RGB(LABSourceChannelL,LABSourceChannelA,LABSourceChannelB);
else 
    WholeLuminOnlyResult =0;
    WholeHueOnlyResult = 0;
    WholeHueSynResult = 0;
end
LuminaOnlyResult = Lab2RGB(LABSourceMatteChannelL,LABSourceMatteLuminanceOnlyChannelA,LABSourceMatteLuminanceOnlyChannelB);
HueOnlyResult = Lab2RGB(MatteOriginal,LABSourceMatteChannelA, LABSourceMatteChannelB);
HueSynResult = Lab2RGB(LABSourceMatteChannelL, LABSourceMatteChannelA, LABSourceMatteChannelB);

