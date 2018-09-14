
function [out] = CaBMI_HitRate(roi_ave,direct);




smt = 3; % cursor moothing factor
smt2 = 3; % histogram smoothing;
thresh = 2.5;
reset = 1;

if nargin<2
% Direct Neuron simulation
disp('simulating neurons');
E1 = zscore(roi_ave.F_dff(1,:))+zscore(roi_ave.F_dff(2,:));
E2 = zscore(roi_ave.F_dff(3,:))+zscore(roi_ave.F_dff(4,:));

cursor = smooth(E1-E2,smt);
else
    % Actual Direct Neuron activity

E1 = zscore(direct.interp_dff(1,:))+zscore(direct.interp_dff(2,:));
E2 = zscore(direct.interp_dff(3,:))+zscore(direct.interp_dff(4,:));
cursor = smooth(E1-E2,smt);
end





figure();
plot(cursor);
% Indirect Cursor
try % if other format
g = randperm(size(roi_ave.C_dec,1));
for i = 1:400; % 400 permutations 
    for ii = 1:4
    a(ii) = randi(size(roi_ave.C_dec,1));
    end
    
    Ie1 =  zscore(roi_ave.F_dff(a(1),:))+zscore(roi_ave.F_dff(a(2),:));
    Ie2 =  zscore(roi_ave.F_dff(a(3),:))+zscore(roi_ave.F_dff(a(4),:));
    
    Icursor(i,:) = smooth(Ie1-Ie2,smt);
end
countTime = round((size(roi_ave.F_dff,2)/30)/60)/2

catch
g = randperm(size(roi_ave.interp_dff,1));
for i = 1:400; % 400 permutations 
    for ii = 1:4
    a(ii) = randi(size(roi_ave.interp_dff,1));
    end
    
    Ie1 =  zscore(roi_ave.interp_dff(a(1),:))+zscore(roi_ave.interp_dff(a(2),:));
    Ie2 =  zscore(roi_ave.interp_dff(a(3),:))+zscore(roi_ave.interp_dff(a(4),:));
    
    Icursor(i,:) = smooth(Ie1-Ie2,smt);
end
countTime = round((size(roi_ave.interp_dff,2)/30)/60)/2
end



figure();
hold on;
plot(cursor,'b');
plot(mean(Icursor,1),'r');



% Get reward rate
[hits, locs] = CaBMI_threshSim(cursor,thresh,reset);

%figure(); plot(cursor); hold on; plot(idx(yest), ones(size(idx(yest),1),1),'*');

figure();
[N,edges] = histcounts(locs,countTime);
N1 = smooth(N,smt2);

clear N
% For indirect Neurons

for i = 1:300;

    tcursor = Icursor(i,:);


[hits, locs] = CaBMI_threshSim(tcursor,thresh,reset);

[Nv,edges] = histcounts(locs,countTime);
N(:,i) = smooth(Nv,smt2);
end




% Plot data...


figure(); 
hold on;

col = hsv(1);
data = (N)';
    
L = size(data,2);
sd = std(data)/sqrt(length(data));
se = std(data)/2;

mn = mean(data);


h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(1,:)); alpha(0.5);
plot(mn,'Color',col(1,:));
    

plot(N1,'b');



% get the hit rate
out.hit_rate = N1;
out.null_hit_rate = N;
    
    
    