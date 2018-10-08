function CaBMI_Spatiotemporal(ROIhits, ROI,ROIb,varargin)
% CaBMI_Spatiotemporal.m

% plot the top 100 cells in time, then plot their spatial distribution
% Uses dependencies in CaBMI: https://github.com/WALIII/CaBMI

% d09/30/2018
% WAL3


% Inputs:
%   ROIhits = matrix of (hits x frames x ROIs)
%   ROI = ROI mask for Indirect ROIs
%   ROIb = masks for Direct ROIs
% Optional Inputs
%   roidx = manual ROI index  ex: CaBMI_Spatiotemporal(ROIhits, ROI,ROIb,'order',roidx);


% Hard coded inputs
topmax = size(ROIhits,3); % max # of cells
man = 0;

% Manual inputs
vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'order') % manually inputing a sort order
    roidx=vin{i+1};
    man =1;
  elseif isequal(vin{i},'ri')
    ri=vin{i+1};
end
end

 % Make Schnitz plot
 figure();
 clear data3;
  G1 = ROIhits;

% sort cells
rn = 150:250;% range
c = squeeze(mean(G1(:,rn,:),1));
 [m,ind] = max(c);
[ind] = mean(c);
[m2, ind2] = sort(ind,'descend');
% B1 = 1:size(G1,1); %ind2(1:300);
B1 = ind2(1:topmax); %ind2(1:300);

% Base on an arbitrary sort
if man ==1
  disp('WARNING: Sorting based on manual input')
B1 = roidx;
end


range_null = [1:100]; % make a null range, 200-100 frames before the hit!
range_true = [155:255]; % A true range, in the ~100 framse surrounding the hit
offset = 0;

figure();
data3.undirected = G1(1+offset:2:size(G1,1),range_null,B1);
data3.directed = G1(2+offset:2:size(G1,1),range_null,B1);
[~,~,~] = CaBMI_schnitz(data3);
title(' null range');

 figure();
data3.undirected = G1(1:2:size(G1,1),range_true,B1);
data3.directed = G1(2:2:size(G1,1),range_true,B1);
[indX,B,C] = CaBMI_schnitz(data3);
title('true range');
 % Make clim matched image overlays

 %%%% plot the  map
 a2(1,:,:) = B';
 a2(2,:,:) = C';

for i = 1:size(B1,2);
    cb(:,1) = (B(i,:))';
    cb(:,2) = (C(i,:))';
r = corr(cb);
rk(:,i) = r(1,2);
end
% fale alpha = ccd = ones(1,size(B1,2))'; % alpha valu
 ccd = mat2gray(rk);
[a,b] = max(B'); % this will be the max of the image matrix ( use b)

% ccd = 1-round(mat2gray(c),1);
ccd2 = ccd;
ccd(ccd<.95)=.1; % Set opacity to all low mean correlation scores
B4 = B1(indX);
B4(ccd2<.95) = []; % Remove low values

col = jet(max(b));
figure();
% imagesc(flip(ROI_1.reference_image));
% colormap(gray);
hold on;

for i = 1:size(B1,2)
col1 = cat(2,col(b(i),:),ccd(i));
plot(ROI.coordinates{B1(i)}(:,1),ROI.coordinates{B1(i)}(:,2),'LineWidth',1,'Color',col1);
hold on;
end
colormap(jet)
xlim([0 500]);
ylim([0 500]);
colorbar;

hold on;
for i = 1:4;
    plot(ROIb.coordinates{i}(:,1),ROIb.coordinates{i}(:,2),'LineWidth',1,'Color','k');
end



% plot with fire/ice colormap
col = hot(max(b));

col = [ones(round(max(b)/2),1),zeros(round(max(b)/2),1),zeros(round(max(b)/2),1)];
colb = [zeros(round(max(b)/2),1),zeros(round(max(b)/2),1),ones(round(max(b)/2),1)];
col3 = cat(1,col,colb);
col = col3;

figure();
% imagesc(flip(ROI_1.reference_image));
% colormap(gray);
hold on;

for i = 1:size(B1,2)
col1 = cat(2,col(b(i),:),ccd(i));
plot(ROI.coordinates{B1(i)}(:,1),ROI.coordinates{B1(i)}(:,2),'LineWidth',1,'Color',col1);
hold on;
end
colormap(hot)
xlim([0 500]);
ylim([0 500]);
colorbar;

hold on;
for i = 1:4;
    plot(ROIb.coordinates{i}(:,1),ROIb.coordinates{i}(:,2),'LineWidth',1,'Color','k');
end



figure();
data3.undirected = G1(1:2:size(G1,1),range_true,B4);
data3.directed = G1(2:2:size(G1,1),range_true,B4);
[indX,B,C] = CaBMI_schnitz(data3);
title('true range, all high corr values ');
 % Make clim matched image overlays
