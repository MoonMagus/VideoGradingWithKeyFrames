function index = FindTheNeededKeyFrame(SourceImageFeature ,TargetKeyframesFeature, nFrames)
% 从关键帧序列中找出和源图像帧最接近的关键帧.
MetricMatrix = zeros(1,nFrames);
for i = 1 : nFrames
    MetricMatrix(i) =  MetricDistance(SourceImageFeature, TargetKeyframesFeature(i));
end
[~, index] = min(MetricMatrix);
