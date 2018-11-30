function CaBMI_cursorOccupancy(TData2, TData4)

warning off
figure(); 
h = size(TData2.cursorA(:),1);
% [values, centers] =hist3([TData.cursorA(1:h/4)' TData.cursorB(1:h/4)'],[100 100]);
% [values2, centers2] =hist3([TData.cursorA(3*(h/4):end)' TData.cursorB(3*(h/4):end)'],[100 100]);

[values, centers] =hist3([TData4.cursorA' TData4.cursorB'],[100 100]);
[values2, centers2] =hist3([TData2.cursorA((h/2):end)' TData2.cursorB((h/2):end)'],[100 100]);


imagesc(centers{2}([1 end]),centers{1}([1 end]),values);

ylim([-5 5]);
xlim([-5 5]);
colormap(gray);

hold off

IM1a = getframe(); % Get zoomed portion that is visible.
IM1 = double(squeeze(IM1a.cdata(:,:,1)));







figure(); 
imagesc(centers2{2}([1 end]),centers2{1}([1 end]),values2);

ylim([-5 5]);
xlim([-5 5]);
colormap(gray);

hold off

IM2a = getframe(); % Get zoomed portion that is visible.
IM2 = double(squeeze(IM2a.cdata(:,:,1)));

% Plot data
figure(); imagesc(IM1)
hy = size(IM1,1);
hx = size(IM1,2);
hold on;
plot(hx/2*ones(round(hx),1),1:round(hx),'k');
plot(1:round(hy),hy/2*ones(round(hy),1),'k');

figure(); imagesc(IM2)
hy = size(IM2,1);
hx = size(IM2,2);
hold on;
plot(hx/2*ones(round(hx),1),1:round(hx),'k');
plot(1:round(hy),hy/2*ones(round(hy),1),'k');

% subtract mid region 
midR = 200;
% Get bar plots
a = sum(sum(IM1(1:end/2-midR , 1:end/2-midR )));
b = sum(sum(IM1(1:end/2-midR , (end/2)+midR-1:end)));
c = sum(sum(IM1((end/2)+midR-1:end, 1:end/2-midR)));
d = sum(sum(IM1((end/2)+midR-1:end, (end/2)+midR-1:end)));
y1 = ([a b c d]);
y1 = y1/sum(y1);
figure(); bar(y1); title('early occupancy')

a = sum(sum(IM2(1:end/2-midR , 1:end/2-midR )));
b = sum(sum(IM2(1:end/2-midR , (end/2)+midR-1:end)));
c = sum(sum(IM2((end/2)+midR-1:end, 1:end/2-midR)));
d = sum(sum(IM2((end/2)+midR-1:end, (end/2)+midR-1:end)));
y2 = [a b c d];
y2 = y2/sum(y2);
figure(); bar(y2); title('late occupancy')





% build polor hist



X = (mat2gray(IM2)-mat2gray(IM1));

X=X-median(X(:));

figure(); imagesc(X,[-.5 .5]); colormap(fireice);

