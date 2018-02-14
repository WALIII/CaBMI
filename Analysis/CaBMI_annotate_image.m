function ROI = CaBMI_annotate_image(ROI1)
% Annotate image using E1 and E2 as the first 4 ROIs



colormap(bone);

for i = 1:3
IM(:,:,i) = ROI1.reference_image;
end

G = [1 1 3 3];
hold on;

for i = 1:4;
IM(ROI1.coordinates{i}(:,2),ROI1.coordinates{i}(:,1),G(i)) = 0;
end

imwrite(IM,'ROI_Figure.tif','TIF')


% Write E1 and E2 as the first 4 ROIs
for i = 1:4
annotations(i,:) = [min(ROI1.coordinates{i}(:,1)),min(ROI1.coordinates{i}(:,2)),max(ROI1.coordinates{i}(:,1))-min(ROI1.coordinates{i}(:,1)),max(ROI1.coordinates{i}(:,2))-min(ROI1.coordinates{i}(:,2))];
end

if exist('ROI_Figure.mat','file') ==2

else
file = [cd,'/ROI_Figure'];
width = 512;
height = 512;
name = 'ROI_Figure';

save('ROI_Figure.mat', 'annotations','file','width','height','name');

end
im = 'ROI_Figure.tif';
an = Annotator(im);
an.wait();
masks = an.getMasks();




for i = 1: size(masks,3)

    [col,row] = find(masks(:,:,i)== 1);

    ROI.coordinates{1,i} = [row col];
	ROI.stats(i).Centroid=mean(ROI.coordinates{i});
	ROI.stats(i).Diameter=max(pdist(ROI.coordinates{i},'euclidean'));
	k=convhull(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2));
	ROI.stats(i).ConvexHull=ROI.coordinates{i}(k,:);

end

ROI.type = 'Image';
im2 = imread(im);
ROI.reference_image = im2;
b = im(1:end-4);
b = strcat(b,'_ROI_DATA.mat');
save(b,'ROI')
end
