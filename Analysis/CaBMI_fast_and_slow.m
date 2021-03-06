function [out] = CaBMI_fast_and_slow(ROIhits, D_ROIhits_z,roi_hits);
% see if timing maters for the sequence 





% Calcultae the cursor
x = size(roi_hits,1);
for i = 1:x;
    try
cursor(:,i) = smooth((D_ROIhits_z(i,:,1)+D_ROIhits_z(i,:,2))-(D_ROIhits_z(i,:,3)+D_ROIhits_z(i,:,4)),10);
    catch
        disp('one hit too close to the end. Skipping...');
    end
end

x = size(cursor,2);
figure(); 
G = jet(size(cursor,2));
for i = 3:x
    hold on;
    plot(cursor(:,i)+i,'color',G(i,:))
end

figure();
imagesc(cursor',[-10 10]);
colormap(redblue);
colorbar();

% Warp the cursor
X1 = zscore(mean(cursor,2));
figure(); 
hold on; 
plot(X1,'LineWidth',3);
plot(zscore(cursor)); 

figure(); 
figure();
imagesc((cursor)',[-3 3]);
colormap(redblue);
colorbar();



clear t x ti xi
clear c_warped
for i = 1:size(cursor,2);
clear iy ix one two ds onewarp twowarp

one = (zscore(cursor(:,i)));
   two = zscore(X1(:,:));
   [ds,ix,iy] = dtw(one,two,30);

   
onewarp(:,i) = one(ix);
twowarp(:,i) = two(iy);
m = cursor(ix,i);

t = linspace(1,size(cursor(ix,i),1),401); 
x = m(round(t)); 
ti = linspace(1,size(cursor(ix,i),1),401); 
xi = interp1(ti,x,t);

c_warped(:,i) = xi;

% warp Calcium data:


    temp = squeeze(ROIhits(i,ix,:));
    temp = temp(round(t),:);
    for ii = 1:size(ROIhits,3)
    ROIhits2(i,:,ii) = interp1(ti,temp(:,ii),t);
    end

    x = m(round(t));
    xi = interp1(ti,x,t);

end
figure(); 
subplot(1,2,1);
imagesc(c_warped')
subplot(1,2,2);
imagesc(cursor')


figure(); plot(c_warped(:,:));



   
figure();
for i = 1:4;
subplot(1,4,i);
imagesc(D_ROIhits_z(:,:,i),[-1 15]);
colormap(hot);
end


%[ROIhits_z ROIhits_z] = CaBMI_topCells(ROIhits_z,range,cutoff);


% figure(); 
% for i = 100:200;
% imagesc(ROIhits_z(:,:,i));
% pause(0.3);
% end

    
clear cl 
figure();
for i = 1:5;
c = smooth(diff(-smooth(cursor(:,i),1)),20);

[a,b] = findpeaks(c(1:200));
[a2,b2] = findpeaks(c(200:400));


[minValuse,closestIndex] = min(abs(200-a));
[minValuse2,closestIndex2] = min(abs(1-a2));

 plot(c); hold on; 
 plot(b(closestIndex),a(closestIndex),'*');
 plot(b2(closestIndex2)+200,a2(closestIndex2),'*');
 pause(0.1);
 ln2save(i) = (b(closestIndex)-(b2(closestIndex2)+200));
end

disp('smoothing cursor...');
for i = 1: size(cursor,2);
    cursor_smoothed = smooth(cursor(:,i),2);
    xtemp = find(cursor_smoothed(202:end)<0.7);
    try
    xtrue(i) = xtemp(1)+200; % when do we go back below baseline...
    catch
        xtrue(i) = 400;
    end
    clear xtemp
    mg(i) = mean(cursor_smoothed((210:240),:));
end




[~,ff] = sort(mg);
figure(); 
imagesc(cursor(:,ff)',[-5,5]);
hold on;
plot(xtrue(ff),1:size(cursor,2),'*')
colormap(redblue);
colorbar;

% Plot based on second thresh crossing:
[~,ff2] = sort(xtrue);
figure(); 
imagesc(cursor(:,ff2)',[-5,5]);
hold on;
plot(xtrue(ff2),1:size(cursor,2),'*')
colormap(redblue);
colorbar;
title('sorted by second threshold crossing');



out.sorted = ff;
out.sorted_reset = ff2;
out.xtrue = xtrue; % second thresh crossings
out.cursor = cursor;


% fastest = 1:25;
% slowest = size(ROIhits,1)-25:size(ROIhits)-1;


% data.undirected = ROIhits(ff(fastest),100:300,:); 
% data.directed = ROIhits(ff(:),100:300,:); 
% [indX,B,C] = CaBMI_schnitz(data);
% Bx = squeeze(mean(ROIhits(:,100:300,:),1));
% Bx = Bx(:,indX);

% figure();
% data1.undirected = ROIhits(1:2:60,100:300,:); 
% data1.directed = ROIhits(2:2:60,100:300,:); 
% [indX,B,C] = CaBMI_schnitz(data1);
% title('unwarped');
% data2.undirected = ROIhits2(1:2:60,100:300,:); 
% data2.directed = ROIhits2(2:2:60,100:300,:); 
% [indX,B,C] = CaBMI_schnitz(data1);
% title('warped');


% Bx = squeeze(mean(ROIhits(:,100:300,:),1));
% Bx = Bx(:,indX);

% 
% 
% data.undirected = ROIhits(ff(slowest),100:300,:); 
% [indX,B1,C1] = CaBMI_schnitz(data);
% 
% figure(); 
% scl = 10;
% subplot(1,2,1);
% imagesc(B1-C1, [-scl scl]);
% subplot(1,2,2);
% imagesc(C-B, [-scl scl]);
% colormap(fireice)
% 
% 
% figure();
% data1.directed(1,:,:) = (C-C1)';
% data1.undirected(1,:,:) = (C-C1)';
% CaBMI_schnitz(data1);
% 
% figure(); plot(mean(C-C1));
