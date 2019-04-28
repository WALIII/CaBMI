
function CaBMI_TaskLocation(VidHits,ROIa,Cell_ID);

% look for the spatial mask of cells that are being modulated:


figure();


MeanVid1 = mean(VidHits(:,:,:,:),4); MeanVid1 = std(MeanVid1,[],3);
MeanVid2 = mean(VidHits(:,:,:,(end-20):end),4); MeanVid2 = std(MeanVid2,[],3);


figure(); 
hold on;
imagesc(mat2gray(MeanVid1));
plot( ROIa.coordinates{Cell_ID}(:,1),ROIa.coordinates{Cell_ID}(:,2),'r');
hold off;


imagesc(mat2gray(MeanVid2));


figure(); 
colormap(redblue)
hold on
imagesc(mat2gray(MeanVid1)-mat2gray(MeanVid2), [-0.6 0.6]);
plot( ROIa.coordinates{Cell_ID}(:,2),ROIa.coordinates{Cell_ID}(:,1),'g');
hold off;
colorbar(); 


RGB1 = CaBMI_XMASS(MeanVid2,MeanVid1,MeanVid2);
figure(); imagesc((MeanVid1));
hold on; 
for i = 1:500
plot( ROIa.coordinates{i}(:,1),ROIa.coordinates{i}(:,2),'r');
end

