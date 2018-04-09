% Scrap Plot

function scrap_roi_plot_shaded(ROIhits);
 

for i = 1: size(ROIhits,3);
    [G3(i,:), loc(i,:)] = max(mean(squeeze(ROIhits(:,:,i))));
end
 
% [maxA, Ind] = max(G, [], 2);
[dummy, index] = sort(G3,'descend');
 
figure(); plot(ROIhits(:,:,(index(1)))');
 
figure(); 
hold on;

counter = 1;
shift = 0.25;
cells = 50;
col = lines(cells+1);
for i = 1:cells;
    adata = squeeze(ROIhits(:,:,index(i)));
    adata = zscore(adata')';

L = size(adata,2);
se = std(adata)./sqrt(length(adata));
mn = mean(adata)+counter*shift;
[a(:,i),b(:,i)] = max(mn); 
 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(0.5);
plot(mn,'Color',col(i,:));
counter = counter+1;
end

xG = index(1:cells);
[dummy, index2] = sort(b,'descend');
xG2 = xG(index2);




%% Plot sorted

figure();

% first 20
counter = 1;
for i = 1:cells
    hold on;
adata = (squeeze(ROIhits(:,:,xG2(i))));
   
L = size(adata,2);
se = std(adata)./sqrt(length(adata));
mn = mean(adata)-mean(mean(adata))+counter*shift;
if (max (mn(1,150:300)-min(mn(1,150:300)) ))<0.34
    continue
end
%     
 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(0.5);
plot(mn,'Color',col(i,:));
counter = counter+1;
    
   
end
plot([200 200],[0 counter*shift],'k--');

title('Sorted by time');




%% PLOT OVERLAY
shift = 0.95;

figure();

% first 20
counter = 1;
for i = 1:cells
    hold on;
adata = (squeeze(ROIhits(1:30,:,xG2(i))));
   
L = size(adata,2);
se = std(adata)./sqrt(length(adata));
mn = mean(adata)-mean(mean(adata))+counter*shift;
% if (max (mn(1,150:300)-min(mn(1,150:300)) ))<0.34
%     continue
% end
%     
 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],'r'); alpha(0.5);
plot(mn,'Color','r');
counter = counter+1;
    
   
end


% middle 20;
try
% first 20
counter = 1;
for i = 1:cells
    hold on;
adata = (squeeze(ROIhits(30:60,:,xG2(i))));
   
L = size(adata,2);
se = std(adata)./sqrt(length(adata));
mn = mean(adata)-mean(mean(adata))+counter*shift;
% if (max (mn(1,150:300)-min(mn(1,150:300)) ))<0.34
%     continue
% end
%     
 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],'g'); alpha(0.5);
plot(mn,'Color','g');
counter = counter+1;
    
   
end
title('sorted trials');



% last 20
counter = 1;
for i = 1:cells
    hold on;
adata = (squeeze(ROIhits(60:100,:,xG2(i))));


L = size(adata,2);
se = std(adata)./sqrt(length(adata));
mn = mean(adata)-mean(mean(adata))+counter*shift;
% if (max (mn(1,150:300)-min(mn(1,150:300)) ))<0.34
%     continue
% end
    
 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],'b'); alpha(0.5);
plot(mn,'Color','b');
counter = counter+1;
    
   
end
catch;
end
title('sorted trials');




Xc = mean(squeeze(ROIhits(:,:,xG2(:))),3);
X2c = mean(squeeze(ROIhits(:,:,:)),3);


figure();
subplot(141);
hold on;
plot((mean(Xc)-min(mean(Xc))),'b');
plot((mean(X2c)-min(mean(X2c))),'r');
plot([200 200],[0 max(mean(Xc)-min(mean(Xc))+0.01)],'k--');

legend('top 50','total');
xlabel('time (frames)');
title('Average activity of all ROIs across time ')
ylabel('dF/f');

subplot(142)
hold on; 
plot((mean(Xc,2)),'b*');
plot((mean(X2c,2)),'r*');
legend('top 50','total');
xlabel('Trials (Hits)');
ylabel('dF/f');
title('Average df/f of all ROIs, across trials (hits)');

subplot(143);
imagesc((Xc));
colormap(hot);
title('mean trial activity (top 50 ROIs)')
xlabel('time (frames)');
ylabel('Trials (Hits)');
colorbar;

subplot(144);
imagesc((X2c));
colormap(hot);
xlabel('time (frames)');
ylabel('Trials (Hits)');
title('total mean trial activity (all ROIs)')
colorbar;


