function CaBMI_DataParse(C_dec,S_dec,Input0,Input1,Timems);
% Basic parsing and plitting funciton

% params
SampRate = 9800;
trials = 19;
% find all starts/stops of tones
G = ((1:trials)*(90.1*SampRate))-(45*SampRate); % start time


cutS = G- 15*SampRate;
cutE = G+ 60*SampRate + 15*SampRate;
% figure(); hold on; plot(Input0); plot(G,ones(size(G)),'*');

% Calcium Cuts ( divide by samp rate, multiply by fr)
Ca_cutS = cutS/SampRate*30;
Ca_cutE = cutE/SampRate*30;

for i = 1:trials
Mat1(:,i) = Input0(cutS(i):cutE(i)); % auditory cues
Mat2(:,i) = Input1(cutS(i):cutE(i)); % Reward cues
for ii = 1:size(C_dec,1)
    Cal1(i,:,ii) = C_dec(ii,Ca_cutS(i):Ca_cutE(i));
end
end

figure(); 
hold on;
for i = 1:trials
plot(Mat2(:,i)-i*10);
end


% Edge Detection
cell = 2; 
figure(); 
hold on; 
for i = 1: trials
[pks, locs] = findpeaks(diff(Mat2(:,i)),'MinPeakDistance',5000,'MinPeakHeight',1);

try
 plot((1:length(Mat2))/SampRate,Mat2(locs(1)-(90000*3):end,i)-i*3);
 plot((1:size(Cal1(i,:,cell),2))/30,zscore(squeeze(Cal1(i,:,cell)))-i*4,'b');
catch
    continue
end


end




figure(); 
hold on;
cell = 3;
for i = 1:trials
plot((1:length(Mat2))/SampRate,(Mat2(:,i))-i*4,'r');
plot((1:size(Cal1(i,:,cell),2))/30,zscore(squeeze(Cal1(i,:,cell)))-i*4,'b');
end

figure(); 
s = 10;
counter = 1;
for i = 1:5;
    cell = s+counter;
    subplot(1,5,i);
    imagesc(squeeze(Cal1(:,:,cell)));
    counter = counter+1;
end


