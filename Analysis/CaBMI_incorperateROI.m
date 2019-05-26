function out = CaBMI_incorperateROI(ROIhits_z,ROIhits_s,D_ROIhits_z)



% how many indirect ROIs are incorperated over time ( 
%task relevancy for 10 time bins:


% Sort by the 'task re;evant cells- most active at the hit.)
range = 190:250;
n1_range = 1:50;
%n1_range = 350:400;
num_bins = 10;
clear a b b2 a2

Hitrange = 1:(round(size(ROIhits_z,1)/num_bins)):size(ROIhits_z,1);

size(ROIhits_z);

for i = 1:num_bins-1
% Early
local_Hitrange = Hitrange(i):Hitrange(i+1);
 a(:,i) = squeeze(abs(max(mean(ROIhits_z(local_Hitrange,range,:),1)) - min(mean(ROIhits_z(local_Hitrange,range,:),1))));
 b(:,i) = squeeze(abs(max(mean(ROIhits_z(local_Hitrange,n1_range,:),1)) - min(mean(ROIhits_z(local_Hitrange,n1_range,:),1))));
 aD(:,i) = squeeze(abs(max(mean(D_ROIhits_z(local_Hitrange,range,:),1)) - min(mean(D_ROIhits_z(local_Hitrange,range,:),1))));
 bD(:,i) = squeeze(abs(max(mean(D_ROIhits_z(local_Hitrange,n1_range,:),1)) - min(mean(D_ROIhits_z(local_Hitrange,n1_range,:),1))));
 
 S(i,:) = squeeze(a(:,i)./b(:,i));
end


for i = 1:num_bins-1
G(i,:) = (sum(S(i,:)>3)/size(S,2))*100;
end
figure(); 
plot(G);

out.a = a;
out.b = b;