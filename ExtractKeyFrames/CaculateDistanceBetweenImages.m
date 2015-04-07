function d = CaculateDistanceBetweenImages(NameImageP, NameImageQ)
% 计算两幅图像之间的最优传输距离.

NameImageP = '第204帧.jpg';
NameImageQ = '第220帧.jpg';
P = ExtractLABBandFeature(NameImageP);
Q = ExtractLABBandFeature(NameImageQ);
d = MetricDistance(P,Q);