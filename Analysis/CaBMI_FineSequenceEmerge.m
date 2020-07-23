function [outputB numCells] = CaBMI_FineSequenceEmerge(ROIhits)




% sort cells
mid = round(size(ROIhits,2)/2);
bound = round(size(ROIhits,2)/4);
rn = (mid-bound):(mid+bound);% range

%Ranges
%Ranges
if size(ROIhits,1)>30; 
R1 = 1:10;%round((size(ROIhits,1)/3));
else
    R1 = 1:round((size(ROIhits,1)/3));
end
R2 = round((size(ROIhits,1)/3)):round((size(ROIhits,1)/3))*2;
R3 = round((size(ROIhits,1)/3))*2:(round((size(ROIhits,1)/3))*3)-1;
R4 = round((size(ROIhits,1)/5))*4:(round((size(ROIhits,1)/3))*3)-1;

RS = 1:(round((size(ROIhits,1)/3))*3)-1;

% Get top cells:

[ROIhits_z2 ROIhits_z] = CaBMI_topCells(ROIhits(:,:,:),rn,0.8);
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit

% use the output of just the top cells
G1 = ROIhits_z;

data.directed = G1(R3,range_true,:);
data.undirected = G1(R3,range_true,:);

totalHits = size(ROIhits_z,1);

% Break into 10 groups
group2use = 7;
Id = 1:floor(totalHits/group2use):totalHits;
Id(group2use+1) =  totalHits;

% initial sort
[indX,B,C, output] = CaBMI_schnitz(data)


for i = 1:group2use;
[XX XX2] = CaBMI_topCells(G1(Id(i):Id(i+1),:,:),rn,0.7);
numCells(i) =  size(XX2,3)/size(ROIhits,3)*100;

data.undirected = G1(Id(i):Id(i+1),range_true,:);

[indX,B,C, output] = CaBMI_schnitz(data);

% Calculate differences
for ii = 1:size(B,1);
    cb(:,1) = (B(ii,:))';
    cb(:,2) = (C(ii,:))';

r1 = corr(cb);

rk1(:,ii) = r1(1,2);
end
% Early to mid
disp(['early to mid corr = ',num2str(mean(rk1))]);


outputB(i) = mean(rk1);

close all
clear r1 rk2 cb 
end


figure(); 
hold on;
plot(outputB);


    


