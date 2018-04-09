% ROI analysis


  G1 = ROIhits;
% sort cells
c = squeeze(mean(G1(:,150:250,:),1));
c2 = mean(c);
%[m,ind] = max(c2');
[m2, ind2] = sort(c2,'descend'); 
B1 = ind2(1:300);


figure(); 
for i = 1:100
 plot(G1(1:size(G1,1),:,B1(i))');
 pause(0.3)
end

figure(); 
for i = 1:100
    hold on;
 plot(mean(G1(1:size(G1,1),:,B1(i))+0.1*i));

 pause(0.3)
end

