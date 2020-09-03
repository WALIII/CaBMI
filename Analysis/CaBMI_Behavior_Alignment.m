function [RewMov] =  CaBMI_Behavior_Alignment(Yf);
%  CaBMI_Behavior_Alignment

% *  locate the LED,


%params:
playManyMov = 0 ;
playVid = 0;
PCA_Movie = 1;

if exist('image_roi/')<1
    disp('pick out the LED');
    
    Y2 = mean(Yf,3);
    FS_Image_ROI(Y2);
    load('image_roi/roi_data_image.mat')
else
    load('image_roi/roi_data_image.mat')
    
end


% itteratively, to save ram..
for i = 1:size(Yf,3);
    h =  mean( Yf(ROI.coordinates{1}(:,2),ROI.coordinates{1}(:,1),i),1);
    cc(i) = mean(h);
end

pVect = double(zscore((cc)));
[Bpks,Blocs] = findpeaks(zscore(diff(pVect)),'MinPeakProminence',4,'MinPeakDistance',2);

figure();
hold on;
plot(pVect);
plot(Blocs,ones(size(Blocs))+4,'*');


% * index into frames:
clear RewMov MRewMov
for i = 1:size(Blocs,2)
    RewMov(:,:,:,i) = Yf(:,:,Blocs(i)-100:Blocs(i)+100);
end

% play so many movy:
if playManyMov ==1
    figure();
    for i = 1: size(RewMov,3);
        for ii = 1:6
            subplot(3,2,ii);
            imagesc(RewMov(:,:,i,ii+35));
        end
        pause(0.01);
    end
end

% play as one movie:
Chp  = size(RewMov,4)/3;

MRewMov = squeeze(median(RewMov(:,:,:,1:Chp),4));
MRewMov_actual = MRewMov;
MRewMov = MRewMov-median(MRewMov(:,:,:),3);

MRewMov2 = squeeze(median(RewMov(:,:,:,Chp:(Chp*2)),4));
MRewMov2 = MRewMov2-median(MRewMov2(:,:,:),3);

MRewMov3 = squeeze(median(RewMov(:,:,:,(Chp*2):(Chp*3)-1),4));
MRewMov3 = MRewMov3-median(MRewMov3(:,:,:),3);

MRewMov4 = squeeze(median(RewMov(:,:,:,:),4));
MRewMov4 = MRewMov4-median(MRewMov4(:,:,:),3);

MRewMov_even = squeeze(median(RewMov(:,:,:,1:2:end),4));
MRewMov_even = MRewMov_even-median(MRewMov_even(:,:,:),3);

MRewMov_odd = squeeze(median(RewMov(:,:,:,1:2:end),4));
MRewMov__odd = MRewMov_odd-median(MRewMov_odd(:,:,:),3);

%for ii = 1:200
%   RGB1(:,:,:,ii) = XMASS_tish(MRewMov(:,:,ii),MRewMov2(:,:,ii),MRewMov3(:,:,ii));
%end

% figure();
% for i = 1: 200%size(RewMov,3);
%     imagesc(RGB1(:,:,:,i),[0 70]);
%     pause(0.05);
% end

if playVid ==1;
    figure();
    for i = 1: size(RewMov,3);
        colormap(gray);
        imagesc(MRewMov3(:,:,i),[0,70]);
        pause(0.05);
    end
end


figure();
hold on;

aa = squeeze(std(mean(MRewMov,1),[],2));
aa= aa-min(aa);
bb = squeeze(std(mean(MRewMov2,1),[],2));
bb= bb-min(bb);

cc = squeeze(std(mean(MRewMov3,1),[],2));
cc= cc-min(cc);


figure();
hold on;
plot(smooth(aa,5),'r')
plot(smooth(bb,5),'g')
plot(smooth(cc,5),'b')
% to do: random reward ( shuffle)



% calculate STD differences:
X1 = std(MRewMov(:,:,70:101),[],3)-std(MRewMov(:,:,1:30),[],3);
X2 = std(MRewMov2(:,:,70:101),[],3)-std(MRewMov2(:,:,1:30),[],3);
X3 = std(MRewMov3(:,:,70:101),[],3)-std(MRewMov3(:,:,1:30),[],3);

figure();
subplot(1,4,1);
imagesc(squeeze(RewMov(:,:,100,2)));
colormap(gray);
freezeColors

subplot(1,4,2);
colormap(parula);
imagesc(X1,[-10 10]);
subplot(1,4,3);
imagesc(X2,[-10 10]);
subplot(1,4,4);
imagesc(X3,[-10 10]);

colorbar

figure();
X4 = std(MRewMov4(:,:,70:101),[],3)-std(MRewMov4(:,:,1:30),[],3);
subplot(1,2,1)
imagesc((X4));
title('std image')

subplot(1,2,2);
imagesc(abs(X4));
title('absolute value of std image')


X_even = std(MRewMov_even(:,:,70:101),[],3)-std(MRewMov_even(:,:,1:30),[],3);
X_odd = std(MRewMov_odd(:,:,70:101),[],3)-std(MRewMov_odd(:,:,1:30),[],3);

figure();
imagesc(X_even.*X_odd);



% PCA movie
if PCA_Movie ==1
    disp('plotting the PC');
    [pcaImage] = CaBMI_PCA_Mov_Plotting(MRewMov3(:,:,70:100));
    
    % Plot PC data:
    
    figure(); hold on;
    for ii = 1:3
            PC_idx = imbinarize(pcaImage(:,:,ii)-mean(pcaImage,3));

        for i = 1: size(MRewMov,3)
            temp = MRewMov(:,:,i);
            temp =  temp.*PC_idx;
            PC_TS(ii,i) = squeeze(mean(mean(temp,1),2));
        end
            plot(PC_TS(ii,:)-PC_TS(ii,1) ); % full timeseries with greatest motion in PC...
    end 
end

% Plot based on the STD image
mask1 = mat2gray((X4));
mask2 = mat2gray(abs(X4));
for i = 1: size(MRewMov,3)
            temp = MRewMov(:,:,i);
            temp =  temp.*mask2;
            STD_TS(i) = squeeze(mean(mean(temp,1),2));
end
figure(); plot(STD_TS);



% figure(); XMASS_tish(X1,X2,X3);
figure(1);
close(1);
figure(1);


[im1_rgb norm_max_proj{i},I{i},idx_img{i}] = CABMI_allpxs(MRewMov4(:,:,70:101),'filt_rad',3,'exp',4);




figure();
colormap(gray)
imagesc((squeeze(RewMov(:,:,100,2))))
colormap(gray); freezeColors;

hold on
OverlayImage =  imagesc(mat2gray(abs(X4).^2));
caxis auto  
colormap( OverlayImage.Parent, hot );
alpha = (~isnan(mat2gray(X4)))*0.6;
set( OverlayImage, 'AlphaData', alpha );



figure();
colormap(gray)
imagesc((squeeze(RewMov(:,:,100,2))))
colormap(gray); freezeColors;

hold on
OverlayImage =  imagesc(I{i});
caxis auto  
colormap( OverlayImage.Parent, hot );
alpha = (~isnan(mat2gray(X4)))*0.6;
set( OverlayImage, 'AlphaData', alpha );

