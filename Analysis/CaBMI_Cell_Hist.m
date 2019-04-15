function CaBMI_Cell_Hist(out);









% % 
% % Bin E1 and E2
% % 
% % Get relative coordinates of all neurons 
% % counter = 1;
% % counter2 = 1;
% % for i = 1:4
% %     
% %     for ii = 1: size(ROIa.coordinates,2)
% %     if i ==1 || i ==2;
% %         
% %         E1_ind(counter,1) = mean(ROIa.coordinates{ii}(:,1))- mean(ROIb.coordinates{i}(:,1));
% %         E1_ind(counter,2) = mean(ROIa.coordinates{ii}(:,2))- mean(ROIb.coordinates{i}(:,2));
% %         counter = counter+1;
% %     else
% %          E2_ind(counter2,1) = mean(ROIa.coordinates{ii}(:,1))- mean(ROIb.coordinates{i}(:,1));
% %         E2_ind(counter2,2) = mean(ROIa.coordinates{ii}(:,2))- mean(ROIb.coordinates{i}(:,2));
% %         counter2 = counter2+1;
% %     end
% %     end
% % end
% % 
% % figure(); 
% % hold on;
% % plot(E1_ind(:,1),E1_ind(:,2),'ro');
% % plot(E2_ind(:,1),E2_ind(:,2),'o');
% % 
% % 
% % [a b]  = sort(out1.ROI_location_index);
% % 
% % d = randperm(1032);
% % delta_v = (out1.ROI_Timing_index(b));
% % delta_v = d;
% % delta_v = mat2gray(delta_v);
% % delta_v = round(delta_v*100);
% % cmap = jet(max(delta_v)+1);
% % 
% % 
% % figure(); 
% % hold on;
% % for i = 1:size(ROIa.coordinates,2)
% % col1 = cmap(delta_v(i)+1,:);
% % scatter(E1_ind(i,1),E1_ind(i,2),'o','Filled','SizeData',200,'MarkerFaceColor',col1,'MarkerEdgeColor',col1,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
% % 
% % end
axis off
axis tight

I = getframe(gcf);
[X,Map] = frame2im(I);

Iblur = imgaussfilt(X,10);
figure();

imshow((Iblur))
% %     