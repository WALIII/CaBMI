function  CaBMI_Align_AcrossDays_ccimage(I, pl)




% gram frame
X = pl.PixelsPerLine(); % get x dim of the image
Y = pl.LinesPerFrame(); % get y dim of the image

disp('Gathering raw data')
for i = 1:200
current(:,:,i) = double( pl.GetImage_2(2,X,Y)); % Build the image
pause(0.04);
end

% A catch to save time in the case we forget to turn on the aquisition...
if current(:,:,1) == current(:,:,2);
    disp(' turn on aquisition, and re-run function');
    return
end
    


    I = double(I);
disp('computing ccorr image for reference data')
[ccimage_01]=CrossCorrImage(I(:,:,10:200));

disp('Computing ccorr image for new data');
[ccimage_02]=CrossCorrImage(current(:,:,10:200));

figure(1);
RGB1 = CaBMI_XMASS(ccimage_01,ccimage_02,ccimage_01);
image(squeeze(RGB1(:,:,1,:)));
title('G = current; M = ref');
