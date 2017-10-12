function caBMI_refPlot(ROI,Im1)
% caBMI_refPlot.m

% Plot the ROIs, for reference

% d10.12.2017
% WAL3



  figure(); imagesc(ROI.reference_image); colormap(bone);
  color = hsv(size(ROI.coordinates,2));

  hold on;
  for i = 1:size(ROI.coordinates,2);
    plot(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2),'o','MarkerEdgeColor',color(i,:),'MarkerFaceColor',color(i,:));
  end



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
