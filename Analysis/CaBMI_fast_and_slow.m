function CaBMI_fast_and_slow(ROIhits_z,ROIhits, D_ROIhits_z,roi_hits);
% see if timing maters for the sequence 





% Calcultae the cursor
x = size(roi_hits,1)-1;
for i = 1:x;
cursor(:,i) = smooth((D_ROIhits_z(i,:,1)+D_ROIhits_z(i,:,2))-(D_ROIhits_z(i,:,3)+D_ROIhits_z(i,:,4)),3);
end

figure(); 
G = jet(x);
for i = 3:x
    hold on;
    plot(cursor(:,i)+i,'color',G(i,:))
end

figure();
imagesc(cursor',[-15 15]);
colormap(fireice);
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
    mg(i) = cursor(180,i)
end

[~,ff] = sort(mg);
figure(); imagesc(cursor(:,ff)',[-15,15]);
colormap(fireice);


fastest = 1:20;
slowest = size(ROIhits,1)-20:size(ROIhits);


data.directed = ROIhits(ff(fastest),100:300,:); 
data.undirected = ROIhits(ff(:),100:300,:); 
[indX,B,C] = CaBMI_schnitz(data);
Bx = squeeze(mean(ROIhits(:,100:300,:),1));
Bx = Bx(:,indX);

figure(); 
imagesc(B-Bx',[-4 4]);
colormap(fireice);

data.directed = ROIhits(ff(slowest),100:300,:); 
[indX,B1,C1] = CaBMI_schnitz(data);

figure(); 
subplot(1,2,1);
imagesc(C-C1,[-4 4]);
subplot(1,2,2);

