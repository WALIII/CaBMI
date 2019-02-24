function [D,movingReg,I] = BesselAlign_nonrigid(fixed,moving);
 % Align Bessel to Gaussian ( or vice versa)
 
 



    moving = imhistmatch(moving,fixed);
%    [D,Ar] = imregdemons(A,B,[500 400 200],'AccumulatedFieldSmoothing',1.3,'DisplayWaitBar',false);

   [D,movingReg] = imregdemons(moving,fixed,[100 50 50],'AccumulatedFieldSmoothing',1.3,'DisplayWaitBar',false);

  %% Plot warped image 
%    figure(1);
%    subplot(1,2,1);
%    imshowpair(moving,fixed);
%    subplot(1,2,2);
%   imshowpair(movingReg,fixed);
  
  %% Plot Displacmenet field
%   figure(2); 
%   subplot(1,2,1);
%   imagesc(D(:,:,1)); colormap(fireice); colorbar;
%   subplot(1,2,2);
%   imagesc(D(:,:,2)); colormap(fireice); colorbar;
  
  
  % Use displacmeent field to warp
  moving2 = imwarp(moving,D);
  
  %figure(3); 
  %imshowpair(moving2,fixed);
  
%   movingReg = imresize(movingReg,4);
%   D = imresize(D,4);
%figure(4);
% Single Use Plotting, make alpha mask
im1_rgb=ind2rgb(round(mat2gray(D(:,:,1))*200),jet(200));

h=fspecial('gaussian',10,10);
im1_rgb=imfilter(im1_rgb,h,'circular');


alpha = 0.7-mat2gray(fixed);

imwrite(im1_rgb,'Filename.png','Alpha',alpha);
I = imread('Filename.png', 'BackgroundColor',[0 0 0]);


imagesc(I);
      
end