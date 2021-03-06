function out = CaBMI_incorperateROI(ROIhits_s)



% how many indirect ROIs are incorperated over time ( 
%task relevancy for 10 time bins:


% Sort by the 'task re;evant cells- most active at the hit.)
range = 170:200;
n1_range = 1:50;
%n1_range = 350:400;
num_bins = 10; 
clear a b b2 a2

Hitrange = 1:(floor(size(ROIhits_s,1)/num_bins)):size(ROIhits_s,1);

if size(ROIhits_s,1)>10;
    
size(ROIhits_s);

for i = 1:num_bins-1
% Early
try
local_Hitrange = Hitrange(i):Hitrange(i+1);
 a(:,i) = squeeze(abs(max(mean(ROIhits_s(local_Hitrange,range,:),1)) - min(mean(ROIhits_s(local_Hitrange,range,:),1))))+0.001;
 b(:,i) = squeeze(abs(max(mean(ROIhits_s(local_Hitrange,n1_range,:),1)) - min(mean(ROIhits_s(local_Hitrange,n1_range,:),1))))+0.001;
 %aD(:,i) = squeeze(abs(max(mean(D_ROIhits_z(local_Hitrange,range,:),1)) - min(mean(D_ROIhits_z(local_Hitrange,range,:),1))));
% bD(:,i) = squeeze(abs(max(mean(D_ROIhits_z(local_Hitrange,n1_range,:),1)) - min(mean(D_ROIhits_z(local_Hitrange,n1_range,:),1))));
 
catch
    disp('too close to end.. replicating last bin...');
    a(:,i) =  a(:,i-1);
    b(:,i) =  b(:,i-1);
end
 S(i,:) = squeeze(a(:,i)./b(:,i));
end

out.spikes = S;

for i = 1:num_bins-1
G(i,:) = (sum(S(i,:)>2)/size(S,2))*100;
end
figure(); 
plot(G);

out.a = a;
out.b = b;
else
    out.a = [];
    out.b = []
end

