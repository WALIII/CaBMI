function [ROI] = CaBMI_ROI_freehand(im)
% Draw freehand ROIs, for dendrites

% WAL3
% d11.29.17


% Take 4 Regions of Interest
cla('reset');
cells = 8;

disp('Make a selection...')

for i = 1:cells;
    if i == 1;
h_im = imshow(im);
title('Choose ROI from the figure');
    else
h_im = imshow(im);
hold on;
title('Choose ROI from the figure');
for ii = 1:i-1
plot(ROI.coordinates{ii}(:,1),ROI.coordinates{ii}(:,2),'*');
end
    end

%helpdlg('Choose ROI from the figure','Point Selection');

hx = imfreehand;
pause(0.1);


% Get coordinates
binaryImage = hx.createMask();
[y x]=find(binaryImage);
ROI.coordinates{1,i}(:,1) = x;
ROI.coordinates{1,i}(:,2) = y;

ROI.stats(i).centroid = mean(ROI.coordinates{1,i});
ROI.BinaryMask(:,:,i) = binaryImage;
cla('reset');



end

% Show the final product:
  h_im = imshow(im);
hold on;
title('Choose ROI from the figure');
for ii = 1:i
plot(ROI.coordinates{ii}(:,1),ROI.coordinates{ii}(:,2),'*');
end

ROI.type = 'image';
ROI.reference_image = im;


%% Save data...
save_dir='image_roi';
mkdir(save_dir);
save(fullfile(save_dir,'Freehand_ROI.mat'),'ROI');
