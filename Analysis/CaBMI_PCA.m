function [PCA_data]= CaBMI_PCA(roi_ave,roi_hits);
% CaBMI_getROI.m

% wal3
% d03.19.18

% [ds_hits, roi_hits] = CaBMI_csvAlign(csv_data(:,2),csv_data(:,3),roi_ave);


ploting =1;
do_jPCA = 0;

temp = zscore(roi_ave.F_dff(:,:),[],2);

disp('smoothing data');
for i = 1:size(temp,1)
    temp2(i,:) = smooth(temp(i,:),4);
end

    
    
[coeff,score] = pca(temp2);
coeff = coeff';
  for i = 1:size(roi_hits)
      try
PCA_hits(i,:,:) = (coeff(:,roi_hits(i)-200:roi_hits(i)+200))';
      catch
          disp(' one hit is too close to the end...');
      end
  end

  
if ploting == 1;
pca_plotting(PCA_hits,roi_hits);
%print(gcf,'-depsc','-painters','PCA/PCA_plot.eps');
%epsclean('PCA/PCA_plot.eps'); % cleans and overwrites the input file
end


if do_jPCA == 1;
    Data.A =  temp2';
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
%print(gcf,'-depsc','-painters','PCA/jPCA_plot.eps');
%epsclean('PCA/jPCA_plot.eps'); % cleans and overwrites the input file
end

PCA_data.jPCA_hits = jPCA_hits;
end

PCA_data.PCA_hits = PCA_hits;
    

  