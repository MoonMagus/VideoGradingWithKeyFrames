function ColorTransferWithinPerframe()
global SourceMatteOpen;
global SourceSynOpen;
global TargetForeMatteOpen;
global TargetBackMatteOpen;
global TargetSynOpen;
global ForeStruct;
global BackStruct;
global ResultStruct;
%% 渲染图像.
% 渲染前景.
SourceForeName = 'Images/amelie.jpg';
SourceFore = imread(SourceForeName);
if(SourceMatteOpen == 1)
    SourceForeMatteName = 'Images/amelieMatte.jpg';
    SourceForeMatte = imread(SourceForeMatteName);
else
    SourceForeMatte = 0;
end
TargetForeName = 'Images/interview.jpg';
TargetFore = imread(TargetForeName);
if(TargetForeMatteOpen == 1)
    TargetForeMatteName = 'Images/interviewMatte.jpg';
    TargetForeMatte = imread(TargetForeMatteName);
else
    TargetForeMatte = 0;
end
ForeStruct = LocalTransformationWithPerframe(TargetFore, SourceFore, TargetForeMatteOpen, SourceMatteOpen, TargetForeMatte, SourceForeMatte, 1, 0);
% 如果开启了源图像背景渲染，则再次渲染背景.
if (SourceSynOpen == 1)
    SourceBack = SourceFore;
    SourceBackMatte = 255 - SourceForeMatte;
    if(TargetSynOpen == 1) 
        TargetBack = TargetFore;
        TargetBackMatte = 255 -TargetForeMatte;
    else
        TargetBackName = 'transformers.jpg';
        TargetBack = imread(TargetBackName);
        if(TargetBackMatteOpen == 1)
            TargetBackMatteName = 'transformersMatte.jpg';
            TargetBackMatte = imread(TargetBackMatteName);
        else
            TargetBackMatte = 0;
        end
    end
    BackStruct = LocalTransformationWithPerframe(TargetBack, SourceBack, TargetBackMatteOpen, SourceMatteOpen, TargetBackMatte, SourceBackMatte, 1, 0.1);
end
% 合成渲染结果.
if (SourceSynOpen == 1)
    ResultStruct.CompositeLuminOnlyResult = CatImageMatteRegion(ForeStruct.WholeLuminOnlyResult, BackStruct.WholeLuminOnlyResult, SourceForeMatte);
    ResultStruct.CompostiteHueOnlyResult =  CatImageMatteRegion(ForeStruct.WholeHueOnlyResult, BackStruct.WholeHueOnlyResult, SourceForeMatte);
    ResultStruct.CompositeHueSynResult = CatImageMatteRegion(ForeStruct.WholeHueSynResult, BackStruct.WholeHueSynResult, SourceForeMatte);
else
    ResultStruct.CompositeLuminOnlyResult = ForeStruct.WholeLuminOnlyResult;
    ResultStruct.CompostiteHueOnlyResult = ForeStruct.WholeHueOnlyResult;
    ResultStruct.CompositeHueSynResult = ForeStruct.WholeHueSynResult;
end
ResultStruct.Source = SourceFore;
