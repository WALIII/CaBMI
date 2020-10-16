function CaBMI_DLC_Plot(X);

% Prototyping DLC output
% Currently loading in CSV to table, then converting the table to matrix..
% Example:
%    X = csvread('BMI_converted_longDLC_resnet50_WL_GPU_testSep29shuffle1_50000filtered.csv',3,0);

figure(); 

behIdx = [2 3 5 6 8 9 11 12 14 15 17 18 20 21 23 24];
col = jet(15);
hold on; 

% Plot a segment of the data:

for i = 1: 1000;
    xlim([ 0 300]);
    ylim([ -300 0]);

    hold on; 
dY = 5;

for ii = 1:2:size(behIdx,2)-1;
plot(X(1+i:dY+i,behIdx(ii)),-X(1+i:dY+i,behIdx(ii+1)),'color',col(ii,:));
plot(X(dY+i,behIdx(ii)),-X(dY+i,behIdx(ii+1)),'o','color',col(ii,:),'MarkerSize',10);
end

pause(0.01);
clf
end



% Seperate Rest/ BMI times, plot mean X/Y variance
et = 39000;
figure();
plot(1:et-2,smooth(zscore(abs(mean(diff(X(1:et,behIdx),2),2)))));

et = size(X,1);
figure();
plot(1:et-2,smooth(zscore(abs(mean(diff(X(1:et,behIdx),2),2)))));

figure();
Dat2 = smooth(zscore(abs(mean(diff(X(1:et,behIdx),2),2))));
AA = Dat2(13000:23000,:);
AB = Dat2(25000:35000,:);
hold on;
histogram((AA),'BinWidth',0.3,'FaceColor','b','Normalization','probability');
histogram((AB),'BinWidth',0.3,'FaceColor','r','Normalization','probability');

% Plot before/after reward:

% 1. get reward frames from 

