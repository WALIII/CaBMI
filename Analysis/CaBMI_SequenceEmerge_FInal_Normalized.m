function CaBMI_SequenceEmerge_FInal_Normalized(ROIhits)

% input paramaters

% sort cells
mid = round(size(ROIhits,2)/2);
bound = round(size(ROIhits,2)/4);
rn = (mid-bound):(mid+bound);% range

%Ranges
R1 = 1:10%round((size(ROIhits,1)/3));
R2 = round((size(ROIhits,1)/3)):round((size(ROIhits,1)/3))*2;
R3 = round((size(ROIhits,1)/3))*2:(round((size(ROIhits,1)/3))*3)-1;
RS = 1:(round((size(ROIhits,1)/3))*3)-1;

% Get top cells:

[ROIhits_z2 ROIhits_z,ROI_index] = CaBMI_topCells(ROIhits(:,:,:),rn,0.7);


G1 = ROIhits(:,:,ROI_index);

range_null = [1:bound*2]; % make a null range, 200-100 frames before the hit!
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
offset = 0;

data.sort = G1(R3,range_true,:);
data.directed = G1(R1,range_true,:);
data.undirected = G1(R2,range_true,:);
data.undirected3 = G1(R3,range_true,:);


dataSort.directed = G1(R3,range_true,:);
dataSort.undirected = G1(R3,range_true,:);

G1_min = min(G1,[],2);
G2 = (G1-G1_min);
%concat 
dataCat.undirected = cat(2, mean(G2(R1,range_true,:),1), mean(G2(R2,range_true,:),1),mean(G2(R3,range_true,:),1));
dataCat.directed = cat(2, mean(G2(R1,range_true,:),1), mean(G2(R2,range_true,:),1),mean(G2(R3,range_true,:),1));

%dataCat.directed(1,:,:) = cat(2, mean(G1(R1,range_true,:),1)-min(mean(G1(R1,range_true,:),1)), mean(G1(R2,range_true,:),1)-min(mean(G1(R2,range_true,:),1)),mean(G1(R3,range_true,:),1)-min(mean(G1(R3,range_true,:),1)));

[indX,B,C, output] = CaBMI_schnitz(dataSort);

[indX,B,C, output] = CaBMI_schnitz(dataCat,'index',output.Index);


dataSort2.directed = G1(R1,range_true,:);
dataSort2.undirected = G1(R1,range_true,:);
[indX,B,C, output] = CaBMI_schnitz(dataSort2);

[indX,B,C, output] = CaBMI_schnitz(dataCat,'index',output.Index,[0,3]);

