function [out] = CaBMI_Spatiotemporal(ROIhits, ROI,ROIb,varargin)
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
mid = round(size(ROIhits,2)/2);
bound = round(size(ROIhits,2)/4);
rn = (mid-bound):(mid+bound);% range
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


range_null = [1:bound*2]; % make a null range, 200-100 frames before the hit!
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
offset = 0;

figure();
data3.undirected = G1(1+offset:2:size(G1,1),range_null,B1);
data3.directed = G1(2+offset:2:size(G1,1),range_null,B1);
[~,~,~] = CaBMI_schnitz(data3);
title(' null range');
print(gcf,'-depsc','-painters','Null_schnitz.eps');
epsclean('Null_schnitz.eps'); % cleans and overwrites the input file

 figure();
data3.undirected = G1(1:2:size(G1,1),range_true,B1);
data3.directed = G1(2:2:size(G1,1),range_true,B1);
[indX,B,C] = CaBMI_schnitz(data3);
title('true range');
print(gcf,'-depsc','-painters','True_schnitz.eps');
epsclean('True_schnitz.eps'); % cleans and overwrites the input file
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
ccd(ccd<.80)=.1; % Set opacity to all low mean correlation scores
Bt = B1(indX); % correct the index here...
B4 = B1(indX); % correct the index here... use for refining thr schnitz
B4(ccd2<.90) = []; % Remove low values

col = jet(max(b));
figure();
% imagesc(flip(ROI_1.reference_image));
% colormap(gray);
hold on;

for i = 1:size(B1,2)
col1 = cat(2,col(b(i),:),ccd(i));
plot(ROI.coordinates{Bt(i)}(:,1),ROI.coordinates{Bt(i)}(:,2),'LineWidth',1,'Color',col1);
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

print(gcf,'-depsc','-painters','TimeMap.eps');
epsclean('TimeMap.eps'); % cleans and overwrites the input file


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
plot(ROI.coordinates{Bt(i)}(:,1),ROI.coordinates{Bt(i)}(:,2),'LineWidth',1,'Color',col1);
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

% Print map of time...
% print(gcf,'-depsc','-painters','TimeMap_2.eps');
% epsclean('TimeMap_2.eps'); % cleans and overwrites the input file

figure();
data3.undirected = G1(1:2:size(G1,1),range_true,B4);
data3.directed = G1(2:2:size(G1,1),range_true,B4);
[~,~,~] = CaBMI_schnitz(data3);
title('true range, all high corr values ');
 % Make clim matched image overlays
 
 print(gcf,'-depsc','-painters','High_Corr_schnitz.eps');
epsclean('High_Corr_schnitz.eps'); % cleans and overwrites the input file



%Get local time map
counter = 1;
% compute ROI to ROI differences, and time differences in one big matrix:
for ii = 1:size(ROIhits,3)% cell1
for i = 1:size(ROIhits,3)% cell2
    
    % euclidian distance
   r1 =  [mean(ROI.coordinates{Bt(i)}(:,1)),mean(ROI.coordinates{Bt(i)}(:,2))];
   r2 =  [mean(ROI.coordinates{Bt(ii)}(:,1)),mean(ROI.coordinates{Bt(ii)}(:,2))];
    
  distV(counter) =  pdist2(r1,r2);
    %time difference
  timeV(counter) = abs(b(i)-b(ii));
  counter = counter+1;
end
end


figure();
plot(distV(:),timeV(:),'*');


[aT, bT] = sort(distV(:),'ascend');
AB = timeV(:);
AB2 = AB(bT);
AB3 = AB(randperm(size(AB,1)));

% clear gg D Dtemp Dwhole
% dist = 30; 
%  % split into groups
% D = 1:floor((size(AB2,1)-1)/dist):size(AB2,1);
% 
% for ii = 1:dist;
% 
%     Dtemp(:,ii) = AB2(D(ii):D(ii+1));
%     Dtemp2(:,ii) = AB3(D(ii):D(ii+1));
% end
% 
% 
%     Dwhole = mat2gray(Dtemp);
%     Dwhole2 = mat2gray(Dtemp2);
% 
% 
% figure(); plot(Dwhole')
% gg{1} = Dwhole';
% gg{2} = Dwhole2';
% plotme(gg)





clear aT bT AB AB2 grp n counter bX Bxv err Bxvfk errfk
% sort by distance:
[aT, bT] = sort(distV(:),'ascend');
AB = timeV(:);
AB2 = AB(bT);
AB3 = AB(randperm(size(AB,1)));
% group data every 100 um
grp = 1;
n = 1;
counter = 1;
for i = 1:size(AB2,1);

    if aT(i)>n+10;
    grp = grp+1;
    n=n+10;
    counter = 1;
    end
    bX{grp}(:,counter) = AB2(i);
    bXfk{grp}(:,counter) = AB3(i);
    counter = counter+1;
end
    

for i = 1:size(bX,2);
    Bxv(:,i) = mean(bX{i});
    err(:,i) = std(bX{i})/sqrt(length(bX{i}));;
    
    Bxvfk(:,i) = mean(bXfk{i});
    errfk(:,i) = std(bXfk{i})/sqrt(length(bXfk{i}));;
    
end
figure();
hold on;
errorbar(1:length(Bxv),Bxv,err)
errorbar(1:length(Bxvfk),Bxvfk,errfk)

out.bX = bX;
out.bXfk = bXfk;



%% Get Time map for DIRECT neurons...


clear Bx bX bXfk errfk err timeVa distVa timeVb distVb
%Get local time map
counter = 1;
% compute ROI to ROI differences, and time differences in one big matrix:
for i = 1:2% cell1
for ii = 1:size(ROIhits,3)% cell2 
    % euclidian distance
   r1 =  [mean(ROIb.coordinates{i}(:,1)),mean(ROIb.coordinates{i}(:,2))];
   r2 =  [mean(ROI.coordinates{Bt(ii)}(:,1)),mean(ROI.coordinates{Bt(ii)}(:,2))];    
  distVa(i,ii) =  pdist2(r1,r2);
    %time difference
  timeVa(i,ii) = (max(b)/2-b(ii));
  
   r1b =  [mean(ROIb.coordinates{i+2}(:,1)),mean(ROIb.coordinates{i+2}(:,2))];
   r2b =  [mean(ROI.coordinates{Bt(ii)}(:,1)),mean(ROI.coordinates{Bt(ii)}(:,2))];    
  distVb(i,ii) =  pdist2(r1b,r2b);
    %time difference
  timeVb(i,ii) = (max(b)/2-b(ii));

end
end


[aT, bT] = sort(distVa(:),'ascend');
AB = timeVa(:);
AB2 = AB(bT);
AB3 = AB(randperm(size(AB,1)));


% group data every 100 um
grp = 1;
n = 1;
counter = 1;
for i = 1:size(AB2,1);

    if aT(i)>n+25;
    grp = grp+1;
    n=n+25;
    counter = 1;
    end
    bX{grp}(:,counter) = AB2(i);
    bXfk{grp}(:,counter) = AB3(i);
    counter = counter+1;
end
    
figure(); 
hold on;
h1 = histogram(bX{1},5);
% h2 = histogram(bXfk{2},5);
h1.Normalization = 'probability';
% h3.Normalization = 'probability';
% h4.Normalization = 'probability';

out.CloseE1 = bX;
title('E1 cells');

clear aT bT AB AB2 AB3 bX bXfk
[aT, bT] = sort(distVb(:),'ascend');
AB = timeVb(:);
AB2 = AB(bT);
AB3 = AB(randperm(size(AB,1)));


% group data every 100 um
grp = 1;
n = 1;
counter = 1;
for i = 1:size(AB2,1);

    if aT(i)>n+25;
    grp = grp+1;
    n=n+25;
    counter = 1;
    end
    bX{grp}(:,counter) = AB2(i);
    bXfk{grp}(:,counter) = AB3(i);
    counter = counter+1;
end



h2 = histogram(bX{1},5);
% h4 = histogram(bXfk{2});
% h3 = histogram(bX{1},5);
% h4 = histogram(bXfk{2},5);
h2.Normalization = 'probability';
out.CloseE2 = bX;