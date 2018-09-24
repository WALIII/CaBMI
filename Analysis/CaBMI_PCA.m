function [PCA_hits, jPCA_hits]= CaBMI_PCA(roi_ave,roi_hits);
% CaBMI_getROI.m

% wal3
% d03.19.18

% [ds_hits, roi_hits] = CaBMI_csvAlign(csv_data(:,2),csv_data(:,3),roi_ave);


ploting =1;
do_jPCA = 1;


[coeff,score] = pca(roi_ave.F_dff);
coeff = coeff';
  for i = 1:size(roi_hits)
      try
PCA_hits(i,:,:) = (coeff(:,roi_hits(i)-400:roi_hits(i)+400))';
      catch
          disp(' one hit is too close to the end...');
      end
  end

  
if ploting == 1;
pca_plotting(PCA_hits,roi_hits);

end


if do_jPCA == 1;
    Data.A = roi_ave.F_dff';
[Projection, Summary] = jPCA(Data);


jG = zscore(Projection.proj');
for i = 1:size(roi_hits)
try
jPCA_hits(i,:,:) = (jG(:,roi_hits(i)-400:roi_hits(i)+400))';
catch
disp(' one hit is too close to the end...');
end
end

if ploting == 1;
pca_plotting(jPCA_hits,roi_hits);

end

end
    

  