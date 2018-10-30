function CaBMI_PCA_trajectory(PCAout);


figure();

gg = 1: 4: size(PCAout.PC1,3)
for i = 1:size(gg,2)-1
PCa(:,i,1) = mean(squeeze(PCAout.PC1(300:700,:,gg(i):gg(i+1))),2);
PCa(:,i,2) = mean(squeeze(PCAout.PC2(300:700,:,gg(i):gg(i+1))),2);
PCa(:,i,3) = mean(squeeze(PCAout.PC3(300:700,:,gg(i):gg(i+1))),2);
PCa(:,i,4) = mean(squeeze(PCAout.PC4(300:700,:,gg(i):gg(i+1))),2);
PCa(:,i,5) = mean(squeeze(PCAout.PC5(300:700,:,gg(i):gg(i+1))),2);
PCa(:,i,6) = mean(squeeze(PCAout.PC6(300:700,:,gg(i):gg(i+1))),2);
end


figure(); 
hold on;
col = jet(6);
for i = 1:6; 
    plot(zscore(PCa(:,:,i))+5*i,'Color',col(i,:)); 
end

counter = 1;
colorm = jet(size(PCa(:,:,6),2));
for i = 1: size(PCa(:,:,6),2)
    
%format for plotting 
A9 = zscore(PCa(:,:,1));
B9 = zscore(PCa(:,:,2));
C9 = zscore(PCa(:,:,3));
z1 = (smooth(A9(:,counter),4));%-mean(smooth(A9(1:100,counter),5));
x1 = (smooth(B9(:,counter),4));%- mean(smooth(B9(1:100,counter),5));
y1 = (smooth(C9(:,counter),4));%-mean(smooth(C9(1:100,counter),5));
obj{counter} = cat(2,x1,y1,z1); 
obj{counter}(:,4) = 1:length(obj{counter}); 
obj{counter}(:,5) = counter; % Specify object ID number 
obj{counter}(:,6) = colorm(i,1);
obj{counter}(:,7) = colorm(i,2);
obj{counter}(:,8) = colorm(i,3);
counter = counter+1;
end

figure(2);
for ii = 1:size(obj,2)
if ii == 1;
PosList = obj{1};
else
    PosList = cat(1,PosList,obj{ii});
end
end
%PosList = cat(1,obj{1},obj{2},obj{3},obj{4},obj{5},obj{6},obj{7},obj{8},obj{9},obj{10},obj{11},obj{12},obj{13},obj{14},obj{15},obj{16},obj{17},obj{18}); 
 comet3n(PosList)



figure();
st = 100;
ed = 200;
hold on;
grid on
for i = 1:size(PCa(:,:,6),2)
plot3(A9(st:ed,i),B9(st:ed,i),C9(st:ed,i),'Color',colorm(i,:))
end


% consistancy Plots
clear Bk
figure()
for ii = 1:3;
rng = 5;
for i = 1:size(A9,2)-rng;
    BBB = corr(squeeze(PCa(1:100,i:i+rng,ii)));
     Bk(ii,:,i) = mean(BBB(2:rng,1));
end
end


figure();
plot(smooth(mean(Bk,1),1),'*');

