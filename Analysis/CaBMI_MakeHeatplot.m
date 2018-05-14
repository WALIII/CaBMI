function CaBMI_MakeHeatplot(TData);

stdx = 1.0;


x = TData.cursorA;
y = TData.cursorB;


figure(); 
hold on;
colormap(hot)
plot(x,y,'o');
z = zeros(size(x));
col = 1:size(x,2);  % This is the color, vary with x in this case.
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2,'FaceAlpha',0.1,'EdgeAlpha',0.1);

ylim([-8 8]);
xlim([-8 8]);
plot(zeros(17,1),-8:8,'k');
plot(-8:8,zeros(17,1),'k');
plot(ones(17,1)*stdx,-8:8,'--b','LineWidth',2);
plot(-8:8,ones(17,1)*-stdx,'--b','LineWidth',2);

figure();
hold on;
p1 = plot(x,y);
z = zeros(size(x));
col = 1:size(x,2);  % This is the color, vary with x in this case.
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2,'FaceAlpha',0.1,'EdgeAlpha',0.1);


ylim([-8 8]);
xlim([-8 8]);
plot(zeros(17,1),-8:8,'k');
plot(-8:8,zeros(17,1),'k');
plot(ones(17,1)*stdx,-8:8,'--r','LineWidth',2);
plot(-8:8,ones(17,1)*-stdx,'--r','LineWidth',2);

figure();



b = size(x,2);
f = b/4;

% 
% for i = 1:3
%         subplot(1,3,i);
x = TData.cursorA(1:end);
y = TData.cursorB(1:end);

% x = x(f*i:f*(i+1));
% y = y(f*i:f*(i+1));

h=fspecial('gaussian',3,3);


[values, centers] = hist3([y(:) x(:)],[100 100]);
values2=imfilter(values,h,'circular','replicate');



imagesc(centers{2}([1 end]),centers{1}([1 end]),values2);
hold on

plot(zeros(11,1),-5:5,'k');
plot(-5:5,zeros(11,1),'k');

plot(ones(11,1)*stdx,-5:5,'--r','LineWidth',1.2);
plot(-5:5,ones(11,1)*-stdx,'--r','LineWidth',1.2);

ylim([-5 5]);
xlim([-5 5]);

hold off
% end



find hits




