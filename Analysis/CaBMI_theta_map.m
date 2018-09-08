
function CaBMI_theta_map(roi_ave, roi_ave2,ROIa, ROIb);


%plot a nice map of where the cells are, based on their theta value
try
for i = 1:size(roi_ave.F_dff,1)
N(:,i) = CaBMI2D_theta(roi_ave,roi_ave2,i);
end
catch
    roi_ave.F_dff = roi_ave.interp_dff
for i = 1:size(roi_ave.F_dff,1)
N(:,i) = CaBMI2D_theta(roi_ave,roi_ave2,i);
end
end
for i = 1:size(roi_ave.F_dff,1)
 s = smooth(N(:,i));
 [a b(:,i)] = max(s);
 c(:,i) =  a-min(s);
end



ccd = round(mat2gray(c),1);
col = hsv(15);
figure(); hold on;
% imagesc(flip(ROI_1.reference_image));
% colormap(gray);
hold on;

for i = 1:size(roi_ave.F_dff,1)
col1 = cat(2,col(b(i),:),ccd(i));
plot(ROIa.coordinates{i}(:,1),ROIa.coordinates{i}(:,2),'LineWidth',1,'Color',col1); 
end
colormap(hsv)
colorbar;


hold on;
for i = 1:8;
    plot(ROIb.coordinates{i}(:,1),ROIb.coordinates{i}(:,2),'LineWidth',1,'Color','k'); 
end

figure(); 

hold on;
col2 = {'g','g','r','r','c','c','b','b'}
for i = 1:8;
    plot(ROIb.coordinates{i}(:,1),ROIb.coordinates{i}(:,2),'LineWidth',1,'Color',col2{i}); 
end

xlim([0 500]);
ylim([0 500]);