% Center of mass analysis



% Plot traces


figure();
hold on;
for i = 1: 100;
  plot((1:length(C_dec(i,1:2688)))/30,C_dec(i,1:2688)+i*.5,'b');
  plot((1:length(C_dec(i,2688:end)))/30,C_dec(i,2688:end)+i*.5,'r');
end


% Aveage activity
G2 = mean(C_dec(:,2688:end),1);
G1 = mean(C_dec(:,1:2688),1);

V1 = var(C_dec(:,2688:end),1);
V2 = var(C_dec(:,1:2688),1);

figure(); hold on; plot((1:length(V1))/30,V1,'b'); plot((1:length(V2))/30,V2,'r');
figure(); hold on; plot((1:length(G1))/30,G1,'b'); plot((1:length(G2))/30,G2,'r');


% Average Zscored activity


for i = 1:size(C_dec,1)
  Z_dec(i,:) = zscore(C_dec(i,:));
end

  zG2 = mean(Z_dec(:,2688:end),1);
  zG1 = mean(Z_dec(:,1:2688),1);

  figure(); hold on; plot((1:length(zG1))/30,zG1,'b'); plot((1:length(zG2))/30,zG2,'r');





% estimate mean

G1(i) = mean(C_dec(:,1:2688),1);
G2(i) = mean(C_dec(:,2688:end),1);


for i = 1:100;
G3(i) = var(C_dec(i,1:2688));
G4(i) = var(C_dec(i,2688:end));
end



figure();
hold on;

h2 = histogram(G1(:),'FaceColor','b');
h1 = histogram(G2(:),'FaceColor','r');
h1.Normalization = 'probability';
h1.BinWidth = 0.005;
h2.Normalization = 'probability';
h2.BinWidth = 0.005;
title(' mean')

figure();
hold on;

h2 = histogram(G3(:),'FaceColor','b');
h1 = histogram(G4(:),'FaceColor','r');
h1.Normalization = 'probability';
h1.BinWidth = 0.005;
h2.Normalization = 'probability';
h2.BinWidth = 0.005;
title(' variance')

figure();
hold on;
boxplot(G1);
boxplot(G2);


G3 = vertcat(G1,G2);
figure
boxplot([G1,G2]);
