% CaBMI_AnalysisPipeline.m

% WAL3
% d3/18/18


%% PREFLIGHT
 %   1. Process ROI data
%   [ROI,roi_ave] = CaBMI_Process('type',2);
%  %   2. Check Data integrity ( plot ROI masks over reference image, check SNR of extracted data)
%
%  %   1. Load in .matlab data, plot E1 and E2, plus the cursor...
%   [B1 C1 D1 ] = CaIm_test(ROI,TData);

%   1.Load in ROI  data
load('csv_data.mat'); load('ave_roi.mat');  load('Y.mat');
 %   1. Extract 'Hits' from .CSV file
[ds_hits, roi_hits] = CaBMI_csvAlign(csv_data(:,2),csv_data(:,3),roi_ave); %   1. Load in Y ( temporally downsampled movie) from ds_data



%% BASIC ANALYSIS
 % Get video matrix around the hits

 % Get ROI traces in a matrix, bounded by the hits
 [ROIhits, ROIhits_d, ROIhits_s]= CaBMI_getROI(roi_ave,roi_hits);

 % get PCA matrix
  [PCA_mat]= CaBMI_PCA(roi_ave,roi_hits);

% PCA on video:
CaBMI_PCAmov(mov_data,varargin);


 % Make Schnitz plot
 figure();
 clear data3;
  G1 = ROIhits_z;
%  st = 30;
%  ed2 = size(G1,1);
%  ed1 = round(ed2/2);

% sort cells
% range
rn = 150:250;
c = squeeze(mean(G1(:,rn,:),1)-min(G1(:,rn,:),1));
 [m,ind] = max(c);
% [ind] = mean(c);

[m2, ind2] = sort(ind,'descend');
% B1 = 1:size(G1,1); %ind2(1:300);
B1 = ind2(1:300); %ind2(1:300);


 figure();
data3.undirected = G1(1:2:size(G1,1),155:255,B1);
data3.directed = G1(2:2:size(G1,1),155:255,B1);
[indX,B,C] = CaBMI_schnitz(data3);
 % Make clim matched image overlays



 % make running average schnitz
 close all
f1 = 15;
v = VideoWriter('Schnitz.mov');
open(v);
 for i = 1:size(ROIhits,1)-(f1+1);
      figure(10);
 data3.undirected = G1(1+i:f1+i,185:255,:);
data3.directed = G1(1:size(ROIhits,1),185:255,:);
[indX,B,C] = CaBMI_schnitz(data3);
F = getframe(gcf);
writeVideo(v, F);
 end
 close(v);

% Make raster plot

% Cluster data, then display organization on a raster plot ( sort by time!)


% Factor analysis ( num factors/dims over time)


% Kernal Density estimation:
% https://www.mathworks.com/matlabcentral/fileexchange/37374-ssvkernel-x-tin


% Node/network analysis:
%   1. How does covariance increase/decrease with hits?
%   2. Granger causality ( transfer of entropy?)
% http://alexhwilliams.info/itsneuronalblog/2016/03/27/pca/
% https://en.wikipedia.org/wiki/Mutual_information














%% MOVIE STUFF:

%% Get Avg Video
[VidHits, I]= CaBMI_getvid(Y,ds_hits);
   % sort into alternating movies...
   counter = 1;
  for i = 1:round(size(VidHits,4)/2);
   A1(:,:,:,counter) = squeeze(VidHits(:,:,:,i));
  counter = counter+1;
  end
  counter = 1
    for i = round(size(VidHits,4)/2):(size(VidHits,4));
   A2(:,:,:,counter) = squeeze(VidHits(:,:,:,i));
  counter = counter+1;
    end

    A1T = mean(A1,4);  A2T = mean(A2,4);  A1T = A1T-min(A1T,[],3); A2T = A2T-min(A2T,[],3);

    figure(); colormap(gray); for i = 1: 61; imagesc(squeeze(A2T(:,:,i)-10)); pause(0.1); end

  X =  CaBMI_XMASS(A2T,A1T,A2T);


  % Plot ROIs
    figure();
      imagesc(std(A2T,[],3));
      colormap(gray);
      hold on;
        for i = 1: 1000;
          hold on;
          plot(ROI.coordinates{1,i}(:,1),ROI.coordinates{1,i}(:,2));
        end

figure();  for i = 1: 61; imshow(squeeze(X(:,:,i,:))); pause(0.01); end
v = VideoWriter('GreenFirstHalf.mov');
open(v);
for i = 1:61
     writeVideo(v, squeeze(X(:,:,i,:)));
     disp(num2str(i));
end
close(v);





%% make alt movie:
 % sort into alternating movies...
   counter = 1;
  for i = 1:2:size(G1,1);
   A1(:,:,:,counter) = squeeze(VidHits(:,:,:,i));
  counter = counter+1;
  end
  counter = 1;
    for i = 2:2:(size(G1,1));
   A2(:,:,:,counter) = squeeze(VidHits(:,:,:,i));
  counter = counter+1;
    end

    A1T = mean(A1,4);  A2T = mean(A2,4);  A1T = A1T-min(A1T,[],3);    A2T = A2T-min(A2T,[],3);

    figure(); colormap(gray); for i = 1: 61; imagesc(squeeze(A2T(:,:,i)-10)); pause(0.1); end
      X =  CaBMI_XMASS(A2T,A1T,A2T);
    figure();  for i = 1: 61; imshow(squeeze(X(:,:,i,:))); pause(0.01); end
      v = VideoWriter('M2_interleaved.mov');
        open(v);
        for i = 1:61
          writeVideo(v, squeeze(X(:,:,i,:)));
          disp(num2str(i));
        end
        close(v);




%% Make Beeswarm plot:
% Get data from Lily's jupyter notebook:
g = [0.69258935 0.71622049 0.75296566 0.90446337 0.71081001 0.72428753  0.86529316];
data2 = h5read('IDNpredIDNperm_0.hf5','/perf_all_fake_combo' );
data = {g,data2(5,:),data2(6,:),data2(7,:),};
figure(); plotSpread(data)
