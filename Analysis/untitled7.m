function  CaBMI_LickData(data,tim);


% find peaks
[Apks,Alocs] = findpeaks(diff(data(:,2)),'MinPeakProminence',1,'MinPeakDistance',60);


%plot peaks

figure();
hold on;
plot(data(:,2));
plot(data(:,1));

plot(Alocs,ones(size(Alocs,1)),'*')

clear G
%plot aligned licks
figure();
hold on;
counter = 1;
for i = 1:size(Alocs,1);
    try
    G(:,counter) = (data(Alocs(i)-5000:Alocs(i)+5000,1));
    counter = counter+1
    catch
    end
end

figure(); 
imagesc(G');
