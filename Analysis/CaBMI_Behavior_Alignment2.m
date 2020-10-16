function  [timepoints] =  CaBMI_Behavior_Alignment2(Yf);


home_dir = cd;

try
    load([home_dir,'/','image_roi/Freehand_ROI.mat'])
    
catch
STD_IM = median(Yf(:,:,1:10:end),3);
[ROI] = CaBMI_ROI_freehand(uint8(STD_IM),2);
end

% Plot the whole time-series:
Mov_Vect = smooth(abs(diff(squeeze(mean(mean(Yf-median(Yf,3),2),1)))),2);
figure(); plot(Mov_Vect)
% itteratively, to save ram..
for i = 1:size(Yf,3);
    h =  mean( Yf(ROI.coordinates{1}(:,2),ROI.coordinates{1}(:,1),i),1);
    h2 =  mean( Yf(ROI.coordinates{2}(:,2),ROI.coordinates{2}(:,1),i),1);
    cc(i) = mean(h);
    cc2(i) = mean(h2);
end

pVect = double(zscore((cc)));
pVect2 = double(zscore((cc2)));

pVect = pVect-min(pVect);
pVect2 = pVect2-min(pVect2);

% Get Imaging on times
[Bpks,Imaging_on] = findpeaks(zscore((diff(pVect))),'MinPeakHeight',50,'MinPeakDistance',2);
[Bpks,Imaging_off] = findpeaks(zscore((diff(-pVect))),'MinPeakHeight',50,'MinPeakDistance',2);

% Get reward times
[Bpks2,rewards] = findpeaks(zscore(diff(pVect2)),'MinPeakHeight',4,'MinPeakDistance',2);

figure();
hold on;
plot(pVect);
plot(pVect2);
legend('Imaging status','Reward','Reward times', 'Imaging ON', 'Imaging OFF');
plot(rewards,ones(size(rewards))+10,'*y');
plot(Imaging_on,ones(size(Imaging_on))+10,'*r');
plot(Imaging_off,ones(size(Imaging_off))+10,'*b');

timepoints.Imaging_on = Imaging_on
timepoints.Imaging_off = Imaging_off;
timepoints.rewards = rewards;

