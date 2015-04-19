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
    RealTimeWindowStruct.h1 = floor((AxesHeight - floor(AxesWidth * videoHeight / videoWidth))/2);
    RealTimeWindowStruct.h2 = floor(AxesWidth * videoHeight / videoWidth);
    StartRealTimeRendering = 1;
end
if(leftOrRight == 1)
    mov = zeros(RealTimeWindowStruct.AxesHeight, RealTimeWindowStruct.AxesWidth, 3, 'uint8');
    mov(RealTimeWindowStruct.h1 : RealTimeWindowStruct.h1 + RealTimeWindowStruct.h2 - 1, :, :) = imresize(image,[RealTimeWindowStruct.h2, RealTimeWindowStruct.AxesWidth]);
    axes(LeftAxisHandle);
    imshow(mov);
else
    mov = zeros(RealTimeWindowStruct.AxesHeight, RealTimeWindowStruct.AxesWidth, 3, 'uint8');
    mov(RealTimeWindowStruct.h1 : RealTimeWindowStruct.h1 + RealTimeWindowStruct.h2 - 1, :, :) = imresize(image,[RealTimeWindowStruct.h2, RealTimeWindowStruct.AxesWidth]);
    axes(RightAxisHandle);
    imshow(mov);
end