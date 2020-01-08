function output_1 =  CaBMI_SequenceEmerge(ROIhits)

% input paramaters

% sort cells
mid = round(size(ROIhits,2)/2);
bound = round(size(ROIhits,2)/4);
rn = (mid-bound):(mid+bound);% range

%Ranges
if size(ROIhits,1)>30; 
R1 = 1:10;%round((size(ROIhits,1)/3));
else
    R1 = 1:round((size(ROIhits,1)/3));
end


R2 = round((size(ROIhits,1)/3)):round((size(ROIhits,1)/3))*2;
R3 = round((size(ROIhits,1)/3))*2:(round((size(ROIhits,1)/3))*3)-1;
RS = 1:(round((size(ROIhits,1)/3))*3)-1;

% Get top cells:

[ROIhits_z2 ROIhits_z] = CaBMI_topCells(ROIhits(:,:,:),rn,0.9);


G1 = ROIhits_z;

range_null = [1:bound*2]; % make a null range, 200-100 frames before the hit!
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
offset = 0;

data.sort = G1(R3,range_true,:);
data.directed = G1(R1,range_true,:);
data.undirected = G1(R2,range_true,:);
data.undirected3 = G1(R3,range_true,:);

% early vs late
earl = R1(1:(floor(size(R1,2))/2));
lat = R1(floor(size(R1,2)/2):size(R1,2));
EarlyData.directed = G1(earl,range_true,:);
EarlyData.undirected = G1(lat,range_true,:);
earl = R3(1:(floor(size(R3,2))/2));
lat = R3(floor(size(R3,2)/2):size(R3,2));
LaterData.directed = G1(earl,range_true,:);
LaterData.undirected = G1(lat,range_true,:);




figure();

% To run without generating figures:
% [indX,B,C] = CaBMI_schnitz(data,'show',0)

show = 1;







smth = 5; % smoothing factor!
Cel =  size(data.directed,3);
index_ref = cat(1,data.directed,data.undirected);

for i = 1:Cel;
    R(i,:) = (var(index_ref(:,:,i),1));
    M(i,:) = ((mean(index_ref(:,:,i),1)));
    out = smooth(M(i,:),smth);
    Mp(i,:) = zscore(out);
end
[maxA, Ind] = max(Mp, [], 2);
[dummy, index] = sort(Ind);
FullSort  = (Mp(index, :));
Index = index;
output.FullSort = FullSort;
output.Index = Index;

clear Ind maxA dummy index;


clear G;
clear G2

for i = 1:Cel;
    S(i,:) = ((mean(data.sort(:,:,i),1)));
    Sout = smooth(S(i,:),smth);
    Sp(i,:) = zscore(Sout);
    S_std(i,:) = ((var(data.sort(:,:,i),[],1)));
end


for i = 1:Cel;
    G(i,:) = ((mean(data.directed(:,:,i),1)));
    out = smooth(G(i,:),smth);
    Gp(i,:) = zscore(out);
    G_std(i,:) = ((var(data.directed(:,:,i),[],1)));
end

for i = 1:Cel;
    G2(i,:) = ((mean(data.undirected(:,:,i),1)));
    out = smooth(G2(i,:),smth);
    Gp2(i,:) = zscore(out);
    G2_std(i,:) = ((var(data.undirected(:,:,i),[],1)));
end

for i = 1:Cel;
    G3(i,:) = ((mean(data.undirected3(:,:,i),1)));
    out3 = smooth(G3(i,:),smth);
    Gp3(i,:) = zscore(out3);
    G3_std(i,:) = ((var(data.undirected3(:,:,i),[],1)));
end



S = Sp;
G = Gp;
G2= Gp2;
G3= Gp3;

[maxA, Ind] = max(S, [], 2);
[dummy, index] = sort(Ind);

B  = (G(index, :));
C  = (G2(index, :));
D = (G3(index, :));
B_2  = (G_std(index, :));
C_2  = (G2_std(index, :));
D_2  = (G3_std(index, :));

% D =  (R(index, :));
indX = index;


% Plotting
if show ==1;
figure();

subplot(1,3,1)
imagesc((B), [0, 3]);
title('Sorted Trials');
ylabel('ROIs');
xlabel('Frames');
hold on;

subplot(1,3,2)

imagesc((C), [0, 3] );

title('Usorted Trials');
ylabel('ROIs');
xlabel('Frames');
 colormap(hot);

 colorbar

end

subplot(1,3,3)

imagesc((D), [0, 3] );

title('Usorted Trials');
ylabel('ROIs');
xlabel('Frames');
 colormap(hot);

 colorbar




%  figure();
%  subplot(131);
%  imagesc((B_2./B), [0, 10] );
%   subplot(132);
%  imagesc((C_2./C), [0, 10] );
%   subplot(133);
%  imagesc((D_2./D), [0, 10] );
% colormap(hot);

% Calculate differences
for i = 1:size(B,1);
    cb(:,1) = (B(i,:))';
    cb(:,2) = (C(i,:))';

    cd(:,1) = (C(i,:))';
    cd(:,2) = (D(i,:))';
r1 = corr(cb);
r2 = corr(cd);
rk1(:,i) = r1(1,2);
rk2(:,i) = r2(1,2);
end
% Early to mid
disp(['early to mid corr = ',num2str(mean(rk1))]);
% Mid to late
disp(['mid to late corr = ',num2str(mean(rk2))]);

output_1.early_mid = mean(rk1);
output_1.mid_late = mean(rk2);

% look at early resort, vs late:
figure(); 
[indX,B1,C1, output] = CaBMI_schnitz(EarlyData);
title('Early Data');
figure
[indX,B2,C2, output] = CaBMI_schnitz(LaterData);
title('Later Data');


% Calculate differences
for i = 1:size(B1,1);
    cb(:,1) = (B1(i,:))';
    cb(:,2) = (C1(i,:))';

    cd(:,1) = (B2(i,:))';
    cd(:,2) = (C2(i,:))';
r1 = corr(cb);
r2 = corr(cd);
rk1(:,i) = r1(1,2);
rk2(:,i) = r2(1,2);
end
% Early to mid
disp(['early to early corr = ',num2str(nanmean(rk1))]);
% Mid to late
disp(['late to late corr = ',num2str(nanmean(rk2))]);

output_1.early_early = nanmean(rk1);
output_1.late_late = nanmean(rk2);