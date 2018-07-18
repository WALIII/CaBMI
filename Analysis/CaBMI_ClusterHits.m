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
T = clusterdata(ydat(1:20000,:),'Linkage','ward','Maxclust',50);
colormap(jet(max(T)));

figure(); 
scatter(ydat(1:20000,1),ydat(1:20000,2),10,T);


%% Plot clustered Hits:
counter = 1; 

figure();
for ii = 1:max(T);
    XX =  find(T == ii);
    counter = 1;
for i = 1:length(XX)
    dataM{ii}(:,counter) = newROI(:,XX(i));
    counter = counter+1;
end
end


figure();
hold on;
shift = 1;
col = jet(size(dataM,2));

for i = 1:size(dataM,2);
    data = zscore(squeeze(dataM{i}(:,:)))';
        L = size(data,2);
        se = std(data)/sqrt(length(data));
        mn = mean(data)+ i*.2;
    CCC(:,i) = mean(data);
    h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(0.5);
        plot(mn,'Color',col(i,:));
end


% Sort Data
CCC = CCC';
[maxA, Ind] = max(CCC, [], 2);
[dummy, index] = sort(Ind); % durring
B  = (CCC(index, :));
figure(); imagesc(B);
clear CCC

figure();
hold on;
for i = 1:size(dataM,2);
    data = zscore(squeeze(dataM{index(i)}(:,:)))';
    
L = size(data,2);
se = std(data)/sqrt(length(data));
mn = mean(data)- i*.4;
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(0.5);
plot(mn,'Color',col(i,:));

    
end

 plot(200*ones(22,1),-20:1,'--w');
 
 figure();
 for i = 1:size(dataM,2);
 data = zscore(squeeze(dataM{index(i)}(:,:)))';
 imagesc(data);
 pause(0.2);
 end

