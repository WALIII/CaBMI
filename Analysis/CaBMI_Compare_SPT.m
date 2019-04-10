

% CaBMI Comapre the evolution of Spatiotemporal Dynamics over a session

% For one day:


[out1] = CaBMI_Spatiotemporal(ROIhits(1:round(size(ROIhits,1)/2)-1,:,:), ROIa,ROIb);
[out2] = CaBMI_Spatiotemporal(ROIhits(round(size(ROIhits,1)/2)-1:end,:,:), ROIa,ROIb);


% Increase in population consistancy:
figure(); hold on; histogram(out1.ROI_ConsistancyScore,30); histogram(out2.ROI_ConsistancyScore,30,'FaceColor','r');
title('Population consistancy early (blue) and later (red)');




out = out1;

stp = 5;
for i = 1:size(out.SpaceTime,2);
    Bxv(:,i) = mean(out.SpaceTime{i});
    err(:,i) = std(out.SpaceTime{i})/sqrt(length(out.SpaceTime{i}));;
    
    Bxvfk(:,i) = mean(out.SpaceTime2{i});
    errfk(:,i) = std(out.SpaceTime2{i})/sqrt(length(out.SpaceTime2{i}));;  
end


figure();
hold on;
errorbar((1:length(Bxv))*stp,Bxv,err)
errorbar((1:length(Bxv))*stp,Bxvfk,errfk)
out = out2
for i = 1:size(out.SpaceTime,2);
    Bxv(:,i) = mean(out.SpaceTime{i});
    err(:,i) = std(out.SpaceTime{i})/sqrt(length(out.SpaceTime{i}));;
    
    Bxvfk(:,i) = mean(out.SpaceTime2{i});
    errfk(:,i) = std(out.SpaceTime2{i})/sqrt(length(out.SpaceTime2{i}));;  
end

errorbar((1:length(Bxv))*stp,Bxv,err)
errorbar((1:length(Bxv))*stp,Bxvfk,errfk)


% Plot ROI difference:


figure(); 
hold on;
[a b]  = sort(out1.ROI_location_index);
[a2 b2]  = sort(out2.ROI_location_index);
cmap = redblue(101);
delta_v = (out1.ROI_Timing_index(b)-out2.ROI_Timing_index(b2));
delta_v = mat2gray(delta_v);

for i = 1:size(b,2)
%col1 = cat(2,col(b(i),:),ccd(i));
col1 = cmap((round(delta_v(i)*100)) +1,:);
plot(ROIa.coordinates{(i)}(:,1),ROIa.coordinates{(i)}(:,2),'LineWidth',1,'Color',col1);
hold on;
end
colormap(redblue)
xlim([0 500]);
ylim([0 500]);
colorbar;