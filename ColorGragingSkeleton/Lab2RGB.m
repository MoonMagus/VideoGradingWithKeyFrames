function [R, G, B] = Lab2RGB(L, a, b)
% LAB2RGB将输入图像从CIELAB颜色空间转换到RGB颜色空间.
%
% function [R, G, B] = Lab2RGB(L, a, b)
% function [R, G, B] = Lab2RGB(I)
% function I = Lab2RGB(...)
%
% Lab2RGB函数的输入为L,a,b三个参数的双浮点矩阵，或者是一个M x N x 3的双浮点图像,
% 输出为该图像在RGB颜色空间的表示. L的取值范围为[0,100]，同时a和b的取值范围为
% [-110,110]. 如果指定了三个输出参数，那么输出结果将会被归一化到取值区间[0,1],
% 否则取值范围将会采用unit8s表示到范围[0,255].
%
% 该函数变换采用ITU-R推荐标准BT.709来实现，使用D65光源参数进行参考白点的计算.
% 执行RGB->Lab->RGB的误差估计为10^-5. 

if nargin == 1
  b = L(:,:,3);
  a = L(:,:,2);
  L = L(:,:,1);
end

% 设定阈值.
T1 = 0.008856;
T2 = 0.206893;

[M, N] = size(L);
s = M * N;
L = reshape(L, 1, s);
a = reshape(a, 1, s);
b = reshape(b, 1, s);

% 计算Y值.
fY = ((L + 16) / 116) .^ 3;
YT = fY > T1;
fY = (~YT) .* (L / 903.3) + YT .* fY;
Y = fY;

% 微调fY用于稍后的计算.
fY = YT .* (fY .^ (1/3)) + (~YT) .* (7.787 .* fY + 16/116);

% 计算X值.
fX = a / 500 + fY;
XT = fX > T2;
X = (XT .* (fX .^ 3) + (~XT) .* ((fX - 16/116) / 7.787));

% 计算Z值.
fZ = fY - b / 200;
ZT = fZ > T2;
Z = (ZT .* (fZ .^ 3) + (~ZT) .* ((fZ - 16/116) / 7.787));

% 进行D65参考光源下白点校正.
X = X * 0.950456;
Z = Z * 1.088754;

% XYZ转换为RGB值.
MAT = [ 3.240479 -1.537150 -0.498535;
       -0.969256  1.875992  0.041556;
        0.055648 -0.204043  1.057311];

RGB = max(min(MAT * [X; Y; Z], 1), 0);

R = reshape(RGB(1,:), M, N);
G = reshape(RGB(2,:), M, N);
B = reshape(RGB(3,:), M, N); 

if nargout < 2
  R = uint8(round(cat(3,R,G,B) * 255));
end

