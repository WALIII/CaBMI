function CaBMI_Analysis_100719(DATA)

% load in data

% Input data from [DATA} = CaBMI_batchplot2
% tune thr range to use in: [out] = CaBMI_PCA_consistancy(PCA_hits)

Dys = 7;
ams = 5;


bin2use = 10;

dim1 = 1:3;
for i = 1:ams
% bin into 10 groups
 clear D
 
[outPCA] = CaBMI_PCA_consistancy(DATA.PCA{5}{i}.PCA_hits);
data =  squeeze(outPCA.consistance_PC);
 % split into groups
D = 1:floor((size(data,2)-1)/bin2use):size(data,2);

% get seqlength

for ii = 1:bin2use;
    try
    Dtemp(:,ii) =mean(data(dim1,D(ii):D(ii+1)));
    %Dtemp2(:,ii) = dim_explained.to99_fake(D(ii):D(ii+1));
    catch
        disp('warning= catched data')
    end
end

try
Dwhole = cat(1,Dwhole,Dtemp);

catch
    Dwhole = Dtemp;

end
clear Dtemp out

end

figure(); plot(Dwhole')
gg{1} = Dwhole';
plotme(gg)



% Across animals:
counter = 1;
for iii = [1 2 3 4 5 6  7];
clear Dwhole Dtemp gg
for i = 1:5
% bin into 10 groups
 
try
[outPCA] = CaBMI_PCA_consistancy(DATA.PCA{iii}{i}.PCA_hits);
data =  squeeze(outPCA.consistance_PC); % split into groups

D = 1:floor((size(data,2)-1)/bin2use):size(data,2);

% get seqlength


for ii = 1:bin2use;
    try
    Dtemp(:,ii) =mean(data(dim1,D(ii):D(ii+1)));
    %Dtemp2(:,ii) = dim_explained.to99_fake(D(ii):D(ii+1));
    catch
        disp('warning= catched data')
    end
end

try
Dwhole = cat(1,Dwhole,mean(Dtemp));

catch
    Dwhole = mean(Dtemp);;

end
catch
    end
clear Dtemp out gg

end
gg1{counter} = Dwhole';
counter = counter+1
end


% figure();
% plot(Dwhole')
% gg{1} = Dwhole';
% plotme(gg)
% title('across animals');

figure();
col = winter(size(gg1,2));
hold on;
for ii = 1:7
mG1 = gg1{ii};
errorbar(mean(mG1'),std(mG1'/sqrt( length(mG1')) ),'color',col(ii,:))
title('across animals');
end
colormap(winter);
colorbar;




GG1 = [gg1{1}(1,:) gg1{2}(1,:) gg1{3}(1,:) gg1{4}(1,:) gg1{5}(1,:) gg1{6}(1,:) gg1{7}(1,:)];
GG2 = [gg1{1}(bin2use,:) gg1{2}(bin2use,:) gg1{3}(bin2use,:) gg1{4}(bin2use,:) gg1{5}(bin2use,:) gg1{6}(bin2use,:) gg1{7}(bin2use,:)];

figure(); 
hold on;
histogram(GG1,'Normalization','probability','FaceColor','b','BinWidth',0.13);
histogram(GG2,'Normalization','probability','FaceColor','r','BinWidth',0.13);


for i = 1:bin2use
    GG3(i,:) = [gg1{1}(i,:) gg1{2}(i,:) gg1{3}(i,:) gg1{4}(i,:) gg1{5}(i,:) gg1{6}(i,:) gg1{7}(i,:)];
end

figure();
hold on;
for ii = 1:7
mG1 = gg1{ii};
plot(mean(mG1'),'color',col(ii,:))
title('across animals');
end
errorbar(mean(GG3'),std(GG3'/sqrt( length(GG3')) ),'k','LineWidth',3)



% figure();
% errorbar(mean(GG3'),std(GG3'/sqrt( length(GG3')) ),'b')




