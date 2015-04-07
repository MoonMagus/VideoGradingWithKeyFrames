function [L,a,b] = RGB2Lab(R,G,B)
% LAB2RGB将输入图像从RGB颜色空间转换到CIELAB颜色空间.
%
% function [L, a, b] = RGB2Lab(R, G, B)
% function [L, a, b] = RGB2Lab(I)
% function I = RGB2Lab(...)
%
% RGB2Lab函数的输入参数为红、绿、蓝三颜色矩阵，或者为单个参数的M x N x 3图像，
% 其输出参数为该图像在CIELAB颜色空间的表示. RGB数值可以是位于[0,1]或者[0,255]
% 范围的数值. L的取值范围为[0,100]，同时a和b的取值范围为[-110,110]. 输出参数
% 均为双浮点类型.
%
% 该函数变换采用ITU-R推荐标准BT.709来实现，使用D65光源参数进行参考白点的计算.
% 执行RGB->Lab->RGB的误差估计为10^-5.   

if nargin == 1
  B = double(R(:,:,3));
  G = double(R(:,:,2));
  R = double(R(:,:,1));
end

if max(max(R)) > 1.0 || max(max(G)) > 1.0 || max(max(B)) > 1.0
  R = double(R) / 255;
  G = double(G) / 255;
  B = double(B) / 255;
end

% 设定阈值.
T = 0.008856;

[M, N] = size(R);
s = M * N;
RGB = [reshape(R,1,s); reshape(G,1,s); reshape(B,1,s)];

% RGB转换到XYZ.
MAT = [0.412453 0.357580 0.180423;
       0.212671 0.715160 0.072169;
       0.019334 0.119193 0.950227];
XYZ = MAT * RGB;

% 进行D65参考光源下白点校正.
X = XYZ(1,:) / 0.950456;
Y = XYZ(2,:);
Z = XYZ(3,:) / 1.088754;

XT = X > T;
YT = Y > T;
ZT = Z > T;

Y3 = Y.^(1/3); 

fX = XT .* X.^(1/3) + (~XT) .* (7.787 .* X + 16/116);
fY = YT .* Y3 + (~YT) .* (7.787 .* Y + 16/116);
fZ = ZT .* Z.^(1/3) + (~ZT) .* (7.787 .* Z + 16/116);

L = reshape(YT .* (116 * Y3 - 16.0) + (~YT) .* (903.3 * Y), M, N);
a = reshape(500 * (fX - fY), M, N);
b = reshape(200 * (fY - fZ), M, N);

if nargout < 2
  L = cat(3,L,a,b);
end
