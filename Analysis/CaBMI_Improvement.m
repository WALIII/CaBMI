function [out] = CaBMI_Improvement(D_ROIhits,ROIhits_d,ROIhits_z,roi_hits)


% Calculate the within- day improvement of BMI performance...

% WAL3
% d101318


%% Figure 2
all_hits = 1:size(ROIhits_d,1); % all hits, save one at the end...
hit_range = 180:210; % Hit is centered at frame 200

% Direct Neurons
Gvar = mean(squeeze(var(squeeze(D_ROIhits(all_hits,180:210,1:2)),[],2)),2)...
- mean(squeeze(var(squeeze(D_ROIhits(all_hits,180:210,3:4)),[],2)),2);

Gmean = mean(squeeze(mean(squeeze(D_ROIhits(all_hits,190:210,1:2)),2)),2)...
-mean(squeeze(mean(squeeze(D_ROIhits(all_hits,190:210,3:4)),2)),2);

figure(); plot(Gvar,'*');
figure(); plot(Gmean,'*');

% Indirect Neurons
Pvar = var(squeeze(mean(squeeze(ROIhits_d(all_hits,170:210,:)),2)),[],2);
Pmean = mean(squeeze(mean(squeeze(ROIhits_z(all_hits,180:210,:)),2)),2);

% figure(); plot(Pvar,'*');
% figure(); plot(Pmean,'*');

% Build a linear fit:
n2 = mat2gray(roi_hits(all_hits ,:));
mdl = fitlm(n2,mat2gray(Pvar));
figure(); plot(mdl);
title('Variance across hits')

% Build a linear fit:
% n2 = mat2gray(roi_hits(all_hits ,:));
mdl = fitlm(n2,mat2gray(Pmean));
figure(); plot(mdl);
title('Mean across hits')

out.Pvar = Pvar;
out.Pmean = Pmean;
