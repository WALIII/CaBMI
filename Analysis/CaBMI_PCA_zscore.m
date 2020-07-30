function [out pc1exp stats] = CaBMI_PCA_zscore(ROIhits_z,Nmax);


% Nmax = 95;

for i = 1:size(ROIhits_z,1); 
    
 AA  = squeeze(ROIhits_z(i,:,:));
% for ii = 1:size(AA,2);
%     AA2(:,ii) = smooth(AA(:,ii),10);
% end

warning off
[coeff,score,latent,tsquared,explained,mu] = pca(squeeze(AA));
A = explained;
pc1exp(i) = explained(1)+explained(2);
ca = cumsum(A);  % Sum them all up
lastIndex = find(ca <= Nmax, 1, 'last'); % Last index before the sum would exceed Nmax.
% Show what elements they were "Pending" (whatever that means in this context).
out(i) = lastIndex;
clear AA AA2 ca A lastIndex
end

figure(); 
hold on; 
plot(out,'*');
plot(smooth(out(2:end),20),'--','LineWidth',3);
title(['Number of dimensions to explain ', num2str(Nmax),' percent variance']);

figure(); hold on; plot(pc1exp,'*');
plot(smooth(pc1exp(2:end),20),'--','LineWidth',3);
title(['Percent variance explained by first and second PC']);

% do some basic stats:

tp1 = round(size(out,2)*.15); % run stats on the top and bottom 25% hits
[stats.pVal_numDim,~] = ranksum(out(1:tp1+1),out(end-tp1:end));
[stats.pVal_PC1and2,~] = ranksum(pc1exp(1:tp1+1),pc1exp(end-tp1:end))