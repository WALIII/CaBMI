function CaBMI_fast_and_slow(ROIhits, D_ROIhits_z,roi_hits);
% see if timing maters for the sequence 





% Calcultae the cursor
x = size(roi_hits,1)-1;
for i = 1:x;
cursor(:,i) = smooth((D_ROIhits_z(i,:,1)+D_ROIhits_z(i,:,2))-(D_ROIhits_z(i,:,3)+D_ROIhits_z(i,:,4)),2);
end

figure(); 
G = jet(x);
for i = 3:x
    hold on;
    plot(cursor(:,i)+i,'color',G(i,:))
end

figure();
imagesc(cursor',[-10 10]);
colormap(redblue);
colorbar();

figure();
for i = 1:4;
subplot(1,4,i);
imagesc(D_ROIhits_z(:,:,i),[-1 15]);
colormap(hot);
end

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


for i = 1: size(cursor,2);
    mg(i) = cursor(250,i)
end

[~,ff] = sort(mg);
figure(); imagesc(cursor(:,ff)',[-5,5]);
colormap(redblue);


fastest = 1:25;
slowest = size(ROIhits,1)-25:size(ROIhits);


data.undirected = ROIhits(ff(fastest),100:300,:); 
data.directed = ROIhits(ff(:),100:300,:); 
[indX,B,C] = CaBMI_schnitz(data);
Bx = squeeze(mean(ROIhits(:,100:300,:),1));
Bx = Bx(:,indX);



data.undirected = ROIhits(ff(slowest),100:300,:); 
[indX,B1,C1] = CaBMI_schnitz(data);

figure(); 
scl = 10;
subplot(1,2,1);
imagesc(B1-C1, [-scl scl]);
subplot(1,2,2);
imagesc(C-B, [-scl scl]);
colormap(fireice)


figure();
data1.directed(1,:,:) = (C-C1)';
data1.undirected(1,:,:) = (C-C1)';
CaBMI_schnitz(data1);

figure(); plot(mean(C-C1));