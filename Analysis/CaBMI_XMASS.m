function [RGB1 RGB2] = CaBMI_XMASS(GG1,GG2,GG3);


   HL = [0.15 .3];
   T = 1:size(GG1,2);
   F = 1:size(GG1,1);


Llim = HL(1);
 Hlim = HL(2);

im1(:,:,:,1)=  mat2gray(GG1);
im1(:,:,:,2)=  mat2gray(GG2);
im1(:,:,:,3)=  mat2gray(GG3);

% Mean subtracted/Normalized
im2 = im1./(mean(im1(:,:,[50:60 10:20],:),3)+.02);
im2 = im2 - mean(im2(:,:,[50:60 10:20],:),3);
im2 = mat2gray(im2);

rsjp = imadjust(im1(:),[Llim ; Hlim]);
rsjp2 = imadjust(im2(:),[Llim ; Hlim]);


 RGB1 = reshape(rsjp,[size(im1,1),size(im1,2),size(im1,3),3]);
 RGB2 = reshape(rsjp2,[size(im2,1),size(im2,2),size(im2,3),3]);

 %F = flip(F,1);
%RGB1 = RGB1(size(RGB1,1):-1:1,:,:);

%image(T,F,(RGB1));set(gca,'YDir','normal');

title('baseleine to baseline')

