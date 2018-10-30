function CaBMI_SchnitzConsistancy(ROIhits,varargin)


show =1; 
bins = 20;
num_perms = 5;
% Manual inputs
vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'show') % manually inputing a sort order
    show=vin{i+1};
    man =1;
  elseif isequal(vin{i},'ri')
    ri=vin{i+1};
end
end



% randomize times/ sort data

% sort cells
mid = round(size(ROIhits,2)/2);
bound = round(size(ROIhits,2)/4);
rn = (mid-bound):(mid+bound);% range
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
range_null = [1:(bound*2)]; % make a null range, 200-100 frames before the hit!

for ii = 1:num_perms % 100 permutations
    
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

disp('Null range...');
clear a2 cb B C r 
for ii = 1:num_perms % 100 permutations
    
   G = randperm(size(ROIhits,1));
    % randomize times/ sort data
data3.undirected = ROIhits(G(1:round(size(ROIhits,1)/2)),range_null,:);
data3.directed = ROIhits(G(round(size(ROIhits,1)/2):end),range_null,:);


[indX,Bb,Cb] = CaBMI_schnitz(data3,'show',0);

     %%%% plot the  map
 a2(1,:,:) = Bb';
 a2(2,:,:) = Cb';

for i = 1:size(Bb,1);
    cb(:,1) = (Bb(i,:))';
    cb(:,2) = (Cb(i,:))';
r = corr(cb);
rk2(ii,:,i) = (r(1,2));
end

end




rk_total = squeeze(mean(rk,1)); % take all values
rk2_total = squeeze(mean(rk2,1));  % take all values






figure(); 
hold on;
h1 = histogram(rk_total,bins);
h2 = histogram(rk2_total,bins);
% h1.DisplayStyle = 'stairs';
h1.Normalization = 'probability';
% h2.DisplayStyle = 'stairs';
h2.Normalization = 'probability';
% Make histograms




print(gcf,'-depsc','-painters','Schnitz_hist_2.eps');
epsclean('Schnitz_hist_2.eps'); % cleans and overwrites the input file


    
   