function [T, ydat, AA, newROI] = CaBMI_ClusterHits(ROIhits)

% CaBMI_ClusterHits.m

% Cluster all ROIs on all trials by correlated time series using t-sne
% INPUT: 3D matrix  (trials x time x ROIs)

% WAL3
% d07/18/18


%% combine to run tsne on all data...
rnavg = 1;

[trials timestamps cells] = size(ROIhits);

c = 1:rnavg:trials;


%% concatnate cells from all averaged trials
for i = 1:length(c)-1
    
    CC1 = smoothdata(ROIhits(i,:,:),2,'gaussian',15);
%     CC1 = CC1-min(CC1);
    CC2 = squeeze(mean(CC1,1));
    if i ==1;
      newROI =  CC2;
    else
B = CC2;
newROI = cat(2,newROI,B);
    end
end


%% run T-SNE 
C2 =  newROI(100:300,:)';
ydat = tsne(C2);


%% unpack cells
for i = 1:length(c)-1
AA(:,:,i) =  ydat(1+(cells*(i-1)):cells*i,:);
end



%% Basic Plotting:
G = colormap(jet(length(c)));
figure();
% for cell = 1:200;
 hold on;
for i = 1:length(c)-1
    
plot(AA(:,1,i),AA(:,2,i),'o','color',(G(i,:)),'MarkerSize',2);

pause(.1)
end% end


%% Extract clusteres from the t-sne plot

%T = clusterdata(ydat(1:20000,:),'Maxclust',20); 
T = clusterdata(ydat(1:20000,:),'Linkage','ward','Maxclust',50 );
colormap(jet(max(T)));

figure(); 
scatter(ydat(1:20000,1),ydat(1:20000,2),10,T);



CaBMI_plot_ClusterHits(T,newROI)


