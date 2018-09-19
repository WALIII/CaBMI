function [PCA_hits]= CaBMI_PCA(roi_ave,roi_hits);
% CaBMI_getROI.m

% wal3
% d03.19.18


ploting =1;


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
  PCs = [1 2 4];
counter = 1;
for ii = PCs
for i = 1:size(PCA_hits,1);
    mat2(i,:,counter) = smooth(mat2gray(( PCA_hits(i,:,ii))-( PCA_hits(i,1,ii))),50);
end
counter = counter+1;
end
mat3 = cat(3, mat2(:,:,1),mat2(:,:,2), mat2(:,:,3)); 


figure()
col = hsv(6);
hold on
subplot(5,1,1);
hold on;
for ii = 1:6
    data = squeeze(PCA_hits(:,:,ii))-squeeze(PCA_hits(:,1,ii));
    
L = size(data,2);
se = std(data)/sqrt(length(data));
% se = std(data)/2;
mn = mean(data);


h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(ii,:)); alpha(0.5);
plot(mn,'Color',col(ii,:));
    
    
    
end
xlim([0 800]);
subplot(5,1,2:5)
h = imagesc(mat3); 
% set(gca,'DataAspectRatio',[1 .5 .1])
hold off 
end

  