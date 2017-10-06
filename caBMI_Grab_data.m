function caBMI_Grab_data()
% grab pixel values and do perform basic operations on them


pl = actxserver('PrairieLink.Application');
pl.connect();



%%%============[ Collect Baseline Data  ]================%%%


% Initialize
clear Im1
Im1(:,:,1) = pl.GetImage(1);
counter = 2;

for i = 1:100;
Im = pl.GetImage(1);
if Im1(:,:,counter-1) == Im;
pause(0.01) % This will approximately itteratively sync
else
  Im1(:,:,counter) = Im;
  counter = counter+1;
  pause(0.02) % should be a bit less than the frame rate
end
end


%%--- Get ROIs-----%
% Save reference image
imwrite(uint16(mean(Im1,3)),'Ref_Im.tif');
[ROI] = caBMI_annotate_image('Ref_Im.tif');

% make a figure qith the ROIs
figure(); imagesc(ROI.reference_image); colormap(bone);
color = hsv(size(ROI.coordinates,2));

hold on;
for i = 1:size(ROI.coordinates,2);
  plot(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2),'o','MarkerEdgeColor',color(i,:),'MarkerFaceColor',color(i,:));
end
% legend('cell01, cell02, cell02, cell04')

% Plot from coords.
figure();
hold on;
for i = 1:size(ROI.coordinates,2);
trace = mean(squeeze(mean(Im1(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2),:),1)),1); % average pixels in mask
trace = (trace-prctile(trace,5))./prctile(trace,5)*100;
plot(trace,'Color',color(i,:));
clear trace;
end
title('ROI Baseline activity')
xlabel('frames')
ylabel('df/f')
% legend('ROI_01, ROI_02, ROI_03, ROI_04')




figure();
imagesc(std(Im1,[],3)); colormap(bone);
colorbar




% to do: function that computes running baseline and
[baseline] caBMI_GetBase(rois)





%% This will be for the actual BMI
kk = pl.ReadRawDataStream(1);

% for i = 1:100000
% tic;

% H(i) = toc;
% end




% Read the raw data stream
% ReadRawDataStream()
