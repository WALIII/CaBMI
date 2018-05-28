function [PCA_hits]= CaBMI_PCA(roi_ave,roi_hits);
% CaBMI_getROI.m

% wal3
% d03.19.18

[coeff,score] = pca(roi_ave.F_dff);
coeff = coeff';
  for i = 1:size(roi_hits)
      try
PCA_hits(i,:,:) = (coeff(:,roi_hits(i)-200:roi_hits(i)+200))';
      catch
          disp(' one hit is too close to the end...');
      end
  end

  

  

  