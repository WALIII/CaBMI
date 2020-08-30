function [RewMov] =  CaBMI_Behavior_Alignment(Yf)
%  CaBMI_Behavior_Alignment

% *  locate the LED, 


%params:
playManyMov = 0 ;


if exist('image_roi')<1
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

[Bpks,Blocs] = findpeaks(diff(cc),'MinPeakProminence',30,'MinPeakDistance',2);

figure(); 
hold on; 
plot(cc);
plot(Blocs,ones(size(Blocs))+80,'*');


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

MRewMov = squeeze(mean(RewMov(:,:,:,1:25),4));
MRewMov_actual = MRewMov;
MRewMov = MRewMov-mean(MRewMov(:,:,:),3);

MRewMov2 = squeeze(mean(RewMov(:,:,:,25:50),4));
MRewMov2 = MRewMov2-mean(MRewMov2(:,:,:),3);

MRewMov3 = squeeze(mean(RewMov(:,:,:,50:75),4));
MRewMov3 = MRewMov3-mean(MRewMov3(:,:,:),3);

MRewMov4 = squeeze(mean(RewMov(:,:,:,:),4));
MRewMov4 = MRewMov4-mean(MRewMov4(:,:,:),3);


for ii = 1:200 
    RGB1(:,:,:,ii) = XMASS_tish(MRewMov(:,:,ii),MRewMov2(:,:,ii),MRewMov3(:,:,ii));
end

figure();
for i = 1: 200%size(RewMov,3);
    imagesc(RGB1(:,:,:,i),[0 70]);
    pause(0.05);
end


figure();
for i = 1: size(RewMov,3);
    colormap(gray);
    imagesc(MRewMov3(:,:,i),[0,70]);
    pause(0.05);
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
imagesc(squeeze(RewMov(:,:,100,50)));
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

figure(); XMASS_tish(X1,X2,X3);

figure(); [im1_rgb norm_max_proj{i},I{i},idx_img{i}] = CABMI_allpxs(MRewMov3(:,:,70:101),'filt_rad',1,'exp',3);