function  CaBMI_LickData(data,time);


smooth_factor = 300;

% find peaks using derivative of signal
[Apks,Alocs] = findpeaks(diff(data(:,2)),'MinPeakProminence',1,'MinPeakDistance',60);
% generate random locs
[Bpks,Blocs] = findpeaks(diff(data(:,1)),'MinPeakProminence',1,'MinPeakDistance',30);
VVect = zeros(size(data(:,2),1),1);
VVect(Blocs) = 1;

Flocs = randi(size(data(:,2),1),[size(Alocs,1),1]);

%plot peaks
figure();
hold on;
plot(data(:,2)*3.5);
plot(data(:,1));
plot(Alocs,ones(size(Alocs,1))*5,'*')

clear G
%plot aligned licks
figure();
hold on;
counter = 1;
for i = 1:size(Alocs,1);
    try
        G(:,counter) = (data(Alocs(i)-5000:Alocs(i)+10000,1));
        GF(:,counter) = (data(Flocs(i)-5000:Flocs(i)+10000,1));
        
        G_binary(:,counter)  =  VVect(Alocs(i)-5000:Alocs(i)+10000,1);
        
        GF_binary(:,counter)  = VVect(Flocs(i)-5000:Flocs(i)+10000,1);
        counter = counter+1
    catch
    end
end

figure();
subplot(1,2,1)
imagesc(G');
subplot(1,2,2);
hold on;
rr = smooth(sum(G,2),smooth_factor);
rrF = smooth(sum(GF,2),smooth_factor);
plot((1:size(rr,1))/500-10,rr);
plot((1:size(rr,1))/500-10,rrF,'--r');
x = [5000/500-10 5000/500-10];
y = [min(rr) max(rr)];
plot(x,y,'--');


col = hsv(3);
figure(); 
hold on;
for i = 1:2
    
if i ==1;
adata = G';
else
adata = GF';
end

L = size(adata,2);
se = std(adata)/8;%/sqrt(length(adata));
mn = smooth((sum(adata)/counter)',smooth_factor)';
 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(0.5);
plot(mn,'Color',col(i,:));
 
end
%
%
%
% % lick onsets...
% figure();
% subplot(1,2,1)
% imagesc(G_binary');
% subplot(1,2,2);
% hold on;
% rr = smooth(sum(G_binary,2),100);
% rrF = smooth(sum(GF_binary,2),100);
% rr = rr(2:end-5);
% rrF = rrF(2:end-5);
%
% plot((1:size(rr,1))/500,rr);
% plot((1:size(rr,1))/500,rrF,'--r');
% x = [5000/500 5000/500];
% y = [min(rr) max(rr)];
% plot(x,y,'--');
%

