
function CaBMI_Ind2Dir_covariance(roi_ave1,roi_ave2,roi_ave3,roi_ave4,ROIhits_s)



DN = 4;

% get the magnitude of ROI Modulation depth
out = CaBMI_incorperateROI(ROIhits_s);


% baseline:
for i = 1:size(roi_ave1.F_dff,1)
Base_corN(:,i) = corr(roi_ave3.interp_dff(i,:)',roi_ave4.interp_dff(DN,:)');
end


TM1 = round(1:size(roi_ave1.F_dff,2)/4);
TM2 = round(size(roi_ave1.F_dff,2)/2:size(roi_ave1.F_dff,2));


% durring experiment:
for i = 1:size(roi_ave1.F_dff,1)
corN_first(:,i) = corr(roi_ave1.F_dff(i,TM1)',roi_ave2.interp_dff(DN,TM1)');
corN_last(:,i) =  corr(roi_ave1.F_dff(i,TM2)',roi_ave2.interp_dff(DN,TM2)');
end

figure(); 
scatter(corN_first,corN_last)
title('Early to late');


figure(); % x axis first
hold on;
% scatter(Base_corN,corN_first,'r')
scatter(Base_corN,corN_last,'b')
title('Bseline to late');


figure();
hold on;
histogram(Base_corN,'BinWidth',.05,'FaceColor','r','normalization','probability');
histogram(corN_first,'BinWidth',.05,'FaceColor','g','normalization','probability');
histogram(corN_last,'BinWidth',.05,'FaceColor','b','normalization','probability');

figure(); % gain/loss
histogram(corN_last-Base_corN,'BinWidth',.05,'FaceColor','r','normalization','probability');

figure(); 
hold on;
scatter(nanmean(out.spikes(:,:),1),Base_corN,'b');
scatter(nanmean(out.spikes(:,:),1),corN_last,'r');
