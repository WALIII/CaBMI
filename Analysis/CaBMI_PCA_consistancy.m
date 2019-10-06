function [out] = CaBMI_PCA_consistancy(PCA_hits)

%how consistant are PCs from trial to trial
% output from >> [PCA_hits]= CaBMI_PCA(roi_ave1,roi_hits);

% consistancy Plots
PCa = PCA_hits;


figure()
counter = 1; 
for ii = 1:3 % for each PC
% smooth PC over trials:
rng = 10; % group size
PC2use = smooth2a(squeeze(PCa(:,:,ii)),1,10);    
PC2use = PC2use-min(PC2use,[],2);
PC2use = double(PC2use');

for i = 1:size(PCa,1)-rng;
    BBB = corr(PC2use(190:200,i:i+rng));
     Bk(counter,i) = nanmean(BBB(2:rng,1));
end
counter = counter+1;
end


figure();   
plot(smooth(mean(Bk,1),1),'*');

out.consistance_PC = Bk;