
function X = CaBMI_3D_compare(IM,IM2);


% Get the 'baseline' data by running CaBMI_plot_roi(ROI) ( Get ROI from the
% matlab file from the aquisition...

% Next, make a place-holder TData:

   % TData2.cursorA = (zscore(roi_ave2.interp_dff(1,:)) + zscore(roi_ave2.interp_dff(3,:)))  - (zscore(roi_ave2.interp_dff(3,:)) + zscore(roi_ave2.interp_dff(4,:)));
   % TData2.cursorB = (zscore(roi_ave2.interp_dff(5,:)) + zscore(roi_ave2.interp_dff(6,:)))  - (zscore(roi_ave2.interp_dff(7,:)) + zscore(roi_ave2.interp_dff(8,:)));


   % run both:

% [IM2]= CaBMI_MakeHeatplot(TData2);
% [IM]= CaBMI_MakeHeatplot(TData);


figure();
stdx = 1;
A = IM;
B = IM2;
normA = IM;
normB = IM2;
% normA = A - min(A(:));
% normA = normA ./ max(normA(:)); % *
% 
% normB = B - min(B(:));
% normB = normB ./ max(normB(:)); % *


uuA = -5:(10/(size(normA,1)-1)):5;
uuB = -5:(10/(size(normA,2)-1)):5;


imagesc(uuA,uuB,(normA)-(normB),[-1 1]);
colormap(fireice);
hold on

plot(zeros(11,1),-5:5,'w');
plot(-5:5,zeros(11,1),'w');

plot(ones(11,1)*stdx,-5:5,'--c','LineWidth',1.2);
plot(-5:5,ones(11,1)*-stdx,'--c','LineWidth',1.2);

colorbar

hold off;



figure();
X = (normA)-(normB);
hold on;
X(X<0) = 0;
% imagesc(indexa,indexa,zeros(100,100));
% hold on;
% imagesc(centers{2}([1 end]),centers{1}([1 end]),values2);
% hold on
% colormap(gray);

% filter out artifacts...
filt = 20;
h=fspecial('gaussian',filt,filt);
X=imfilter(X,h,'circular');



%imagesc(uuA,uuB,X,[0 8*std(X(:))]);
imagesc(uuA,uuB,X,[0 0.5]);
colormap(jet)
colorbar();
hold on
plot(zeros(11,1),-5:5,'w');
plot(-5:5,zeros(11,1),'w');
plot(ones(11,1)*stdx,-5:5,'--c','LineWidth',1.2);
plot(-5:5,ones(11,1)*-stdx,'--c','LineWidth',1.2);
ylim([-5 5]);
xlim([-5 5]);
