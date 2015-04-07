function [L,a,b] = RGB2Lab(R,G,B)
% LAB2RGB������ͼ���RGB��ɫ�ռ�ת����CIELAB��ɫ�ռ�.
%
% function [L, a, b] = RGB2Lab(R, G, B)
% function [L, a, b] = RGB2Lab(I)
% function I = RGB2Lab(...)
%
% RGB2Lab�������������Ϊ�졢�̡�������ɫ���󣬻���Ϊ����������M x N x 3ͼ��
% ���������Ϊ��ͼ����CIELAB��ɫ�ռ�ı�ʾ. RGB��ֵ������λ��[0,1]����[0,255]
% ��Χ����ֵ. L��ȡֵ��ΧΪ[0,100]��ͬʱa��b��ȡֵ��ΧΪ[-110,110]. �������
% ��Ϊ˫��������.
%
% �ú����任����ITU-R�Ƽ���׼BT.709��ʵ�֣�ʹ��D65��Դ�������вο��׵�ļ���.
% ִ��RGB->Lab->RGB��������Ϊ10^-5.   

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

% �趨��ֵ.
T = 0.008856;

[M, N] = size(R);
s = M * N;
RGB = [reshape(R,1,s); reshape(G,1,s); reshape(B,1,s)];

% RGBת����XYZ.
MAT = [0.412453 0.357580 0.180423;
       0.212671 0.715160 0.072169;
       0.019334 0.119193 0.950227];
XYZ = MAT * RGB;

% ����D65�ο���Դ�°׵�У��.
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
