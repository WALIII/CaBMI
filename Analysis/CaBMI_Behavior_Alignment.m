function [RewMov] =  CaBMI_Behavior_Alignment(Yf);
%  CaBMI_Behavior_Alignment

% *  locate the LED,


%params:
playManyMov = 0 ;
playVid = 0;
PCA_Movie = 0;

Y2 = mean(Yf,3);
try
    load('image_roi/roi_data_image.mat')
    
catch
        disp('pick out the LED');

    FS_Image_ROI(Y2);
    load('image_roi/roi_data_image.mat')
    
end

% Plot the whole time-series:
Mov_Vect = smooth(abs(diff(squeeze(mean(mean(Yf-median(Yf,3),2),1)))),2);
figure(); plot(Mov_Vect)
% itteratively, to save ram..
for i = 1:size(Yf,3);
    h =  mean( Yf(ROI.coordinates{1}(:,2),ROI.coordinates{1}(:,1),i),1);
    cc(i) = mean(h);
end

pVect = double(zscore((cc)));
[Bpks,Blocs] = findpeaks(zscore(diff(pVect)),'MinPeakHeight',4,'MinPeakDistance',2);

figure();
hold on;
plot(pVect);
plot(Blocs,ones(size(Blocs))+4,'*');


Blocs2 = randi(size(Yf,3),1,size(Blocs,2)*2);

int1 = size(Blocs,2);
Blocs3 = 1:size(Yf,3)/(int1+1): size(Yf,3);
% * index into frames:
clear RewMov MRewMov
for i = 1:size(Blocs,2)
    RewMov(:,:,:,i) = Yf(:,:,Blocs(i)-100:Blocs(i)+100);
    Des_Mov_Vect(i) = mean(Mov_Vect(Blocs(i)-10:Blocs(i)));
        Des_Mov_Vect_n(i) = mean(Mov_Vect(Blocs3(i+1)-10:Blocs3(i+1)));

end

figure(); hold on;
plot(Des_Mov_Vect,'r*');
title(' Raw Movement over time')
%plot(Des_Mov_Vect_n,'b*');

clear idx1 var_to_plot
n_epochs = 6;



idx1 = 1:floor(size(Des_Mov_Vect,2)/n_epochs):size(Des_Mov_Vect,2); % 5 groups

for i = 1: n_epochs-1
var_to_plot{1}(i,:) = Des_Mov_Vect(idx1(i):idx1(i+1));
end
% plot movement over time:
figure();
hold on;
errorbar([1:n_epochs-1], nanmean(var_to_plot{1}'),...
        nanstd(var_to_plot{1}')/sqrt(length(var_to_plot{1}')), 'color', ...
    'b', 'LineWidth', 2);

clear idx1 var_to_plot
idx1 = 1:floor(size(Des_Mov_Vect_n,2)/n_epochs):size(Des_Mov_Vect_n,2); % 5 groups

for i = 1: n_epochs-1
var_to_plot{1}(i,:) = Des_Mov_Vect_n(idx1(i):idx1(i+1));
end
% plot movement over time:
errorbar([1:n_epochs-1], nanmean(var_to_plot{1}'),...
        nanstd(var_to_plot{1}')/sqrt(length(var_to_plot{1}')), 'color', ...
    'r', 'LineWidth', 2);
title('BMI (b) Random (r) Movement over time');




% create null block
for i = 1:size(Blocs,2)
    try
    RewMov_null(:,:,:,i) = Yf(:,:,Blocs2(i)-100:Blocs2(i)+100);
    catch
    end
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
MRewMov = MRewMov-median(MRewMov(:,:,:),3);

MRewMov2 = squeeze(median(RewMov(:,:,:,Chp:(Chp*2)),4));
MRewMov2 = MRewMov2-median(MRewMov2(:,:,:),3);

MRewMov3 = squeeze(median(RewMov(:,:,:,(Chp*2):(Chp*3)-1),4));
MRewMov3 = MRewMov3-median(MRewMov3(:,:,:),3);

MRewMov4 = squeeze(median(RewMov(:,:,:,:),4));
Raw_MRewMov4 = squeeze(median(RewMov(:,:,:,:),4));
MRewMov4 = MRewMov4-median(MRewMov4(:,:,:),3);

% Null mov:
MRewMov_n = squeeze(median(RewMov_null(:,:,:,:),4));
MRewMov_n  = MRewMov_n -median(MRewMov_n (:,:,:),3);


MRewMov_even = squeeze(median(RewMov(:,:,:,1:2:end),4));
MRewMov_even = MRewMov_even-median(MRewMov_even(:,:,:),3);

MRewMov_odd = squeeze(median(RewMov(:,:,:,2:2:end),4));
MRewMov__odd = MRewMov_odd-median(MRewMov_odd(:,:,:),3);

%for ii = 1:200
%   RGB1(:,:,:,ii) = XMASS_tish(MRewMov(:,:,ii),MRewMov2(:,:,ii),MRewMov3(:,:,ii));
%end

% figure();
% for i = 1: 200%size(RewMov,3);
%     imagesc(RGB1(:,:,:,i),[0 60]);
%     pause(0.05);
% end

if playVid ==1;
    figure();
    for i = 1: size(RewMov,3);
        colormap(gray);
        imagesc(MRewMov3(:,:,i),[0,60]);
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
X1 = std(MRewMov(:,:,60:101),[],3)-std(MRewMov(:,:,1:30),[],3);
X2 = std(MRewMov2(:,:,60:101),[],3)-std(MRewMov2(:,:,1:30),[],3);
X3 = std(MRewMov3(:,:,60:101),[],3)-std(MRewMov3(:,:,1:30),[],3);

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
X4 = std(MRewMov4(:,:,60:101),[],3)-std(MRewMov4(:,:,1:30),[],3);
subplot(1,3,1)
imagesc((X4));
title('std image')

subplot(1,3,2);
imagesc(abs(X4-median(X4(:))));
title('absolute value of std image')

subplot(1,3,3);
X4_2 = X4-median(X4(:));
X4_2(X4_2<0) = 0;
imagesc(X4_2);
title('absolute value of std image')


X_even = std(MRewMov_even(:,:,60:101),[],3)-std(MRewMov_even(:,:,1:30),[],3);
X_odd = std(MRewMov_odd(:,:,60:101),[],3)-std(MRewMov_odd(:,:,1:30),[],3);

figure();
subplot(121)
Ev = (X_even-median(X_even(:)));
Ev(Ev<0) = 0;
imagesc(Ev);
title('even trials');

subplot(122)
Od = (X_odd-median(X_odd(:)));
Od(Od<0) = 0;
imagesc(Od);
title('odd trials');



% PCA movie
if PCA_Movie ==1
    disp('plotting the PC');
    [pcaImage] = CaBMI_PCA_Mov_Plotting(MRewMov4(:,:,60:100));
    
    % Plot PC data:
    
    figure(); hold on;
    for ii = 1:3
        PC_idx = imbinarize(pcaImage(:,:,ii)-mean(pcaImage,3));
        
        for i = 1: size(MRewMov4,3)
            temp = MRewMov4(:,:,i);
            temp =  temp.*PC_idx;
            PC_TS(ii,i) = squeeze(mean(mean(temp,1),2));
        end
        plot(PC_TS(ii,:)-PC_TS(ii,1) ); % full timeseries with greatest motion in PC...
    end
end

% Plot based on the STD image
clear tt3a tt4a
mask2 = mat2gray(X4_2);
mask2(mask2<0.1) = 0;
for i = 1: size(MRewMov4,3)
    temp = MRewMov4(:,:,i);
    temp =  temp.*mask2;
    STD_TS(i) = squeeze(mean(mean(temp,1),2));
    
    temp2 = MRewMov_n(:,:,i);
    temp2 =  temp2.*mask2;
    STD_TS_n(i) = squeeze(mean(mean(temp2,1),2));

end

TTT = MRewMov4.*mask2;
TTT2 = MRewMov_n.*mask2;
tt3 = reshape(TTT,size(TTT,1)*size(TTT,2),size(TTT,3));
tt4 = reshape(TTT2,size(TTT2,1)*size(TTT2,2),size(TTT2,3));

% remove zero pixels:
counter = 1;
for i = 1:size(tt3,1);
if sum(tt3(i,:)) ==0
else
    tt3a(counter,:) = smooth(tt3(i,:),10);
    tt4a(counter,:) = smooth(tt4(i,:),10);
    counter = counter+1;
end
end

figure(); 
hold on;  plot(abs(tt3a'),'r'); plot(abs(tt4a'),'b');

% plot w/ shaddederror 
figure();
hold on;
plot((1:size(tt3a,2))/30-(100/30), sum(abs(tt3a'),2)./size(tt3a,1),'r','LineWidth',3); 
plot((1:size(tt3a,2))/30-(100/30), sum(abs(tt4a'),2)./size(tt3a,1),'b','LineWidth',3);
plot([100/30-(100/30) 100/30-(100/30)],[0 max(sum(abs(tt3a'),2)./size(tt3a,1))*1.1],'r--')


figure();
hold on;
for i = 1:2

col = jet(2);
if i ==1
adata = tt3a;
else
    adata = tt4a;
end
L = size(adata,2);
se = std(adata)/4%/sqrt(length(adata));
mn = mean(adata);
mn = smooth(mn,1)';
 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(0.5);
plot(mn,'Color',col(i,:));
end
 



% % Plot with standard deviation bounds:
% % for all hits
% for ii = 1:size(RewMov,4)
%     aa = squeeze(RewMov(:,:,:,ii)-median(RewMov(:,:,:,ii),3));
%     aa = (aa);
% temp_mov = squeeze(aa.*mask2);
% tt3b = reshape(temp_mov,size(temp_mov,1)*size(temp_mov,2),size(temp_mov,3));
% % remove zero pixels:
% counter = 1;
% for i = 1:size(tt3b,1);
% if sum(tt3b(i,:)) ==0
% else
%     tt3b(counter,:) = tt3b(i,:);
%     counter = counter+1;
% end
% end
% tt3b_sum(:,ii) = mean(abs(tt3b));
% 
% 
%     aa2 = squeeze(RewMov_null(:,:,:,ii)-median(RewMov_null(:,:,:,ii),3));
%     aa2 = (aa2);
% temp_mov2 = squeeze(aa2.*mask2);
% tt3b2 = reshape(temp_mov2,size(temp_mov2,1)*size(temp_mov2,2),size(temp_mov2,3));
% 
% 
% % remove zero pixels:
% counter = 1;
% for i = 1:size(tt3b2,1);
% if sum(tt3b2(i,:)) ==0
% else
%     tt3b2(counter,:) = tt3b2(i,:);
%     counter = counter+1;
% end
% end
% 
% 
% tt3b_sum2(:,ii) = mean(abs(tt3b2));
% 
% end
% 
% 
% figure();hold on;
% S1 = median(tt3b_sum');
% 
% plot((S1))
% S2 = median(tt3b_sum2');
% plot((S2))
% 
% 
% figure(); plot(tt3b_sum)


% 
% 
% figure(); 
% hold on; 
% GGG = cat(2,STD_TS,STD_TS_n);
% GGG = zscore(GGG);
% plot(GGG(1:201));
% plot(GGG(201:401));
% 
% plot([100 100],[-2 4],'r--')
% title('STD based ROI');
% xlabel('Frames')
% ylabel('z-score');


if playVid ==1;
    clear GGt dff_vid
%% Plot based on the dff video
dff_vid = MRewMov4;
figure();
for i = 1: 200;
    GGt(:,:,i) = abs(dff_vid(:,:,i)-median(dff_vid,3));
    imagesc(GGt(:,:,i),[0 120]);
    colormap(hot); pause(0.03);
end
GG = squeeze(mean(mean(GGt,2),1));
figure(); plot(GG)
end

% 
% 
% % plot all mean vectors:
% for i = 1:size(RewMov,4)
% Rtemp = squeeze(RewMov(:,:,:,i));
% for ii = 1:200;
% R(:,:,ii) = abs(Rtemp(:,:,ii)-mean(Rtemp,3));
% end
% Rgg(:,i) = squeeze(mean(mean(R,2),1));
% end
% figure(); 
% hold on;
% cmap = hot(size(Rgg,2));
% for i= 1:size(Rgg,2)
%     plot(smooth(Rgg(:,i),10),'color',cmap(i,:));
% end
% 
% 







% figure(); XMASS_tish(X1,X2,X3);
figure(1);
close(1);
figure(1);


[im1_rgb norm_max_proj{i},I{i},idx_img{i}] = CABMI_allpxs(MRewMov4(:,:,60:101),'filt_rad',2,'exp',4);




figure();
colormap(gray)
imagesc((squeeze(RewMov(:,:,100,2))))
colormap(gray); freezeColors;

hold on
OverlayImage =  imagesc(X4_2);
caxis auto
colormap( OverlayImage.Parent, hot );
alpha1 = (~isnan(mat2gray(X4_2)))*0.8;
set( OverlayImage, 'AlphaData', alpha1 );
colorbar();


figure();
colormap(gray)
imagesc((squeeze(RewMov(:,:,100,2))))
colormap(gray); freezeColors;

hold on
OverlayImage =  imagesc(I{i});
caxis auto
colormap( OverlayImage.Parent, hot );
alpha1 = (~isnan(mat2gray(X4)))*0.6;
set( OverlayImage, 'AlphaData', alpha1 );




if playVid ==1;
%% Plot based on the dff video
dff_vid = diff(Raw_MRewMov4,2,3);
figure();
for i = 1: 200;
    
    
colormap(gray)
imagesc(squeeze(MRewMov4(:,:,i)));
colormap(gray); freezeColors;

hold on
 GGt(:,:,i) = abs(dff_vid(:,:,i)-mean(dff_vid,3));
%     
    OverlayImage = imagesc(GGt(:,:,i),[0 150]);
    
caxis auto
colormap( OverlayImage.Parent, hot );
alpha1 = (~isnan(mat2gray(X4)))*0.6;
set( OverlayImage, 'AlphaData', alpha1 );

pause(0.01);
   
end
GG = squeeze(mean(mean(GGt,2),1));
figure(); plot(GG)
end



