function [C, HISTDATA] = ExtractBandFeatureWithMatte(RGBImageName, MatteImageName, OpenMatteReverse)
% �������RGBͼ���������ȷ���ɲ�ͬ�����ݴ�.
RGBImage = imread(RGBImageName);
RGBMatteImage = imread(MatteImageName);

%% ���ɰ���ӵ�Դͼ����.
s = RGBImage;
ds = im2double(s);
if(OpenMatteReverse == 1)
    ms = 255 - RGBMatteImage;
else
    ms = RGBMatteImage;
end
dms = mat2gray(ms,[0 255]);
bms = im2bw(dms,0.5); 
rms = double(repmat(bms,[1 1 3]));
rs = im2uint8(ds.*rms);

%% ���ڵ���.
Alpha = 0;
LABSourceMatteImage = RGB2Lab(rs);
%��Դͼ�����ָ��ģ�壬����ԭʼͼ���������.
LABSourceMatteChannelL = LABSourceMatteImage(:,:,1);
LABSourceMatteChannelA = LABSourceMatteImage(:,:,2);
LABSourceMatteChannelB = LABSourceMatteImage(:,:,3);
eps = 0.001;
IndexSourceMatte = find(LABSourceMatteChannelL > eps);
ChannelLSourceLocalMatte = LABSourceMatteChannelL(IndexSourceMatte);
ChannelASourceLocalMatte = LABSourceMatteChannelA(IndexSourceMatte);
ChannelBSourceLocalMatte = LABSourceMatteChannelB(IndexSourceMatte);
[~, IndexSourceLocalMatte] = sort(ChannelLSourceLocalMatte);
SizeSourceLocalMatte = size(IndexSourceLocalMatte,1);
%��������.


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


%% ����LAB��ɫ�ռ������ֵ����.
%��Ӱ��.
MSL = MeanShadowLSourceLocalMatte ;
MSA = MeanShadowASourceLocalMatte;
MSB = MeanShadowBSourceLocalMatte;
MS = [MSL;MSA;MSB];
ES  = CovShadowSourceLocalMatte;
%�м��.
MML = MeanMiddleLSourceLocalMatte;
MMA = MeanMiddleASourceLocalMatte;
MMB = MeanMiddleBSourceLocalMatte;
MM = [MML;MMA;MMB];
EM  = CovMiddleSourceLocalMatte;
%������.
MHL = MeanHighLSourceLocalMatte;
MHA = MeanHighASourceLocalMatte;
MHB = MeanHighBSourceLocalMatte;
MH = [MHL;MHA;MHB];
EH  = CovHighSourceLocalMatte;


%���ز���.
C.MS = MS;
C.ES = ES;
C.MM = MM;
C.EM = EM;
C.MH = MH;
C.EH = EH;
HISTDATA = ChannelLSourceLocalMatte;
