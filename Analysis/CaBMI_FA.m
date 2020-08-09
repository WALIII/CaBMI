function [out] = CaBMI_FA(ROIhits,roi_ave1,roi_hits);


% Dd06/08/18
% Generate random hits:

% Generate fake hits within a few seconds of the real hits  

a = 500;
b = 1100;
r = (b-a).*rand(size(ROIhits,1),1) + a;
%fake_hits = round(r)+roi_hits;


fake_hits = randi(size(roi_ave1.F_dff,2),size(ROIhits,1),1);
% fake_hits2 = 

[~,~,fake_ROIhits, ~]= CaBMI_getROI(roi_ave1,fake_hits);

warning off

var_exp = 90;

Ga = ROIhits(:,100:400,:);
Gb = fake_ROIhits(:,100:400,:);



% Smooth spiking from each dataset:
kernSize = 3;
[Ga] = CaBMI_SmoothHits(Ga,kernSize);
[Gb] = CaBMI_SmoothHits(Gb(:,:,1:size(Ga,3)),kernSize);

for i = 1:size(Gb,1)
G1= squeeze(Ga(i,:,:))';
G2= squeeze(Gb(i,:,:))'; % to prevent overhang

 %[dim_to_use1, result1] = findzdim(G1);
% pool1(:,i) = result1.line;
try
[~,~,latent1,~,explained1,~] = pca(G1);
[~,~,latent2,~,explained2,~] = pca(G2);
catch
    disp('SVD failure..');
 [~,~,latent1,~,explained1,~] = pca(G1(:,2:end,:));
[~,~,latent2,~,explained2,~] = pca(G2(:,2:end,:));   
end

b = explained1(1);
counter = 1;
while b<var_exp
   counter = counter+1;
    b = b + explained1(counter);
end
logit1(:,i) = counter;

% for the fake hits...
b2 = explained2(1);
counter2 = 1;
while b2<var_exp
   counter2 = counter2+1;
    b2 = b2 + explained2(counter2);

end
logit2(:,i) = counter2;
end
figure(); 
hold on;
plot(logit1,'g');
plot(logit2,'r');

out.to99 = logit1;
out.to99_fake = logit2;



D2 = 1:floor(size(logit1,2)/9-1):size(logit1,2);

% get seqlength

for ii = 1:10-1;

    Dtemp(:,ii) = logit1(1,D2(ii):D2(ii+1));
    Dtemp2(:,ii) = logit2(1,D2(ii):D2(ii+1));
  

end

figure();
hold on;
gg{1} = Dtemp';
gg2{1} = Dtemp2';
plotme(gg,'g')
title('True hits');
plotme(gg2,'b')
title('Fake hits');

% % Randomize...
% for ii = 1:size(G1,1)
% g2 = randperm(size(G1,2));
% C1(ii,:) = smooth(G1(1,g2),4);
% end
% 
% [dim_to_use3, result3] = findzdim(C1);
% pool3(:,i) = result3.line;
% 
% try
% G2= squeeze(Gb(i,:,:))';
% [dim_to_use2, result2] = findzdim(G2);
% pool2(:,i) = result2.line;
% catch
%     
% end
% end
% 
% figure(); hold on; plot(pool1,'g'); plot(pool2,'m'); plot(pool3,'b');
% warning on
% 
% 
% 
% 
% figure();
% col = jet(3);
% hold on;
% for i = 11;
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
% % p2 = interp1(x,pool2,x2);
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
% % try
% % AB(:,i) = p2(300,i);
% % catch
% % end
% end
% 
% figure();
%  hold on;
% % h1 = histogram(AB,'FaceColor','m');
% h2 = histogram(AA,'FaceColor','g');
% % h1.Normalization = 'probability';
% h1.BinWidth = 0.018;
% h2.Normalization = 'probability';
% h2.BinWidth = 0.018;
% 
% % [h,p] = kstest2(AB,AA);
% 

