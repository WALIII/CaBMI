function CaBMI_SequenceEmerge(ROIhits)

% input paramaters

% sort cells
mid = round(size(ROIhits,2)/2);
bound = round(size(ROIhits,2)/4);
rn = (mid-bound):(mid+bound);% range

%Ranges
R1 = 1:10;
R2 = round((size(ROIhits,1)/3)):round((size(ROIhits,1)/3))*2
R3 = round((size(ROIhits,1)/3))*2:(round((size(ROIhits,1)/3))*3)-1;
RS = 1:(round((size(ROIhits,1)/3))*3)-1;

% Get top cells:

[ROIhits_z2 ROIhits_z] = CaBMI_topCells(ROIhits(:,:,:),rn,0.7);


G1 = ROIhits_z;

range_null = [1:bound*2]; % make a null range, 200-100 frames before the hit!
range_true = [(mid-bound):(mid+bound)]; % A true range, in the ~100 framse surrounding the hit
offset = 0;

data.sort = G1(R3,range_true,:);
data.directed = G1(R1,range_true,:);
data.undirected = G1(R2,range_true,:);
data.undirected3 = G1(R3,range_true,:);






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

 
 
 
 figure(); 
 subplot(131);
 imagesc((B_2./B), [0, 10] );
  subplot(132);
 imagesc((C_2./C), [0, 10] );
  subplot(133);
 imagesc((D_2./D), [0, 10] );
colormap(hot);
end
