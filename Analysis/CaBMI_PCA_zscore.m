function [out] = CaBMI_PCA_zscore(ROIhits_z,Nmax);


% Nmax = 95;

for i = 1:size(ROIhits_z,1); 
    
 AA  = squeeze(ROIhits_z(i,:,:));
% for ii = 1:size(AA,2);
%     AA2(:,ii) = smooth(AA(:,ii),10);
% end

warning off
[coeff,score,latent,tsquared,explained,mu] = pca(squeeze(AA));
A = explained;
ca = cumsum(A);  % Sum them all up
lastIndex = find(ca <= Nmax, 1, 'last'); % Last index before the sum would exceed Nmax.
% Show what elements they were "Pending" (whatever that means in this context).
out(i) = lastIndex;
clear AA AA2 ca A lastIndex
end

figure(); plot(out,'*');


