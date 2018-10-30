function [out] = CaBMI_sequence_len(ROIhits);

 %% Build an estimation of the sequence length
    
 disp(' determining Sequence length...');
bll = 10:5:200;
    % sort cells
    num_perms = 3;
for iii = 1:size(bll,2);
mid = round(size(ROIhits,2)/2);
bound = bll(iii);
rn = (mid-bound):(mid+bound);% range
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
range_null = [1:(bound*2)]; % make a null range, 200-100 frames before the hit!

for ii = 1:num_perms % 100 permutations
    clear a2 B C cb r
   G = randperm(size(ROIhits,1));
    % randomize times/ sort data
data3.undirected = ROIhits(G(1:round(size(ROIhits,1)/2)),range_true,:);
data3.directed = ROIhits(G(round(size(ROIhits,1)/2):end),range_true,:);

[indX,B,C] = CaBMI_schnitz(data3,'show',0);
     %%%% plot the  map
 a2(1,:,:) = B';
 a2(2,:,:) = C';

for i = 1:size(B,1);
    cb(:,1) = (B(i,:))';
    cb(:,2) = (C(i,:))';
r = corr(cb);
rk(ii,:,i) = (r(1,2));
end

end

finRK(:,iii) = nanmean(rk(:));
end

figure(); plot(finRK);

out.bf = finRK;

clear finRK

% 
% disp('after...');
% 
% 
% mid = round(size(ROIhits,2)/2);
% bound = 200;
% % rn = (mid-bound):(mid+bound);% range
% %range_true = [mid:(mid+bound)];%(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
% range_true = [(mid-bound):(mid+bound)];%(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
% 
% for ii = 1;%num_perms % 100 permutations
%     clear a2 B C cb r
%     disp(['permutation',num2str(ii)]);
%    G = randperm(size(ROIhits,1));
% 
%    
% % C = squeeze((mean(ROIhits(G(1:round(size(ROIhits,1)/2)),range_true,:),1)));
% % B = squeeze((mean(ROIhits(G(round(size(ROIhits,1)/2):end),range_true,:),1)));
% C = squeeze((mean(ROIhits(1:2:round(size(ROIhits,1)),range_true,:),1)));
% B = squeeze((mean(ROIhits(2:2:round(size(ROIhits,1)),range_true,:),1)));
% 
% 
% 
% 
% % [indX,B,C] = CaBMI_schnitz(data3,'show',0);
%      %%%% plot the  map
% %  a2(1,:,:) = B';
% %  a2(2,:,:) = C';
% % 
% % for i = 1:size(B,1);
% %     cb(:,1) = (B(i,:))';
% %     cb(:,2) = (C(i,:))';
% % r = corr(cb);
% % rk(ii,:,i) = (r(1,2));
% % end
% 
% r2(:,:,ii) = abs((B-C));
% end
% 
% finRK2 = squeeze( mean(mean(r2,3),2));
% 
% r3 = squeeze((mean(r2)-min(r2)));
% [a,b] = sort(r3,'descend');
% 
% figure();
% plot(mean(squeeze(mean(r2(:,b(1:100),:),3)),2));
% 
% 
% 
% figure(); plot(smooth(finRK2,20));
% 
% 
% out = 0;

    
    