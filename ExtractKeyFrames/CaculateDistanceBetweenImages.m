function d = CaculateDistanceBetweenImages(NameImageP, NameImageQ)
% ��������ͼ��֮������Ŵ������.

NameImageP = '��204֡.jpg';
NameImageQ = '��220֡.jpg';
P = ExtractLABBandFeature(NameImageP);
Q = ExtractLABBandFeature(NameImageQ);
d = MetricDistance(P,Q);