function [pool1, dim] = CaBMI_running_FA(roi_ave)

% Estimate the number of factors needed to explain BMI data on a rolling basis


% Dd08/03/18


warning off
% Get data in a matrix:

G = roi_ave.F_dff;

idx = 1:3:size(G,2);
L = 30; %length of corr;


parfor i = 1:1000%(size(idx,2)-1)
  disp(['processing ' num2str(i), 'of ', num2str(size(idx,2)-1)])
G1= G(:,idx(i):idx(i)+L);
[dim_to_use1, result1] = findzdim(G1);
pool1(:,i) = result1.line;
dim(:,i) = dim_to_use1;

mn(:,i) = mean(mean(G1),2);
% % Randomize...
% for ii = 1:size(G1,1)
% g2 = randperm(size(G1,2));
% C1(ii,:) = smooth(G1(1,g2),4);
% end
%
% [dim_to_use3, result3] = findzdim(C1);
% pool3(:,i) = result3.line;

% try
% G2= squeeze(Gb(i,:,:))';
% [dim_to_use2, result2] = findzdim(G2);
% pool2(:,i) = result2.line;
% catch

%
% end
end

figure(); 
h = plot(pool1,'g');

% colors = summer(4);
% set(h, {'color'}, num2cell(colors, 2));


%figure(); hold on; plot(pool1,'g'); plot(pool2,'m'); plot(pool3,'b');
warning on


for i = 1:1000%(size(idx,2)-1)
G1= G(:,idx(i):idx(i)+L);
mn(:,i) = mean(mean(G1,1));
st(:,i) = mean(std(G1,[],2));
end


% Calculate the mean of the signal


%
%
% figure();
% col = jet(3);
% hold on;
% for i = 1:3;
%
%     if i ==1;
%         adata = pool1';
%     elseif i ==2
%         adata = pool2';
%     else
%         adata = pool3';
%     end
% L = size(adata,2);
% se = std(adata);
% mn = mean(adata);
%
%
% h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(1);
% plot(mn,'Color',col(i,:));
%
% end
%
%
%
% %% interpolate
%
% x = 1:size(pool1,1);
% x2 = 1:0.01:size(pool1,1);
% p1 = interp1(x,pool1,x2);
% p2 = interp1(x,pool2,x2);
%
% clear AA
% clear AB
% % for i = 1:63;
% % [c ind1] = min(abs(0.95-p1(:,i)));
% % AA(:,i) = ind1;
% %
% % try
% % [c ind2] = min(abs(0.95-p2(:,i)));
% % AB(:,i) = ind2;
% % catch
% % end
% % end
% for i = 1:63;
% AA(:,i) = p1(300,i);
%
% try
% AB(:,i) = p2(300,i);
% catch
% end
% end
%
% figure();
% hold on;
% h1 = histogram(AB,'FaceColor','m');
% h2 = histogram(AA,'FaceColor','g');
% h1.Normalization = 'probability';
% h1.BinWidth = 0.018;
% h2.Normalization = 'probability';
% h2.BinWidth = 0.018;
%
% [h,p] = kstest2(AB,AA);
