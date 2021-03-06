function [out] = CaBMI_Compare_SPT(ROIhits,ROIa,ROIb)

% CaBMI Comapre the evolution of Spatiotemporal Dynamics over a session

% For one day:

% Split data into thirds
num_bins = 3;
Hitrange = 1:(round(size(ROIhits,1)/num_bins)):size(ROIhits,1);



[out_early] = CaBMI_Spatiotemporal(ROIhits(Hitrange(1):Hitrange(2),:,:), ROIa,ROIb,'figures',1);
[out_mid] = CaBMI_Spatiotemporal(ROIhits(Hitrange(2):Hitrange(3),:,:), ROIa,ROIb,'figures',1);
[out_late] = CaBMI_Spatiotemporal(ROIhits(Hitrange(3):Hitrange(4),:,:), ROIa,ROIb,'figures',1);


% Increase in population consistancy:
figure();
 hold on; 
h1 = histogram(out_early.ROI_ConsistancyScore,30,'FaceColor','r','FaceAlpha',0.5); 
h2 = histogram(out_mid.ROI_ConsistancyScore,30,'FaceColor','g','FaceAlpha',0.5);
h3 = histogram(out_late.ROI_ConsistancyScore,30,'FaceColor','b','FaceAlpha',0.5);

h1.Normalization = 'probability';
h2.Normalization = 'probability';
h3.Normalization = 'probability';

title('Population consistancy early (blue) and later (red)');




out = out_early;

stp = 5;
for i = 1:size(out.SpaceTime,2);
    Bxv(:,i) = mean(out_early.SpaceTime{i});
    err(:,i) = std(out_early.SpaceTime{i})/sqrt(length(out.SpaceTime{i}));  
    Bxvfk(:,i) = mean(out_early.SpaceTime2{i});
    errfk(:,i) = std(out_early.SpaceTime2{i})/sqrt(length(out.SpaceTime2{i})); 
end

figure();
hold on;
errorbar((1:length(Bxv))*stp,Bxv,err,'r')
errorbar((1:length(Bxv))*stp,Bxvfk,errfk,'r')

for i = 1:size(out.SpaceTime,2);
    Bxv(:,i) = mean(out_late.SpaceTime{i});
    err(:,i) = std(out_late.SpaceTime{i})/sqrt(length(out.SpaceTime{i}));  
    Bxvfk(:,i) = mean(out_late.SpaceTime2{i});
    errfk(:,i) = std(out_late.SpaceTime2{i})/sqrt(length(out.SpaceTime2{i}));
end

errorbar((1:length(Bxv))*stp,Bxv,err,'b')
errorbar((1:length(Bxv))*stp,Bxvfk,errfk,'b')


% Plot ROI difference:

% 
% figure(); 
% hold on;
% [a b]  = sort(out1.ROI_location_index);
% [a2 b2]  = sort(out2.ROI_location_index);
% 
% d = randperm(1032);
% delta_v = (out1.ROI_Timing_index(b));
% %delta_v = d;
% delta_v = mat2gray(delta_v);
% delta_v = round(delta_v*100);
% cmap = jet(max(delta_v)+1);
% 
% for i = 1:size(b,2)
% %col1 = cat(2,col(b(i),:),ccd(i));
% delta_v
% col1 = cmap(delta_v(i)+1,:);
% plot(ROIa.coordinates{(i)}(:,1),ROIa.coordinates{(i)}(:,2),'LineWidth',1,'Color',col1);
% hold on;
% end
% colormap(redblue)
% xlim([0 500]);
% ylim([0 500]);
% colorbar;





% plot comparioson 

% First, look at E1:
clear delta_v delta_v2

E1_dist = out_early.E1_dist;
E2_dist = out_early.E2_dist;
  
% bring back to the original index...
[~, rest1] = sort(out_early.E1E2_roi_index);
rest1 = cat(2,rest1,rest1); % index is doubles... ( for e1 and e2, they are concatenatd 
% apply the second index so everything is aligned..
[~,rest2] = sort(out_late.E1E2_roi_index);
rest2 = cat(2,rest2,rest2);


% Just plot those cells...
ROI = ROIa;
delta_v = out_early.E1_T(1,rest1);
delta_v2 = out_late.E1_T(1,rest2);
delta_v = abs(delta_v);
cmap = jet(round(max(delta_v))+1);


figure(); 
hold on;
for i = 1:size(ROIa.coordinates,2)*2
col1 = cmap(round(delta_v(i))+1,:);
scatter(E1_dist(rest1(i),1),E1_dist(rest1(i),2),'o','Filled','SizeData',200,'MarkerFaceColor',col1,'MarkerEdgeColor',col1,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
end
title('E1 cells vs surrounding IND neuron timing tuning');

% E2 cells...
delta_v = out_early.E2_T(1,rest1);
delta_v2 = out_late.E2_T(1,rest2);
delta_v = delta_v2;
delta_v = abs(delta_v);
cmap = jet(round(max(delta_v))+1);
 
figure(); 
hold on;
for i = 1:size(ROIa.coordinates,2)*2
col1 = cmap(round(delta_v(i))+1,:);
scatter(E2_dist(i,1),E2_dist(i,2),'o','Filled','SizeData',200,'MarkerFaceColor',col1,'MarkerEdgeColor',col1,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
end
title('E2 cells vs surrounding IND neuron timing tuning');


out = [];

