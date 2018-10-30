function pca_plotting(PCA_hits,roi_hits)

  PCs = [1 2 3];
counter = 1;
for ii = PCs
for i = 1:size(PCA_hits,1);
    %mat2(i,:,counter) = mat2gray(smooth( diff(PCA_hits(i,:,ii)),5));
    mat2(i,:,counter) = mat2gray(smooth(PCA_hits(i,:,ii),5));

end
counter = counter+1;
end
mat3 = cat(3, mat2(:,:,1),mat2(:,:,2), mat2(:,:,3)); 


figure()
col = hsv(6);
hold on
subplot(5,1,1);
hold on;
for ii = 1:6;
    data = squeeze(PCA_hits(:,:,ii))-squeeze(PCA_hits(:,1,ii));
    
L = size(data,2);
se = std(data)/sqrt(length(data));
% se = std(data)/2;
mn = mean(data);


h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(ii,:)); alpha(0.5);
plot(mn,'Color',col(ii,:));
    
    
    
end
xlim([0 length(data)]);
subplot(5,1,2:5)
h = imagesc(mat3); 
% set(gca,'DataAspectRatio',[1 .5 .1])
hold off 