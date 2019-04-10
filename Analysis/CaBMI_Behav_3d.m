function CaBMI_Behav_3d(mov,stereoParams);

mov = mov(:,:,:,1:100);

[height width color frames] =  size(mov(:,:,:,:));

disp('splitting video...');
G2b = mat2gray(double(imresize(squeeze(mov(:,1281:end,2,:)),1)));
G1b = mat2gray(double(imresize(squeeze(mov(:,1:1280,2,:)),1)));

% Offsets...
disp('resizing');
G1b = imresize(G1b(:,141:end,:),1);
G2b = imresize(G2b(:,1:end-140,:),1);

clear mov

% Subtract Median from each..
disp('calculating Median...');
meanIm1 = median(G1b,3);
meanIm2 = median(G2b,3);
G2b = mat2gray(G2b-meanIm2);
G1b = mat2gray(G1b-meanIm1);


% figure();
%  for i = 1:size(mov,4); 
%  img2show = mat2gray(double(G1b(:,:,i)))-mat2gray(double(G2b(:,:,i)));
%     imagesc(img2show); 
%     colormap(fireice); pause(0.01);     
%  end

 %load('handshakeStereoParams.mat');
% showExtrinsics(stereoParams);

disp('Rectifying Frames...');
figure;
for i = 1:frames;
    [frameLeftRect(:,:,i), frameRightRect(:,:,i)] = rectifyStereoImages(G1b(:,:,i), G2b(:,:,i), stereoParams,'OutputView','valid');
%[frameLeftRect, frameRightRect] =rectifyStereoImages(G1b(:,:,1), G2b(:,:,1), stereoParams);
%J(:,:,:,i) = stereoAnaglyph(frameRightRect(:,:,i), frameLeftRect(:,:,i));
end

clear G1b G2b mov

disp('downsampleing videos...');
% frameLeftRect = imresize(frameLeftRect,0.5);
% frameRightRect = imresize(frameRightRect,0.5);

figure(); 
% 
% for i = 1:100;    
% disparityMap = disparity(frameLeftRect(:,:,i), frameRightRect(:,:,i));
% disparityMap(disparityMap<0) =0;
% im1_rgb=ind2rgb(round(mat2gray(disparityMap)*64),jet(64));
% alpha = 0.8-mat2gray(double(rgb2gray(squeeze(J(:,:,:,i)))));
% 
% % Single Use Plotting, make alpha mask
%  imwrite(im1_rgb,'Filename.png','Alpha',alpha);
%  I(:,:,:,i) = imread('Filename.png', 'BackgroundColor',[0 0 0]);
% end

% figure(); for i= 1:10; imshow(I(:,:,:,i)); pause(0.01); end
% 


figure();
% for i = 1:size(mov,4);
% % imshow(stereoAnaglyph(frameLeftRect(:,:,i), frameRightRect(:,:,i)));
% imagesc(J(:,:,:,i))
% pause(0.01);
% end
% 

disp('processing frame...' )
% Get depth profile by dispersion map...
for i = 1:frames;
    
    [D,movingReg,I2(:,:,:,i)] = BesselAlign_nonrigid(frameRightRect(50:end,:,i),frameLeftRect(50:end,:,i));
    disp(num2str(i));
end


figure(); 
for i = 1:frames;
    imagesc(I2(:,:,:,i));
    pause(0.01);
end



figure(); 
for i = 1:frames;
    imagesc(I2(:,:,:,i));
    pause(0.01);
end



filename = ['NewGif ', datestr(now),'_','.gif'];
disp('Making Gif...')



delay=0.03;
frame=size(I4,4);
for i = 1:frame
    [imind,cm] = rgb2ind(I4(:,:,:,i),256);
    if i==1
        imwrite(imind,cm,filename,'gif', 'DelayTime', delay,'LoopCount',inf); %save file output
    else
        imwrite(imind,cm,filename,'gif','WriteMode', 'append', 'DelayTime', delay); %save file output
    end
end

