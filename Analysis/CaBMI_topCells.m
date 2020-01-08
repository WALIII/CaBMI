
function [ROIhits_z2 ROIhits_z3,ROI_index] = CaBMI_topCells(ROIhits_z,range,cutoff);
%function [roi_ave1,roi_ave3,ROIa,ROIhits,ROIhits_z] = CaBMI_topCells(roi_ave1,roi_ave3,ROIhits_z,ROIhits,ROIa,cutoff)


% Sort by the 'task re;evant cells- most active at the hit.)

plotHist =0; 


if plotHist ==1;
range = 190:250;
n2_range = 1:100;
n1_range = 350:400;
clear a b b2 a2
% trial_range
TR1 = 1:10;
TR2 = floor(size(ROIhits_z,1)/3):floor(size(ROIhits_z,1)/3)*2;
TR3 = floor(size(ROIhits_z,1)/3)*2:size(ROIhits_z,1);
% Early
 a = abs(max(mean(ROIhits_z(TR1,range,:),1)) - min(mean(ROIhits_z(TR1,range,:),1)));
 b = abs(max(mean(ROIhits_z(TR1,n1_range,:),1)) - min(mean(ROIhits_z(TR1,n1_range,:),1)));
% Mid
 a2 = abs(max(mean(ROIhits_z(TR2,range,:),1)) - min(mean(ROIhits_z(TR2,range,:),1)));
 b2 = abs(max(mean(ROIhits_z(TR2,n1_range,:),1)) - min(mean(ROIhits_z(TR2,n1_range,:),1)));
% Late
 a3 = abs(max(mean(ROIhits_z(TR3,range,:),1)) - min(mean(ROIhits_z(TR3,range,:),1)));
 b3 = abs(max(mean(ROIhits_z(TR3,n1_range,:),1)) - min(mean(ROIhits_z(TR3,n1_range,:),1)));
 
 figure();
 hold on;
 h1 = histogram(a./b,100);
 h2 = histogram(a2./b2,100);
 h3 = histogram(a3./b3,100);
h1.Normalization = 'probability';
h1.BinWidth = 0.1;
h1.FaceColor = 'r';

h2.Normalization = 'probability';
h2.BinWidth = 0.1;
h2.FaceColor = 'g';

h3.Normalization = 'probability';
h3.FaceColor = 'b';
h3.BinWidth = 0.1;

plot([1 1],[0 0.3],'--','LineWidth',1) 
title(' Modulation Ratio  (RGB = early, mid, late)');
end

plot([cutoff cutoff],[0 0.3],'--','LineWidth',4) 

% make the cutoff:
index = find(max(mean(ROIhits_z(:,150:250,:)))>=cutoff);

ROIhits_z2 = ROIhits_z(:,:,index);










% Based on best cells:
mid = round(size(ROIhits_z,2)/2);
bound = round(size(ROIhits_z,2)/4);
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit



data.directed = ROIhits_z(1:2:size(ROIhits_z,1),range_true,:);
data.undirected = ROIhits_z(2:2:size(ROIhits_z,1),range_true,:);
[indX,B,C,index] = CaBMI_schnitz(data);
title('true range');


for i = 1:size(B,1);
    cb(:,1) = (B(i,:))';
    cb(:,2) = (C(i,:))';
r = corr(cb);
rk(:,i) = r(1,2);
end
% fale alpha = ccd = ones(1,size(B1,2))'; % alpha valu
 ccd = mat2gray(rk);
 % ccd = (rk);

%[a,b] = max(B'); % this will be the max of the image matrix ( use b)

% ccd = 1-round(mat2gray(c),1);

ccd2 = ccd;
Bt = indX; % correct the index here...
B4 = indX; % correct the index here... use for refining thr schnitz
B4(ccd2<cutoff) = []; % Remove low values
data2.directed = ROIhits_z(1:2:size(ROIhits_z,1),range_true,B4);
data2.undirected = ROIhits_z(2:2:size(ROIhits_z,1),range_true,B4);
figure();
[indX,B,C,index] = CaBMI_schnitz(data2);

ROIhits_z3 = ROIhits_z(:,:,B4);
ROI_index = B4;
