function [T, ydat, AA, newROI] = CaBMI_tsne(ROIhits)



% clear coeff
% clear score
% clear newROI
% hold on;
% for i = 1:20
%     if i ==1;
%       newROI =  squeeze(ROIhits(i,:,:));
%     else
% B = squeeze(ROIhits(i,:,:));
% newROI = cat(2,newROI,B);
%     end
% end
%
% figure();
% [coeff,score,latent] = pca(newROI,'Centered',0,'NumComponents',3);
% plot(squeeze(coeff(1,:)),squeeze(coeff(1,:)),'o');



% combine to run tsne on all data...
rnavg = 1;

[trials timestamps cells] = size(ROIhits);

% create a timevector
c = 1:rnavg:trials;



% concatnate cells from all averaged trials
  for i = 1:length(c)-1
      CC1 = smoothdata(ROIhits(i,:,:),2,'gaussian',15);
      % CC1 = CC1-min(CC1); % subtract the minimum
      CC2 = squeeze(mean(CC1,1));
      if i ==1;
        newROI =  CC2;
      else
        B = CC2;
        newROI = cat(2,newROI,B);
      end
  end

%% run T-SNE

% pick a timewindow ( 200 is the center, 100-300 is resonable...)
st = 100; %
stp = 300;

C2 =  newROI(st:stp,:)';
ydat = tsne(C2);


% unpack cells
for i = 1:length(c)-1
AA(:,:,i) =  ydat(1+(cells*(i-1)):cells*i,:);
end



%% Plot the Results:

G = colormap(jet(length(c)));
figure();
% for cell = 1:200;
 hold on;
  for i = 1:99
    plot(AA(:,1,i),AA(:,2,i),'o','color',(G(i,:)),'MarkerSize',2);
    pause(.1)
  end% end


% K-menas clustering
% opts = statset('Display','final');
% [idx,C] = kmeans(X,2,'Distance','cityblock',...
%     'Replicates',5,'Options',opts);

T = clusterdata(ydat(1:20000,:),'Maxclust',20);
T = clusterdata(ydat(1:20000,:),'Linkage','ward','Maxclust',50);

colormap(jet(max(T)));

% figure();
% subplot(1,2,1)
% scatter(ydat_30b(1:20000,1),ydat_30b(1:20000,2),10,T);

figure();

scatter(ydat(1:20000,1),ydat(1:20000,2),10,T);

figure(); plot(
