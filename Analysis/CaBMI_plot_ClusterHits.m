function CaBMI_plot_ClusterHits(T,newROI)


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
clear CC

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
 colormap(gray);
 pause();
 end