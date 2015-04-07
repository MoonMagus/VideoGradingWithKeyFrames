function catImage = CatImageMatteRegion(ImageA, ImageB, Matte)
dA = im2double(ImageA);
mA = Matte;
dmA = mat2gray(mA,[0 255]);
bmA = im2bw(dmA,0.5);
rmA = double(repmat(bmA,[1 1 3]));
rA = im2uint8(dA.*rmA);
imshow(rA);

dB = im2double(ImageB);
mB = 255 - Matte;
dmB = mat2gray(mB,[0 255]);
bmB = im2bw(dmB,0.5);
rmB = double(repmat(bmB,[1 1 3]));
rB = im2uint8(dB.*rmB);
catImage = rA + rB;

