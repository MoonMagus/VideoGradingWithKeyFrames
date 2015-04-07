function C = ExtractLABBandFeature(RGBImageName)
% 将输入的RGB图像依据亮度分离成不同的数据带.

RGBImage = imread(RGBImageName);
LABImage = RGB2Lab(RGBImage);
ChannelL = LABImage(:,:,1);
ChannelA = LABImage(:,:,2);
ChannelB = LABImage(:,:,3);

%% 将源图像分成不同的亮度带.
[x,y] = size(ChannelL);
LuminanceData = reshape(ChannelL,1,x*y);
[LuminanceData, IndexLuminance] = sort(LuminanceData);

%% 计算LAB颜色空间不同通道各亮度带的特征值.
% 计算阴影带.
LABShadowBandL = ChannelL(IndexLuminance(1:floor(x*y/3)));
LABShadowBandA = ChannelA(IndexLuminance(1:floor(x*y/3)));
LABShadowBandB = ChannelB(IndexLuminance(1:floor(x*y/3)));
LABShadowBandL = reshape(LABShadowBandL,floor(x*y/3),1);
LABShadowBandA = reshape(LABShadowBandA,floor(x*y/3),1);
LABShadowBandB = reshape(LABShadowBandB,floor(x*y/3),1);
MeanOfLABSL = sum(LABShadowBandL)/(x*y/3);
MeanOfLABSA = sum(LABShadowBandA)/(x*y/3);
MeanOfLABSB = sum(LABShadowBandB)/(x*y/3);
% 计算中间带.
LABMiddleBandL = ChannelL(IndexLuminance(floor(x*y/3)+1:floor(2*x*y/3)));
LABMiddleBandA = ChannelA(IndexLuminance(floor(x*y/3)+1:floor(2*x*y/3)));
LABMiddleBandB = ChannelB(IndexLuminance(floor(x*y/3)+1:floor(2*x*y/3)));
LABMiddleBandL = reshape(LABMiddleBandL,floor(2*x*y/3)-floor(x*y/3),1);
LABMiddleBandA = reshape(LABMiddleBandA,floor(2*x*y/3)-floor(x*y/3),1);
LABMiddleBandB = reshape(LABMiddleBandB,floor(2*x*y/3)-floor(x*y/3),1);
MeanOfLABML = sum(LABMiddleBandL)/(x*y/3);
MeanOfLABMA = sum(LABMiddleBandA)/(x*y/3);
MeanOfLABMB = sum(LABMiddleBandB)/(x*y/3);
% 计算高亮带.
LABHighBandL = ChannelL(IndexLuminance(floor(2*x*y/3)+1:x*y));
LABHighBandA = ChannelA(IndexLuminance(floor(2*x*y/3)+1:x*y));
LABHighBandB = ChannelB(IndexLuminance(floor(2*x*y/3)+1:x*y));
LABHighBandL = reshape(LABHighBandL,x*y-floor(2*x*y/3),1);
LABHighBandA = reshape(LABHighBandA,x*y-floor(2*x*y/3),1);
LABHighBandB = reshape(LABHighBandB,x*y-floor(2*x*y/3),1);
MeanOfLABHL = sum(LABHighBandL)/(x*y/3);
MeanOfLABHA = sum(LABHighBandA)/(x*y/3);
MeanOfLABHB = sum(LABHighBandB)/(x*y/3);

%% 计算LAB颜色空间的特征值矩阵.
%阴影带.
MeanShadow = [MeanOfLABSL;MeanOfLABSA;MeanOfLABSB];
CovShadow(:,1) = LABShadowBandL;
CovShadow(:,2) = LABShadowBandA;
CovShadow(:,3) = LABShadowBandB;
CovShadowMatrix = cov(CovShadow);
MS = MeanShadow;
ES = CovShadowMatrix;
%中间带.
MeanMiddle = [MeanOfLABML;MeanOfLABMA;MeanOfLABMB];
CovMiddle(:,1) = LABMiddleBandL;
CovMiddle(:,2) = LABMiddleBandA;
CovMiddle(:,3) = LABMiddleBandB;
CovMiddleMatrix = cov(CovMiddle);
MM = MeanMiddle;
EM = CovMiddleMatrix;
%高亮带.
MeanHigh = [MeanOfLABHL;MeanOfLABHA;MeanOfLABHB];
CovHigh(:,1) = LABHighBandL;
CovHigh(:,2) = LABHighBandA;
CovHigh(:,3) = LABHighBandB;
CovHighMatrix = cov(CovHigh);
MH = MeanHigh;
EH = CovHighMatrix;

%返回参数.
C.MS = MS;
C.ES = ES;
C.MM = MM;
C.EM = EM;
C.MH = MH;
C.EH = EH;

% MS,ES,MM,EM,MH,EH








