function [out] = CaBMI_TaskRelevantIncrease(ROIhits);

% Look at the increase in Task relevant Indirect neurons over time
% that are consistantly modulated ( split in 2, look at pairwise corr)

% percent to use:
p2Use = .30; % percent of hits to consider 
thresh2use = 0.8; %similarity needed to be considered task relevant

% total hits
tH = size(ROIhits,1);

% index
idx1 = 1:round(p2Use*tH);
idx2 = tH-max(idx1):tH;
%

[~,~,~, percent_modulated_early] = CaBMI_topCells(ROIhits(idx1,:,:),150:250,thresh2use);
[~,~,~, percent_modulated_late] = CaBMI_topCells(ROIhits(idx2,:,:),150:250,thresh2use);

out = cat(1,percent_modulated_early,percent_modulated_late);
figure(); 
plot(out);