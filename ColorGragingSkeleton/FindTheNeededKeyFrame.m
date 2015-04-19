function index = FindTheNeededKeyFrame(SourceImageFeature ,TargetKeyframesFeature, nFrames)
% �ӹؼ�֡�������ҳ���Դͼ��֡��ӽ��Ĺؼ�֡.
MetricMatrix = zeros(1,nFrames);
for i = 1 : nFrames
    MetricMatrix(i) =  MetricDistance(SourceImageFeature, TargetKeyframesFeature(i));
end
[~, index] = min(MetricMatrix);
