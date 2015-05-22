function R = ColorTransferWithImageReinhard(Source, OpenMatteS, MatteS, Target, OpenMatteT, MatteT)
% 将蒙版叠加到源图像上.
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
    % 如果开启了源图像蒙版,保存源图像的L通道用于直方图统计.
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
% SourceMatte图像的L通道图像.
ls = LABSourceMatteChannelL;
R.ls = ls;
% SourceMatte图像的L通道统计直方图.
lsh = ChannelLSourceLocalMatte;
R.lsh = lsh;


% 计算各通道的标准偏差和平均值.
std1=std(ChannelLSourceLocalMatte,1);          
std2=std(ChannelASourceLocalMatte,1);          
std3=std(ChannelBSourceLocalMatte,1);
m1=mean(mean(ChannelLSourceLocalMatte)); 
m2=mean(mean(ChannelASourceLocalMatte)); 
m3=mean(mean(ChannelBSourceLocalMatte));
% 将蒙版叠加到目标图像上.
t = Target;
if OpenMatteT == 1
    mt = MatteT;
    dt = im2double(t);
    dmt = mat2gray(mt, [0 255]);
    bmt = im2bw(dmt, 0.5);
    rmt = double(repmat(bmt, [1 1 3]));
    rt = im2uint8(dt.*rmt);
else
    rt = Target;
end

% 计算目标图像的三通道值.
LABTargetImage = RGB2Lab(rt);    
TarLuminChannel = LABTargetImage(:,:,1);
TarAChannel = LABTargetImage(:,:,2);
TarBChannel = LABTargetImage(:,:,3);
eps = 0.001;
IndexTargetMatte = TarLuminChannel > eps;
TarMatteLuminanceChannel = TarLuminChannel(IndexTargetMatte);
TarMatteAChannel = TarAChannel(IndexTargetMatte);
TarMatteBChannel = TarBChannel(IndexTargetMatte);
% 计算各通道的标准偏差和平均值.
std4=std(TarMatteLuminanceChannel,1);           
std5=std(TarMatteAChannel,1);          
std6=std(TarMatteBChannel,1);
m4=mean(mean(TarMatteLuminanceChannel)); 
m5=mean(mean(TarMatteAChannel)); 
m6=mean(mean(TarMatteBChannel));


% 计算色调迁移结果.
LABSourceMatteChannelL(IndexSourceMatte) = (LABSourceMatteChannelL(IndexSourceMatte) - m1)*(std4 / std1) + m4;
LABSourceMatteChannelA(IndexSourceMatte) = (LABSourceMatteChannelA(IndexSourceMatte) - m2)*(std5 / std2) + m5;
LABSourceMatteChannelB(IndexSourceMatte) = (LABSourceMatteChannelB(IndexSourceMatte) - m3)*(std6 / std3) + m6;
if OpenMatteS == 1
    LABSourceChannelL(IndexSourceMatte) = (LABSourceChannelL(IndexSourceMatte) - m1)*(std4 / std1) + m4;
    LABSourceChannelA(IndexSourceMatte) = (LABSourceChannelA(IndexSourceMatte) - m2)*(std5 / std2) + m5;
    LABSourceChannelB(IndexSourceMatte) = (LABSourceChannelB(IndexSourceMatte) - m3)*(std6 / std3) + m6;
end

%% 合成最后结果.
if OpenMatteS == 1
    % whole的含义是添加蒙版后对蒙版区域进行处理，返回结果时保留蒙版区域之外的原始区域，使图像看起来没有切割.
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