function ROI_final = CaBMI_MergeROIs(ROI)
% CaBMI_MergeROIs

% Merge Cursor ROIs with manually selected ROIs

% TO DO: incorperate the voltage traces from the .csv

% WAL3
% d01272018

colormap(bone);

for i = 1:3
IM(:,:,i) = ROI.reference_image;
end

G = [1 1 3 3];
hold on;

for i = 1:4;
IM(ROI.coordinates{i}(:,2),ROI.coordinates{i}(:,1),G(i)) = 0;
end







% set(gca,'XTick',[]) % Remove the ticks in the x axis!
% set(gca,'YTick',[]) % Remove the ticks in the y axis
% set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
% print('ROI_Figure','-dtiff')
% % F = getframe(gcf);
% % [X, Map] = frame2im(F);

imwrite(IM,'ROI_Figure.tif','TIF')

% annotator here...
disp(' red/blue cells are ROIs from the experiment...')

ROI2 = FS_annotate_image('ROI_Figure.tif');

prompt = 'Finished? Y/N [Y]: ';
str = input(prompt,'s');
if isempty(str)
    str = 'Y';
end

ROI2 = FS_annotate_image('ROI_Figure.tif');



disp('Merging ROIs...')
ROI_final.coordinates = [ROI.coordinates, ROI2.coordinates];
ROI_final.stats.Centroid = [ROI.stats.centroid, ROI2.stats.Centroid];
ROI_final.Ref_image_1 = ROI.reference_image;
