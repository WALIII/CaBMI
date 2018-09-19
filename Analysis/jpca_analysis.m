% JJPCA formatting


% The input 'Data' needs to be a struct, with one entry per condition.
% For a given condition, Data(c).A should hold the data (e.g. firing rates).
% Each column of A corresponds to a neuron, and each row to a timepoint.


clear all

% load data
load('csv_data.mat'); load('ave_roi.mat'); 


% Extract Hits;

 %   1. Extract 'Hits' from .CSV file
[ds_hits, roi_hits] = CaBMI_csvAlign(csv_data(:,2),csv_data(:,3),roi_ave); %   1. Load in Y ( temporally downsampled movie) from ds_data



%% BASIC ANALYSIS
 % Get video matrix around the hits

 % Get ROI traces in a matrix, bounded by the hits
 [ROIhits, ROIhits_d, ROIhits_s]= CaBMI_getROI(roi_ave,roi_hits);
% run Jpca

Data.A = roi_ave.F_dff';
[Projection, Summary] = jPCA(Data);





jG = zscore(Projection.proj');
for i = 1:size(roi_hits)
try
jPCA_hits(i,:,:) = (jG(:,roi_hits(i)-200:roi_hits(i)+200))';
catch
disp(' one hit is too close to the end...');
end
end

%% Ploting function 
close all

a = 1;
b = 2;
c = 3;

figure(a);
hold on;
figure(b);
 hold on;
 figure(c);
 hold on; 
fig1=figure(1); fig1.Renderer='Painters';
fig2=figure(2); fig2.Renderer='Painters';
fig3=figure(3); fig3.Renderer='Painters';
fig4=figure(4); fig4.Renderer='Painters';
smth = 5; % smooth in time
PC1 = 1; 
PC2 = 2;
PC3 = 3;
PC4 = 4; 
PC5 = 5;
PC6 = 6;
fr = 10; % smooth across trials
counter = 1;
cmap = jet(31);
for i = 55:1:85;
A1 = mean(smoothdata(jPCA_hits(i:i+fr,:,PC1)','gaussian',smth),2);
B1 = mean(smoothdata(jPCA_hits(i:i+fr,:,PC2)','gaussian',smth),2);
C1 = mean(smoothdata(jPCA_hits(i:i+fr,:,PC3)','gaussian',smth),2);
D1 = mean(smoothdata(jPCA_hits(i:i+fr,:,PC4)','gaussian',smth),2);
E1 = mean(smoothdata(jPCA_hits(i:i+fr,:,PC5)','gaussian',smth),2);
F1 = mean(smoothdata(jPCA_hits(i:i+fr,:,PC6)','gaussian',smth),2);
figure(a)
%plot(zscore(A1)+0,'r'); plot(zscore(B1)+5,'b'); plot(zscore(C1)+10,'g');
plot(A1-mean(A1),'r'); plot((B1)-mean(B1),'b'); plot((C1)-mean(C1),'g');
title('jPC1-3')
figure(b);
plot(D1-mean(D1),'r'); plot((E1)-mean(E1),'b'); plot((F1)-mean(F1),'g');
title('jPC4-6')
AA(:,:,counter) = A1-mean(A1);
BA(:,:,counter) = B1-mean(B1);
CA(:,:,counter) = C1-mean(C1);

figure(3)
hold on;
subplot(3,1,1);
hold on;
plot((A1)-mean(A1),'color',cmap(counter,:))
subplot(3,1,2);
hold on;
plot((B1)-mean(B1),'color',cmap(counter,:))
subplot(3,1,3);
hold on;
plot((C1)-mean(C1),'color',cmap(counter,:))


figure(4)
hold on;
subplot(3,1,1);
hold on;
plot((D1)-mean(D1),'color',cmap(counter,:))
subplot(3,1,2);
hold on;
plot((E1)-mean(E1),'color',cmap(counter,:))
subplot(3,1,3);
hold on;
plot((F1)-mean(F1),'color',cmap(counter,:))

counter = counter+1;
end


scrap_roi_plot_shaded(ROIhits);


