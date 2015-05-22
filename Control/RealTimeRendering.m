function RealTimeRendering(image, leftOrRight)
% ÊµÊ±äÖÈ¾´°¿Ú.

global StartRealTimeRendering;
global LeftAxisHandle;
global RightAxisHandle;
global RealTimeWindowStruct;
if(StartRealTimeRendering == 0)
    [videoHeight, videoWidth, ~] = size(image);
    Position = get(LeftAxisHandle,'Position');
    RealTimeWindowStruct.AxesWidth = floor(Position(3));
    AxesWidth = RealTimeWindowStruct.AxesWidth;
    RealTimeWindowStruct.AxesHeight = floor(Position(4));
    AxesHeight = RealTimeWindowStruct.AxesHeight;
    RealTimeWindowStruct.AxesHeight;
    if(videoHeight/videoWidth < AxesHeight/AxesWidth)
        RealTimeWindowStruct.h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
        RealTimeWindowStruct.h2 = floor(AxesWidth * videoHeight / videoWidth);
        RealTimeWindowStruct.horizon = 1;
    else
        RealTimeWindowStruct.w1 = floor((AxesWidth - floor(AxesHeight* videoWidth / videoHeight))/2);
        RealTimeWindowStruct.w2 = floor(AxesHeight * videoWidth / videoHeight);
        RealTimeWindowStruct.horizon = 0;
    end
    StartRealTimeRendering = 1;
end
if(leftOrRight == 1)
    mov = zeros(RealTimeWindowStruct.AxesHeight, RealTimeWindowStruct.AxesWidth, 3, 'uint8');
    if(RealTimeWindowStruct.horizon == 1)
        mov(RealTimeWindowStruct.h1 : RealTimeWindowStruct.h1 + RealTimeWindowStruct.h2 - 1, :, :) = imresize(image,[RealTimeWindowStruct.h2, RealTimeWindowStruct.AxesWidth]);
    else
        mov(:,RealTimeWindowStruct.w1 : RealTimeWindowStruct.w1 + RealTimeWindowStruct.w2 - 1, :) = imresize(image,[RealTimeWindowStruct.AxesHeight,RealTimeWindowStruct.w2]);
    end
        axes(LeftAxisHandle);
    imshow(mov);
else
    mov = zeros(RealTimeWindowStruct.AxesHeight, RealTimeWindowStruct.AxesWidth, 3, 'uint8');
    if(RealTimeWindowStruct.horizon == 1)
        mov(RealTimeWindowStruct.h1 : RealTimeWindowStruct.h1 + RealTimeWindowStruct.h2 - 1, :, :) = imresize(image,[RealTimeWindowStruct.h2, RealTimeWindowStruct.AxesWidth]);
    else
        mov(:,RealTimeWindowStruct.w1 : RealTimeWindowStruct.w1 + RealTimeWindowStruct.w2 - 1, :) = imresize(image,[RealTimeWindowStruct.AxesHeight,RealTimeWindowStruct.w2]);
    end
    axes(RightAxisHandle);
    imshow(mov);
end