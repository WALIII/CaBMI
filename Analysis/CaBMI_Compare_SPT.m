

% CaBMI Comapre the evolution of Spatiotemporal Dynamics over a session

% For one day:


[out1] = CaBMI_Spatiotemporal(ROIhits(1:10,:,:), ROIa,ROIb);
[out2] = CaBMI_Spatiotemporal(ROIhits(round(size(ROIhits,1)/2)-40:end,:,:), ROIa,ROIb);
%[out1] = CaBMI_Spatiotemporal(ROIhits(1:round(size(ROIhits,1)/2)-1,:,:), ROIa,ROIb);
%[out2] = CaBMI_Spatiotemporal(ROIhits(round(size(ROIhits,1)/2)-1:end,:,:), ROIa,ROIb);


% Increase in population consistancy:
figure();
 hold on; 
h1 = histogram(out1.ROI_ConsistancyScore,30,'FaceColor','b','FaceAlpha',0.5); 
h2 = histogram(out2.ROI_ConsistancyScore,30,'FaceColor','r','FaceAlpha',0.5);
h1.Normalization = 'probability';
h2.Normalization = 'probability';

title('Population consistancy early (blue) and later (red)');




out = out1;

stp = 5;
for i = 1:size(out.SpaceTime,2);
    Bxv(:,i) = mean(out.SpaceTime{i});
    err(:,i) = std(out.SpaceTime{i})/sqrt(length(out.SpaceTime{i}));
    
    Bxvfk(:,i) = mean(out.SpaceTime2{i});
    errfk(:,i) = std(out.SpaceTime2{i})/sqrt(length(out.SpaceTime2{i})); 
end


figure();
hold on;
errorbar((1:length(Bxv))*stp,Bxv,err)
errorbar((1:length(Bxv))*stp,Bxvfk,errfk)

out = out2;
for i = 1:size(out.SpaceTime,2);
    Bxv(:,i) = mean(out.SpaceTime{i});
    err(:,i) = std(out.SpaceTime{i})/sqrt(length(out.SpaceTime{i}));;
    
    Bxvfk(:,i) = mean(out.SpaceTime2{i});
    errfk(:,i) = std(out.SpaceTime2{i})/sqrt(length(out.SpaceTime2{i}));;  
end

errorbar((1:length(Bxv))*stp,Bxv,err)
errorbar((1:length(Bxv))*stp,Bxvfk,errfk)


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

E1_dist = out1.E1_dist;
E2_dist = out1.E2_dist;
  
% bring back to the original index...
[~, rest1] = sort(out1.E1E2_roi_index);
rest1 = cat(2,rest1,rest1); % index is doubles... ( for e1 and e2, they are concatenatd 
% apply the second index so everything is aligned..
[~,rest2] = sort(out2.E1E2_roi_index);
rest2 = cat(2,rest2,rest2);


% Just plot thos cells...
ROI = ROIa;
delta_v = out1.E1_T(1,rest1);
delta_v2 = out2.E1_T(1,rest2);
delta_v = abs(delta_v);
cmap = hot(round(max(delta_v))+1);


figure(); 
hold on;
for i = 1:size(ROIa.coordinates,2)*2
col1 = cmap(round(delta_v(i))+1,:);
scatter(E1_dist(rest1(i),1),E1_dist(rest1(i),2),'o','Filled','SizeData',200,'MarkerFaceColor',col1,'MarkerEdgeColor',col1,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
end
title('E1 cells vs surrounding IND neuron timing tuning');

% E2 cells...
delta_v = out1.E2_T(1,rest1);
delta_v2 = out2.E2_T(1,rest2);
delta_v = delta_v-delta_v2;
delta_v = abs(delta_v);
cmap = hot(round(max(delta_v))+1);
 
figure(); 
hold on;
for i = 1:size(ROIa.coordinates,2)*2
col1 = cmap(round(delta_v(i))+1,:);
scatter(E2_dist(i,1),E2_dist(i,2),'o','Filled','SizeData',200,'MarkerFaceColor',col1,'MarkerEdgeColor',col1,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
end
title('E2 cells vs surrounding IND neuron timing tuning');



