
function CaBMI_3D_plot(Cursor_hit);
smth = 4;

CA = squeeze(Cursor_hit(:,:,1))'; 
CB = squeeze(Cursor_hit(:,:,2))';

for i = 1:size(CA,2)
CB(:,i) = smooth(CB(:,i),smth);
CA(:,i) = smooth(CA(:,i),smth);
end

stdx = 1;
s = 52;
f = 53;

figure();

xlim([-8 8]);
ylim([-8 8]);
plot(zeros(21,1),-10:10,'k');
plot(-8:8,zeros(17,1),'k');
plot(ones(21,1)*stdx,-10:10,'--b','LineWidth',2);
plot(-8:8,ones(17,1)*-stdx,'--b','LineWidth',2);

xlim([-8 8]);
ylim([-8 8]);


set(gca,'nextplot','replacechildren','visible','off')
f = getframe;
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,99) = 0;


col = winter(size(CA,2));
for i = 1:99;
    s = i;
    f = s+2;
    hold on;
plot(zeros(17,1),-8:8,'k');
plot(-8:8,zeros(17,1),'k');
plot(ones(17,1)*stdx,-8:8,'--b','LineWidth',2);
plot(-8:8,ones(17,1)*-stdx,'--b','LineWidth',2);
plot(CA(s:f,:),CB(s:f,:)); 
for ii = 1: size(CA,2);
    plot(CA(f,ii),CB(f,ii),'Marker','*','Color',col(ii,:));
end
xlim([-8 8]);
ylim([-8 8]);

hold off
pause(0.01)
  f = getframe;
  im(:,:,1,i) = rgb2ind(f.cdata,map,'nodither');
pause(0.01)
 clf
end
imwrite(im,map,'DancingPeaks_1.gif','DelayTime',0,'LoopCount',inf) %g443800


